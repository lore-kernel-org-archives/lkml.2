Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1F2OMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:12:20 -0400
Received: from mail.tmr.com ([64.65.253.246]:51854 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab1F2OMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:12:17 -0400
X-Greylist: delayed 3844 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 10:12:16 EDT
Message-ID: <4E0B23AE.4070703@tmr.com>
Date: Wed, 29 Jun 2011 09:07:58 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.19) Gecko/20110420 Lightning/1.0b2 SeaMonkey/2.0.14
MIME-Version: 1.0
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
CC: Marc MERLIN <marc@merlins.org>
Subject: Re: All kinds of irq 16: nobody cared with Sandy Bridge Asus P8H67-M
 MB and multiple drivers
References: <20110626170345.GA26430@merlins.org>
In-Reply-To: <20110626170345.GA26430@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc MERLIN wrote:
> [please Cc me on replies so that I can see them faster]
>
> I've found various reports on the net, but usually they are one driver
> or one card that's not doing the right thing.
>
> In my case, it happens with multiple cards and drivers and I'm wondering if
> it can be a motherboard bug somehow, and if there are linux kernel options
> other than irqpoll which does not help, that can shed some light on this.
>
> I just bought a new Sandy Bridge board:
>          Manufacturer: ASUSTeK Computer INC.
> 	        Product Name: P8H67-M PRO
>          Vendor: American Megatrends Inc.
> 	        Version: 1003
> 		Release Date: 05/10/2011
>
> I suppose the onboard pata could be problematic, but if so why would it only
> fail when some special combination of cards share its irq?
> 03:00.0 IDE interface: VIA Technologies, Inc. Unknown device 0415
> pata_via 0000:03:00.0: version 0.3.4
> pata_via 0000:03:00.0: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
> pata_via 0000:03:00.0: setting latency timer to 64
>
> I started with 2.6.36 and now have the same problems with 2.6.39.1.
> The MB has 2 PCIe slots, and 2 PCI slots.
> 3 slots get force routed on irq 16, and the last PCI slot is irq 19.
> The onboard IDE is also irq 16.
>
> I have tried 6 different PCI and PCIe cards:
> - tg3 (gige)
> - rtl8169 (gige)
> - e100
> - CMI8738-MC6
> - sata_sil24 (sil 3132)
> - sata_mv (marvell)
>
> Pretty much all combinations where I have more than one PCI card plugged
> in a slot routed to irq16 causes
>
> irq 16: nobody cared (try booting with the "irqpoll" option)
> (...)
> handlers:
> [<c037171b>] (ata_bmdma_interrupt+0x0/0x170)
> [<f8450f1f>] (sil24_interrupt+0x0/0x443 [sata_sil24])
> [<f8449d7a>] (e100_intr+0x0/0xa2 [e100])
> Disabling IRQ #16
>
> irqpoll makes no difference.
>
> Moving the cards around helps if I only use 2 cards, one in the slot
> with irq19 (currently sound card) and one in the slot with irq16.
>
> Putting more than one card on irq 16 (not counting onboard pata) pretty
> much always causes the dreaded message.
>
> I however got one very puzzling error with an e100 in the separate irq19
> slot once too:
> kernel: irq 19: nobody cared (try booting with the "irqpoll" option)
> kernel: Pid: 0, comm: swapper Tainted: G        W   2.6.36.0-core2smp-volpreempt-noide-hm64-20100724 #1

Does this happen with an untainted kernel?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
