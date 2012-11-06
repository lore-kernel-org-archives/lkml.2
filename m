Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2KFESq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 23:18:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33055 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753012Ab2KFESp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 23:18:45 -0500
Message-ID: <1352175520.16194.14.camel@joe-AO722>
Subject: Re: [PATCH 001/104] checkpatch: warn about using CONFIG_EXPERIMENTAL
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Mon, 05 Nov 2012 20:18:40 -0800
In-Reply-To: <1352156701-4038-2-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
	 <1352156701-4038-2-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 15:03 -0800, Kees Cook wrote:
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
> index 21a9f5d..f8b33ed 100755
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
> +			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see:\nhttps://lkml.org/lkml/2012/10/23/580\n");
> +		}
> +
>  		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
>  		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
>  			my $flag = $1;

Couple bits of trivia:

Perhaps this would be better if it didn't just check Kconfig
files and simply looked for any use of CONFIG_EXPERIMENTAL

	$line =~ /^\+.*\bCONFIG_EXPERIMENTAL\b/

I think the output WARN would be better on single line.

"Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives see https://lkml.org/lkml/2012/10/23/580\n"

