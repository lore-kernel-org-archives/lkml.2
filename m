Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2LEXhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:37:05 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40010 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LEXhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:37:04 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH -next] TTY: hvsi: use for_each_compatible_node() macro
To: Wei Yongjun <weiyj.lk@gmail.com>, gregkh@linuxfoundation.org,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd-bpkWo6PeKrB1VqCiYMxCvphvMbs34Raoh89Wm0ubK-A@mail.gmail.com>
References: <CAPgLHd-bpkWo6PeKrB1VqCiYMxCvphvMbs34Raoh89Wm0ubK-A@mail.gmail.com>
Date: Wed, 05 Dec 2012 23:36:58 +0000
Message-Id: <20121205233658.5DCC23E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012 00:16:18 -0500, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Use for_each_compatible_node() macro instead of open coding it.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/tty/hvc/hvsi.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
> index 5b95b4f..70e0ef7 100644
> --- a/drivers/tty/hvc/hvsi.c
> +++ b/drivers/tty/hvc/hvsi.c
> @@ -1187,9 +1187,7 @@ static int __init hvsi_console_init(void)
>  	hvsi_wait = poll_for_state; /* no irqs yet; must poll */
>  
>  	/* search device tree for vty nodes */
> -	for (vty = of_find_compatible_node(NULL, "serial", "hvterm-protocol");
> -			vty != NULL;
> -			vty = of_find_compatible_node(vty, "serial", "hvterm-protocol")) {
> +	for_each_compatible_node(vty, "serial", "hvterm-protocol") {
>  		struct hvsi_struct *hp;
>  		const uint32_t *vtermno, *irq;
>  
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
