Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2AWJoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 04:44:04 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46467 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab2AWJoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 04:44:02 -0500
Message-ID: <1327311836.2525.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] netdev/ethernet: dev_alloc_skb to netdev_alloc_skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Viral Mehta <viral.vkm@gmail.com>
Cc: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Date: Mon, 23 Jan 2012 10:43:56 +0100
In-Reply-To: <CANX6Da=Y5zJ4xi8=gLZZ8tUnnqxNCpvC0yBGruObWzYHrucLLg@mail.gmail.com>
References: <1327179463-13980-1-git-send-email-netdev@pradeepdalvi.com>
	 <CANX6Da=Y5zJ4xi8=gLZZ8tUnnqxNCpvC0yBGruObWzYHrucLLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 23 janvier 2012 à 14:10 +0530, Viral Mehta a écrit :
> On Sun, Jan 22, 2012 at 2:27 AM, Pradeep A. Dalvi
> <netdev@pradeepdalvi.com> wrote:
> > Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
> >
> > Signed-off-by: Pradeep A. Dalvi <netdev@pradeepdalvi.com>
> 
> and these too ??
> 
> vmehta@viralmehta:~/linux-3.2/drivers/infiniband/hw$ grep dev_alloc_skb -r .
> ./ipath/ipath_driver.c:	skb = __dev_alloc_skb(len, gfp_mask);
> ./nes/nes_cm.c:	skb = dev_alloc_skb(MAX_CM_BUFFER);
> ./nes/nes_cm.c:		skb = dev_alloc_skb(MAX_CM_BUFFER);

Those should probably use a mere alloc_skb(), since they dont need the
NET_SKB_PAD

> ./nes/nes_cm.c:		skb = dev_alloc_skb(MAX_CM_BUFFER);
> ./nes/nes_cm.c:		skb = dev_alloc_skb(MAX_CM_BUFFER);
> ./nes/nes_cm.c:		skb = dev_alloc_skb(MAX_CM_BUFFER);
> ./nes/nes_hw.c:		skb = dev_alloc_skb(nesvnic->max_frame_size);
> ./nes/nes_hw.c:		skb = dev_alloc_skb(nesvnic->max_frame_size);
> ./nes/nes_mgt.c:		skb = dev_alloc_skb(mgtvnic->nesvnic->max_frame_size);
> ./nes/nes_mgt.c:			skb = dev_alloc_skb(nesvnic->max_frame_size);
> ./amso1100/c2.c:	skb = dev_alloc_skb(c2_port->rx_buf_size);
> vmehta@viralmehta:~/linux-3.2/drivers/infiniband/hw$
> --


