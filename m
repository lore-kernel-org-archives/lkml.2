Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0EIJMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 05:12:16 -0400
Received: from ist.d-labs.de ([213.239.218.44]:54653 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0EIJMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 05:12:13 -0400
Date: Sun, 9 May 2010 11:12:09 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scripts/get_maintainer.pl: add .get_maintainer.conf
 default options file
Message-ID: <20100509111209.6c871a68@schatten.dmk.lab>
In-Reply-To: <1273357609.704.70.camel@Joe-Laptop.home>
References: <4BE46E7D.1040906@s5r6.in-berlin.de>
	<1273354364-6016-1-git-send-email-florian@mickler.org>
	<1273357609.704.70.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 May 2010 15:26:49 -0700
Joe Perches <joe@perches.com> wrote:

> Allow the use of a .get_maintainer.conf file to control the
> default options applied when scripts/get_maintainer.pl is run.
> 
> .get_maintainer.conf entries can be any valid argument.
> 
> Multiple lines may be used, blank lines ignored, # is a comment
> 
> Signed-off-by: Joe Perches <joe@perches.com>
 
probably worth noting, that an entry is of the form 

"--cmdlinearg" 

as that's unexpected for a config file.

> ---
>  scripts/get_maintainer.pl |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index 6f97a13..0c4c7e0 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -97,6 +97,30 @@ my %VCS_cmds_hg = (
>      "blame_commit_pattern" => "^([0-9a-f]+):"
>  );
>  
> +if (-f ${lk_path}.get_maintainer.conf) {

missing "" around the argument to -f ...

i wouldn't put the trailing slash in the variables but add it when composing path's.
but it seems this is the convention for get_maintainer.pl... 


 

> +    my @conf_args;
> +    open(my $conffile, '<', "${lk_path}.get_maintainer.conf")
> +	or warn "$P: Can't open .get_maintainer.conf: $!\n";
> +    while (<$conffile>) {
> +	my $line = $_;
> +
> +	$line =~ s/\s*\n?$//g;
> +	$line =~ s/^\s*//g;
> +	$line =~ s/\s+/ /g;
> +
> +	next if ($line =~ m/^\s*#/);
> +	next if ($line =~ m/^\s*$/);
> +
> +	my @words = split(" ", $line);
> +	foreach my $word (@words) {
> +	    last if ($word =~ m/^#/);
> +	    push (@conf_args, $word);
> +	}
> +    }
> +    close($conffile);
> +    unshift(@ARGV, @conf_args) if @conf_args;
> +}

this works.

> +
>  if (!GetOptions(
>  		'email!' => \$email,
>  		'git!' => \$email_git,
> 

Reviewed-by:Florian Mickler <florian@mickler.org>

