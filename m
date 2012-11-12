Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2KLXGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:06:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37679 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752267Ab2KLXGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:06:22 -0500
Message-ID: <1352761583.18715.16.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: warn about using CONFIG_EXPERIMENTAL
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 12 Nov 2012 15:06:23 -0800
In-Reply-To: <20121112225019.GA23718@www.outflux.net>
References: <20121112225019.GA23718@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 14:50 -0800, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, it is being removed.  This will discourage future addition of
> CONFIG_EXPERIMENTAL while it is being phased out.

You should also cc Andrew Morton (cc'd)

> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  scripts/checkpatch.pl |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index f18750e..41e364b 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1757,6 +1757,15 @@ sub process {
>  			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
>  		}
>  
> +# discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.
> +		if ($realfile =~ /Kconfig/ &&
> +		    $line =~ /.\s*depends on\s+.*\bEXPERIMENTAL\b/) {

This is after the deleted lines check so this won't trigger
on deleted lines.

> +			WARN("CONFIG_EXPERIMENTAL",
> +			     "Use of CONFIG_EXPERIMENTAL is deprecated. " +
> +			     "For alternatives, see " +
> +			     "https://lkml.org/lkml/2012/10/23/580\n");

I'd much prefer this be on a single line and not using the +
string operator as that style is not currently used in checkpatch.

> +		}
> +
>  		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
>  		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
>  			my $flag = $1;
> @@ -1912,6 +1921,14 @@ sub process {
>  # check we are in a valid C source file if not then ignore this hunk
>  		next if ($realfile !~ /\.(h|c)$/);
>  
> +# discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
> +		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {

Same as previous reply just a few minutes ago

There are many config uses like:
        #if defined(CONFIG_FOO)
and
        #if defined CONFIG_FOO || defined CONFIG_BAR

so I think any line that has this specific config option is suspect.
> +			WARN("CONFIG_EXPERIMENTAL",
> +			     "Use of CONFIG_EXPERIMENTAL is deprecated. " +
> +			     "For alternatives, see " +
> +			     "https://lkml.org/lkml/2012/10/23/580\n");
> +		}



