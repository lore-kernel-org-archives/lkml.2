Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2GZJI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:08:26 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:38002 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2GZJIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:08:25 -0400
Date: Thu, 26 Jul 2012 03:08:24 -0600 (MDT)
From: Paul Walmsley <paul@booyaka.com>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Update alignment check
In-Reply-To: <1339613458.28729.5.camel@joe2Laptop>
Message-ID: <alpine.DEB.2.00.1207260306590.30049@utopia.booyaka.com>
References: <1339613458.28729.5.camel@joe2Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy, Joe,

On Wed, 13 Jun 2012, Joe Perches wrote:

> Parenthesis alignment doesn't correctly check an existing line
> after an inserted or modified line with an open parenthesis.
> 
> Fix it.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Paul Walmsley <paul@pwsan.com>
Tested-by: Paul Walmsley <paul@pwsan.com>

This fixes some bogus checkpatch warnings here.  Andy, any chance this 
patch can make it in for 3.6-rc?

> ---
>  scripts/checkpatch.pl |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index e5bd60f..630319a 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1848,8 +1848,8 @@ sub process {
>  
>  			my $pos = pos_last_openparen($rest);
>  			if ($pos >= 0) {
> -				$line =~ /^\+([ \t]*)/;
> -				my $newindent = $1;
> +				$line =~ /^(\+| )([ \t]*)/;
> +				my $newindent = $2;
>  
>  				my $goodtabindent = $oldindent .
>  					"\t" x ($pos / 8) .
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


- Paul
