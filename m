Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1KDBzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 21:55:19 -0400
Received: from que11.charter.net ([209.225.8.21]:61966 "EHLO que11.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab1KDBzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 21:55:17 -0400
X-Greylist: delayed 1889 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Nov 2011 21:55:16 EDT
X-Authority-Analysis: v=1.1 cv=3kn4snR/2TdwuYXvh+wm0CPnSGzQFWY7ukd303aPFv0=
 c=1 sm=1 a=0Ba-A2mVnIQA:10 a=fInHslpUf1IA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=Xn_9bg-9RIJM3UlDOtcA:9 a=wPNLvfGTeEIA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4EB33D44.5070502@cuw.edu>
Date: Thu, 03 Nov 2011 20:17:56 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
CC: julia@diku.dk, Nicolas.Palix@inria.fr, rdunlap@xenotime.net,
        Gilles.Muller@lip6.fr, cocci@diku.dk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] coccicheck: add M= option to control which dir
 is processed
References: <4DF3A447.3050505@cuw.edu> <1307814782-27415-1-git-send-email-Gregory.Dietsche@cuw.edu>
In-Reply-To: <1307814782-27415-1-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/11/2011 12:53 PM, Greg Dietsche wrote:
> Examples:
> 	make coccicheck M=drivers/net/wireless/
> 	make coccicheck SUBDIRS=drivers/net/wireless/
>
> Version 2:
> 	fix patch file names when using M=
> 	tell coccinelle where the include files are
>
> Version 3:
> 	Add second include option to support out of tree development
> 	Fix error message
>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> ---
>  scripts/coccicheck |   19 ++++++++++++++-----
>  1 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index 1bb1a1b..3c27764 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -9,14 +9,23 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
>  #    FLAGS="-ignore_unknown_options -very_quiet"
>  #    OPTIONS=$*
>  
> -# Workaround for Coccinelle < 0.2.3
> -    FLAGS="-I $srctree/include -very_quiet"
> -    shift $(( $# - 1 ))
> -    OPTIONS=$1
> +    if [ "$KBUILD_EXTMOD" = "" ] ; then
> +        # Workaround for Coccinelle < 0.2.3
> +        FLAGS="-I $srctree/include -very_quiet"
> +        shift $(( $# - 1 ))
> +        OPTIONS=$1
> +    else
> +	echo M= is not currently supported when C=1 or C=2
> +	exit 1
> +    fi
>  else
>      ONLINE=0
>      FLAGS="-very_quiet"
> -    OPTIONS="-dir $srctree"
> +    if [ "$KBUILD_EXTMOD" = "" ] ; then
> +        OPTIONS="-dir $srctree"
> +    else
> +        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include -I $KBUILD_EXTMOD/include"
> +    fi
>  fi
>  
>  if [ ! -x "$SPATCH" ]; then

what's the process for getting this into the kernel tree?

Greg

