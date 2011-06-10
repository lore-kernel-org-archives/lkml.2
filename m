Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1FJK4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:56:47 -0400
Received: from ist.d-labs.de ([213.239.218.44]:56040 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597Ab1FJK4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:56:46 -0400
Date: Fri, 10 Jun 2011 12:56:18 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ryan Mallon <rmallon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] get_maintainers.pl: Improve .mailmap parsing
Message-ID: <20110610125618.311d8c27@schatten.dmk.lab>
In-Reply-To: <1307702243.20439.31.camel@Joe-Laptop>
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>
	<20110610025532.GE26006@linux-sh.org>
	<4DF189F2.3040009@gmail.com>
	<1307675512.20439.2.camel@Joe-Laptop>
	<4DF18BDC.8010306@gmail.com>
	<1307676240.20439.9.camel@Joe-Laptop>
	<4DF1902A.1040305@gmail.com>
	<20110610035115.GF26006@linux-sh.org>
	<4DF19565.9070601@gmail.com>
	<1307679288.20439.15.camel@Joe-Laptop>
	<1307702243.20439.31.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 03:37:23 -0700
Joe Perches <joe@perches.com> wrote:

> Entries that used formats other than "Proper Name <commit@email.xx>"
> were not parsed properly.
> 
> Try to improve the parsing so that the entries in the forms of:
>     Proper Name <proper@email.xx> <commit@email.xx>
> and
>     Proper Name <proper@email.xx> Commit Name <commit@email.xx>
> are transformed correctly.
> 
> Signed-off-by: Joe Perches <joe@perches.com> 


Yup. Looks good. 

Reviewed-By: Florian Mickler <florian@mickler.org>

> ---
>  scripts/get_maintainer.pl |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index d29a8d7..eb2f1e6 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -328,7 +328,8 @@ sub read_mailmap {
>  	# name1 <mail1> <mail2>
>  	# name1 <mail1> name2 <mail2>
>  	# (see man git-shortlog)
> -	if (/^(.+)<(.+)>$/) {
> +
> +	if (/^([^<]+)<([^>]+)>$/) {
>  	    my $real_name = $1;
>  	    my $address = $2;
>  
> @@ -336,13 +337,13 @@ sub read_mailmap {
>  	    ($real_name, $address) = parse_email("$real_name <$address>");
>  	    $mailmap->{names}->{$address} = $real_name;
>  
> -	} elsif (/^<([^\s]+)>\s*<([^\s]+)>$/) {
> +	} elsif (/^<([^>]+)>\s*<([^>]+)>$/) {
>  	    my $real_address = $1;
>  	    my $wrong_address = $2;
>  
>  	    $mailmap->{addresses}->{$wrong_address} = $real_address;
>  
> -	} elsif (/^(.+)<([^\s]+)>\s*<([^\s]+)>$/) {
> +	} elsif (/^(.+)<([^>]+)>\s*<([^>]+)>$/) {
>  	    my $real_name = $1;
>  	    my $real_address = $2;
>  	    my $wrong_address = $3;
> @@ -353,7 +354,7 @@ sub read_mailmap {
>  	    $mailmap->{names}->{$wrong_address} = $real_name;
>  	    $mailmap->{addresses}->{$wrong_address} = $real_address;
>  
> -	} elsif (/^(.+)<([^\s]+)>\s*([^\s].*)<([^\s]+)>$/) {
> +	} elsif (/^(.+)<([^>]+)>\s*(.+)\s*<([^>]+)>$/) {
>  	    my $real_name = $1;
>  	    my $real_address = $2;
>  	    my $wrong_name = $3;
