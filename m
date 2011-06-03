Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1FCTeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:34:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34722 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab1FCTeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TIdrSNnyvF45UQbmq+JbZY77zHDkyjOMbWVMkIGCFoRici5NTv6nhVcuoDo09zboPW
         Qs8jr6b307HlADtfMB3F0HtmTLIc+3kSa8EF4U2f3vN/b5xre4j3BSpwejvYm0fAbCAm
         ceFcuv49A83HW4K8gkTR6hXgLbFvc8lxOHJ6M=
Subject: Re: bridge/netfilter: regression in 2.6.39.1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
In-Reply-To: <4DE93422.3070000@ahsoftware.de>
References: <4DE93422.3070000@ahsoftware.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 21:34:02 +0200
Message-ID: <1307129642.2600.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 03 juin 2011 à 21:21 +0200, Alexander Holler a écrit :
> Hello,
> 
> I'm getting a oops in the bridge code in br_change_mtu() with 2.6.39.1. 
> The patch below seems to fix that.
> 
> I'm not sure about the usage of dst_cow_metrics_generic() in 
> fake_dst_ops, but after having a quick look at it seems to be ok to use 
> that here.
> 
> Regards,
> 
> Alexander
> 
> -----
>  From 3c1d5951af73389798afeea672ec224e195b8e8d Mon Sep 17 00:00:00 2001
> From: Alexander Holler <holler@ahsoftware.de>
> Date: Fri, 3 Jun 2011 20:43:06 +0200
> Subject: [PATCH] bridge: add dst_cow_metrics_generic to fake_dst_ops
> 
> Commit 42923465fb8d025a2b5153f2e7ab1e6e1058bf00 does here what it
> should prevent, it introduces NULL a dereference.
> 

I cant find this commit in known trees. Could you give the real commit
id and its title ?

> The above commit uses dst_init_metrics() which sets the metrics as
> read only. As result br_change_mtu() dies in dst_metric_set()
> which calls dst_metrics_write_ptr() which calls
> dst->ops->cow_metrics() if the metrics are read only.
> ---
>   net/bridge/br_netfilter.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 5f9c091..de982a1 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -107,6 +107,7 @@ static void fake_update_pmtu(struct dst_entry *dst, 
> u32 mtu)
>   static struct dst_ops fake_dst_ops = {
>          .family =               AF_INET,
>          .protocol =             cpu_to_be16(ETH_P_IP),
> +       .cow_metrics =          dst_cow_metrics_generic,
>          .update_pmtu =          fake_update_pmtu,
>   };
> 

Your patch is mangled (white spaces instead of tabulations)

Thanks


