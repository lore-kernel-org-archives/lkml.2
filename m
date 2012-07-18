Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2GRLdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:33:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59109 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2GRLdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <1342574175.2012.12.camel@joe2Laptop>
References: <1342442513-10488-1-git-send-email-yamanetoshi@gmail.com>
	<1342573366-8167-1-git-send-email-yamanetoshi@gmail.com>
	<1342574175.2012.12.camel@joe2Laptop>
Date: Wed, 18 Jul 2012 20:32:58 +0900
Message-ID: <CAOTypNSvKEfYVLZ=0sN-U+2xiXBO4So4QkvYyKniEFeqvkqVBg@mail.gmail.com>
Subject: Re: [PATCH] staging/et131x: fix checkpatch warnings
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark.einon@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for you reply.

I will fix netdev_info only, because I don't know if I should use "%p".

On Wed, Jul 18, 2012 at 10:16 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-07-18 at 10:02 +0900, Toshiaki Yamane wrote:
>> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
>
> Hello.  Just some trivial notes:
>
>> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> []
>> @@ -2553,8 +2555,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
> []
>> -     printk(KERN_INFO "Packet Status Ring %lx\n",
>> -         (unsigned long) rx_ring->ps_ring_physaddr);
>> +     pr_info("Packet Status Ring %lx\n",
>> +             (unsigned long) rx_ring->ps_ring_physaddr);
>> @@ -2574,7 +2576,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
> []
>> -     printk(KERN_INFO "PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);
>> +     pr_info("PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);
>
> These might as well use %p without a cast to unsigned long
>         pr_info("Packet Status Ring: %p\n", rx_ring->ps_ring_phydaddr);
> []
>         pr_info("PRS: %p\n", rx_ring->rx_status_bus);
>
> []
>> @@ -5186,8 +5188,8 @@ static int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
> []
>> -     printk(KERN_INFO "%s: Setting MAC address to %pM\n",
>> -                     netdev->name, netdev->dev_addr);
>> +     pr_info("%s: Setting MAC address to %pM\n",
>> +             netdev->name, netdev->dev_addr);
>
> Please use netdev_<level> when there is a
> struct net_device * available.
>
>         netdev_info(netdev, "Setting MAC address to %pM\n", netdev->dev_addr);
>
>



-- 

Regards,


 .
  .
...

Yamane Toshiaki

yamanetoshi@gmail.com
