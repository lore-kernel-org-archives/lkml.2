Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0I2UpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:45:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0I2UpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:45:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y48g+r7sNB4+6GqCEyTjZzJurMa7ut+gUuxIv0tJFDtoDSwGeHzkFFD7yO8slEV80K
         tGfkegOlS/YVWBG83SpdCgR0RLorbLO9uoIl8oExntezxNZyfthkKoX3HlbVyBT2TDzq
         hp5iSiViiq4NIN6xHXSC+qAgGyGHKt+XtqfQM=
Subject: Re: [PATCH] [XFRM]: Don't dereference error pointer dst1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CA3BFA3.1060204@gmail.com>
References: <4CA3BFA3.1060204@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 22:45:13 +0200
Message-ID: <1285793113.5211.8.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 00:37 +0200, Roel Kluin a écrit :
> Don't dereference dst1 when it's an error pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  net/xfrm/xfrm_policy.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> I just noticed this by code analysis. It wasn't tested in any way.
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index cbab6e1..b186c3d 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -1414,13 +1414,14 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
>  
>  	for (; i < nx; i++) {
>  		struct xfrm_dst *xdst = xfrm_alloc_dst(net, family);
> -		struct dst_entry *dst1 = &xdst->u.dst;
> +		struct dst_entry *dst1;
>  
>  		err = PTR_ERR(xdst);
>  		if (IS_ERR(xdst)) {
>  			dst_release(dst);
>  			goto put_states;
>  		}
> +		dst1 = &xdst->u.dst;
>  
>  		if (!dst_prev)
>  			dst0 = dst1;
> 

This is not a dereference, but a cast from "struct xfrm_dst *" to
"struct dst_entry *"




