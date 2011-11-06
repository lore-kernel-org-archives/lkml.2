Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1KFS1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 13:27:07 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:54972 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670Ab1KFS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 13:27:05 -0500
X-IronPort-AV: E=Sophos;i="4.69,465,1315173600"; 
   d="scan'208";a="128733405"
Date: Sun, 6 Nov 2011 19:17:05 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
cc: julia@diku.dk, mmarek@suse.cz, rdunlap@xenotime.net, Gilles.Muller@lip6.fr,
        npalix.work@gmail.com, cocci@diku.dk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND 1/2] coccicheck: add M= option to control which dir is
 processed
In-Reply-To: <1320544784-24576-2-git-send-email-Gregory.Dietsche@cuw.edu>
Message-ID: <alpine.DEB.2.02.1111061916370.1873@hadrien>
References: <1320544784-24576-1-git-send-email-Gregory.Dietsche@cuw.edu> <1320544784-24576-2-git-send-email-Gregory.Dietsche@cuw.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Nov 2011, Gregory.Dietsche@cuw.edu wrote:

> From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
>
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

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
> scripts/coccicheck |   19 ++++++++++++++-----
> 1 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index 1bb1a1b..3c27764 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -9,14 +9,23 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
> #    FLAGS="-ignore_unknown_options -very_quiet"
> #    OPTIONS=$*
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
> else
>     ONLINE=0
>     FLAGS="-very_quiet"
> -    OPTIONS="-dir $srctree"
> +    if [ "$KBUILD_EXTMOD" = "" ] ; then
> +        OPTIONS="-dir $srctree"
> +    else
> +        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include -I $KBUILD_EXTMOD/include"
> +    fi
> fi
>
> if [ ! -x "$SPATCH" ]; then
> -- 
> 1.7.6.4
>
>
