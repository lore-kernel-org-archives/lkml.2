Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1FDQkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 12:40:13 -0400
Received: from kremilek.roznovan.cz ([46.36.54.7]:37602 "EHLO
	kremilek.roznovan.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1FDQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 12:40:11 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jun 2011 12:40:11 EDT
X-Sagator-Scanner: 1.2.0-1 at kremilek.roznovan.cz;
	log(log(status(report(drop(quarantine(buffer2mbox(libclam()))))),
	status(drop(quarantine(SpamAssassinD())))))
X-Sagator-ID: 20110604-182424-0001-06518-S2x81j@kremilek.roznovan.cz
Message-ID: <4DEA5D78.5030402@centrum.cz>
Date: Sat, 04 Jun 2011 18:29:44 +0200
From: Karel Gardas <karel.gardas@centrum.cz>
User-Agent: Mozilla/5.0 (X11; U; SunOS i86pc; en-US; rv:1.9.2.9) Gecko/20101021 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ETH over USB: NFS state (seeking ARM platform for NFS-based builds)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

while searching for ARMv7/NEON platform for my own hacking I've found 
this interesting issue:

[ 2945.114135] cc1: page allocation failure. order:3, mode:0x4020
[ 2945.114196] [<c005a420>] (unwind_backtrace+0x0/0xe0) from 
[<c0107e98>] (__alloc_pages_nodemask+0x5a0/0x6b4)
[ 2945.114227] [<c0107e98>] (__alloc_pages_nodemask+0x5a0/0x6b4) from 
[<c0107fbc>] (__get_free_pages+0x10/0x24)
[ 2945.114257] [<c0107fbc>] (__get_free_pages+0x10/0x24) from 
[<c012f494>] (kmalloc_order_trace+0x20/0xc8)
[ 2945.114288] [<c012f494>] (kmalloc_order_trace+0x20/0xc8) from 
[<c04882fc>] (__alloc_skb+0x50/0xe0)
[ 2945.114318] [<c04882fc>] (__alloc_skb+0x50/0xe0) from [<c038b2ec>] 
(rx_submit+0x24/0x1cc)
[ 2945.114349] [<c038b2ec>] (rx_submit+0x24/0x1cc) from [<c0395524>] 
(usb_hcd_giveback_urb+0xa0/0xec)
[ 2945.114379] [<c0395524>] (usb_hcd_giveback_urb+0xa0/0xec) from 
[<c03a1650>] (ehci_urb_done+0xa8/0xb4)
[ 2945.114410] [<c03a1650>] (ehci_urb_done+0xa8/0xb4) from [<c03a5488>] 
(qh_completions+0xb4/0x3d8)
[ 2945.114440] [<c03a5488>] (qh_completions+0xb4/0x3d8) from 
[<c03a5d94>] (scan_async+0x90/0x144)
[ 2945.114440] [<c03a5d94>] (scan_async+0x90/0x144) from [<c03a6504>] 
(ehci_work+0x30/0x88)
[ 2945.114471] [<c03a6504>] (ehci_work+0x30/0x88) from [<c03a83f0>] 
(ehci_irq+0x2f4/0x35c)
[ 2945.114471] [<c03a83f0>] (ehci_irq+0x2f4/0x35c) from [<c0394e90>] 
(usb_hcd_irq+0x38/0x7c)
[ 2945.114501] [<c0394e90>] (usb_hcd_irq+0x38/0x7c) from [<c00d89b4>] 
(handle_IRQ_event+0x9c/0x1b4)
[ 2945.114532] [<c00d89b4>] (handle_IRQ_event+0x9c/0x1b4) from 
[<c00da5dc>] (handle_level_irq+0xdc/0x160)
[ 2945.114562] [<c00da5dc>] (handle_level_irq+0xdc/0x160) from 
[<c004e088>] (asm_do_IRQ+0x88/0xc8)
[ 2945.114593] [<c004e088>] (asm_do_IRQ+0x88/0xc8) from [<c05bb128>] 
(__irq_usr+0x48/0x120)


which is reported here:
https://bugs.launchpad.net/ubuntu/+source/linux-ti-omap4/+bug/690370 and 
which happens during the NFS usage over ETH over USB. Also the issue 
seems to be more discussed here:

http://marc.info/?t=130406641000006&r=1&w=2
http://marc.info/?t=130471082300010&r=1&w=2

but as Oliver Neukum wrote me in a private reply, this issue is still 
unsolved and Ming Lei two weeks ago also noted this in the bug report 
above. Now, my question is: is this really true, i.e. people with ARM 
boards which are using ETH over USB are either not using NFS or while 
using NFS they get kernel crash? I'm curious and hence asking since 
majority of low-cost ARM boards for hobby developers are using ETH over 
USB. So far I've found just board with Marvell Armada 510 and with 
Tegra2 which are using some kind of sane ethernet either implemented 
on-chip (Armada 510) or by PCIe hooked realtek (tegra2 in trimslice). 
All other popular platforms like OMAP3/4 (Beagle/Panda boards), just to 
be released ST-Ericsson Snowball, Samsung Origen (this does not provide 
ETH at all, so hooking ETH to USB is the only option here) all are using 
ETH over USB.

So are all those popular and low-cost boards really out of question for 
building/porting free software to ARM and yet using NFS for build 
directories?

Any reports of first-hand experiences with this are highly appreciated 
here as I'm going to use this on my hardware decision.

Thanks a lot,
Karel
