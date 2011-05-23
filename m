Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab1EWPVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:21:08 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:54800 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755405Ab1EWPVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:21:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kbDePleI+HF46/wQO2ASl9n2U4NS7XaR4s8WT0uOWzfhYf6CZ9bMwSF8yoh3LEgBm2Wecj/iE0WfHeLLtnaH1Jqi/TW4SYOdmPb9difjVy3uqZqkg5lf0njB/XHD0OO8;
Date: Mon, 23 May 2011 08:21:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 3/3] in scripts/export_report.pl use warn() to issue
 WARNING, so they go to stderr.
Message-Id: <20110523082103.ccced65c.rdunlap@xenotime.net>
In-Reply-To: <1305966108-13399-4-git-send-email-jim.cromie@gmail.com>
References: <1305966108-13399-1-git-send-email-jim.cromie@gmail.com>
	<1305966108-13399-4-git-send-email-jim.cromie@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 May 2011 02:21:48 -0600 Jim Cromie wrote:

> Also count CONFIG_MODVERSION warnings, and print an NB message at

CONFIG_MODVERSIONS

NB?  as in Note Well?

Please just use NOTE:

> start of SECTION 2 if any were issued.  Section 2 will be empty
> if the build is lacking this CONFIG_ item, and user may have missed
> the warnings, as they're off screen.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  scripts/export_report.pl |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/export_report.pl b/scripts/export_report.pl
> index 16bd240..14c1638 100644
> --- a/scripts/export_report.pl
> +++ b/scripts/export_report.pl
> @@ -102,6 +102,8 @@ close($module_symvers);
>  #
>  # collect the usage count of each symbol.
>  #
> +my $modversion_warnings = 0;
> +
>  foreach my $thismod (@allcfiles) {
>  	my $module;
>  
> @@ -132,7 +134,8 @@ foreach my $thismod (@allcfiles) {
>  		}
>  	}
>  	if ($state != 2) {
> -		print "WARNING:$thismod is not built with CONFIG_MODVERSION enabled\n";
> +		warn "WARNING:$thismod is not built with CONFIG_MODVERSION enabled\n";

should be CONFIG_MODVERSIONS

> +		$modversion_warnings++;
>  	}
>  	close($module);
>  }
> @@ -166,6 +169,9 @@ printf("SECTION 2:\n\tThis section reports export-symbol-usage of in-kernel
>  modules. Each module lists the modules, and the symbols from that module that
>  it uses.  Each listed symbol reports the number of modules using it\n");
>  
> +print "\nNB: Got $modversion_warnings CONFIG_MODVERSION warnings\n\n"

should be CONFIG_MODVERSIONS

and NOTE:


> +    if $modversion_warnings;
> +
>  print "~"x80 , "\n";
>  for my $thismod (sort keys %MODULE) {
>  	my $list = $MODULE{$thismod};
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
