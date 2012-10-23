Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092Ab2JWW7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:59:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49431 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933805Ab2JWW7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:59:23 -0400
Date: Tue, 23 Oct 2012 23:59:19 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002/193] checkpatch: warn about using CONFIG_EXPERIMENTAL
Message-ID: <20121023225919.GB3179@localhost>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:01:15PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, it is being removed.  This will discourage future addition of
> CONFIG_EXPERIMENTAL while it is being phased out.
> 
> Cc: Andy Whitcroft <apw@canonical.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  scripts/checkpatch.pl |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 21a9f5d..37dc932 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1757,6 +1757,13 @@ sub process {
>  			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
>  		}
>  
> +# Discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.
> +		if ($realfile =~ /Kconfig/ &&
> +		    $line =~ /.\s*depends on\s+.*\bEXPERIMENTAL\b/) {
> +			WARN("CONFIG_EXPERIMENTAL",
> +			     "Use of CONFIG_EXPERIMENTAL is deprecated.\n");
> +		}
> +

Seem reasonable.  Should you suggest how they can mark things
experimental?  I assume (EXPERIMENTAL) in the title is now the right
way?

>  		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
>  		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
>  			my $flag = $1;

-apw
