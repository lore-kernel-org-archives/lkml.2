Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2AUHfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 02:35:34 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:6405 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983Ab2AUHfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 02:35:33 -0500
X-IronPort-AV: E=Sophos;i="4.71,547,1320620400"; 
   d="scan'208";a="140839774"
Message-ID: <4F1A6AC1.70300@inria.fr>
Date: Sat, 21 Jan 2012 08:35:29 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
CC: julia.lawall@lip6.fr, mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccicheck: change handling of C={1,2} when M= is set
References: <4F1928FC.8090300@inria.fr> <1327101035-7684-1-git-send-email-Gregory.Dietsche@cuw.edu> <1327101035-7684-2-git-send-email-Gregory.Dietsche@cuw.edu>
In-Reply-To: <1327101035-7684-2-git-send-email-Gregory.Dietsche@cuw.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot Greg, make C=2 CHECK=script/coccicheck M=... is back.

Tested-by: Brice Goglin <Brice.Goglin@inria.fr>



Le 21/01/2012 00:10, Greg Dietsche a écrit :
> This patch reverts a portion of d0bc1fb4 so that coccicheck will
> work properly when C=1 or C=2.
>
> Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> ---
>  scripts/coccicheck |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index 3c27764..823e972 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -9,15 +9,10 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
>  #    FLAGS="-ignore_unknown_options -very_quiet"
>  #    OPTIONS=$*
>  
> -    if [ "$KBUILD_EXTMOD" = "" ] ; then
> -        # Workaround for Coccinelle < 0.2.3
> -        FLAGS="-I $srctree/include -very_quiet"
> -        shift $(( $# - 1 ))
> -        OPTIONS=$1
> -    else
> -	echo M= is not currently supported when C=1 or C=2
> -	exit 1
> -    fi
> +# Workaround for Coccinelle < 0.2.3
> +	FLAGS="-I $srctree/include -very_quiet"
> +	shift $(( $# - 1 ))
> +	OPTIONS=$1
>  else
>      ONLINE=0
>      FLAGS="-very_quiet"

