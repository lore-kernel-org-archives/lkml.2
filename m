Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963Ab1IIVO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:14:58 -0400
Received: from mxin.vub.ac.be ([134.184.129.112]:23717 "EHLO mxin.vub.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549Ab1IIVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:14:57 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Sep 2011 17:14:56 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEGANB7ak6GuBhX/2dsb2JhbABCFoQ/nQSHM4FSAQEFIwRSEAsaAiYCAlcGE4d4AqVokhWBLIQxgREEmD0QjAc
Subject: Re: [E1000-devel] e1000e: NIC not working (after resume?)
From: Frederik Himpe <fhimpe@telenet.be>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 09 Sep 2011 23:05:02 +0200
In-Reply-To: <CAEuXFEz5si7tOxcpkmnVTuHovOm=8c+eXHGp+CtGNj9b=VjLeA@mail.gmail.com>
References: <j4d428$ndo$1@dough.gmane.org> <j4d569$ndo$2@dough.gmane.org>
	 <CAEuXFEz5si7tOxcpkmnVTuHovOm=8c+eXHGp+CtGNj9b=VjLeA@mail.gmail.com>
Organization: Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315602302.16869.25.camel@defected>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 10:28 -0700, Jesse Brandeburg wrote:

> > # dmesg | grep -E "e1000e|eth0"
> > [    1.027437] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
> > [    1.027441] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
> > [    1.027480] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> > [    1.027491] e1000e 0000:00:19.0: setting latency timer to 64
> > [    1.027605] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [    1.231440] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:21:70:e1:bb:4c
> > [    1.231444] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> > [    1.231470] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1004FF-0FF
> > [   22.896268] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [   22.952097] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [   22.954132] ADDRCONF(NETDEV_UP): eth0: link is not ready
> > [   24.504903] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> > [   24.506413] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
> > [   24.508402] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> > [   34.788022] eth0: no IPv6 routers present
> > [   41.444922] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> > [   41.446325] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
> > [25136.918393] e1000e 0000:00:19.0: PME# enabled
> > [25142.488050] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf6ae0000-0xf6afffff] (PCI address [0xf6ae0000-0xf6afffff])
> > [25142.488058] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf6adb000-0xf6adbfff] (PCI address [0xf6adb000-0xf6adbfff])
> > [25142.488066] e1000e 0000:00:19.0: BAR 2: set to [io  0xefe0-0xefff] (PCI address [0xefe0-0xefff])
> > [25142.488085] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > [25142.488110] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> > [25142.488167] e1000e 0000:00:19.0: PME# disabled
> > [25142.510966] e1000e 0000:00:19.0: PCI INT A disabled
> > [25142.510971] e1000e 0000:00:19.0: PME# enabled
> > [25143.468668] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > [25143.468689] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0xefe1)
> > [25143.468696] e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xf6adb000)
> > [25143.468703] e1000e 0000:00:19.0: restoring config space at offset 0x4 (was 0x0, writing 0xf6ae0000)
> > [25143.468713] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> > [25143.471149] e1000e 0000:00:19.0: PME# disabled
> > [25143.471277] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [25145.276441] e1000e 0000:00:19.0: PME# enabled
> > [25146.082051] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf6ae0000-0xf6afffff] (PCI address [0xf6ae0000-0xf6afffff])
> > [25146.082076] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf6adb000-0xf6adbfff] (PCI address [0xf6adb000-0xf6adbfff])
> > [25146.082090] e1000e 0000:00:19.0: BAR 2: set to [io  0xefe0-0xefff] (PCI address [0xefe0-0xefff])
> > [25146.082126] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > [25146.082169] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> > [25146.082280] e1000e 0000:00:19.0: PME# disabled
> > [25146.176605] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [25146.232228] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [25146.234003] ADDRCONF(NETDEV_UP): eth0: link is not ready
> > [25147.328875] e1000e 0000:00:19.0: PME# enabled
> > [26261.896126] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf6ae0000-0xf6afffff] (PCI address [0xf6ae0000-0xf6afffff])
> > [26261.896140] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf6adb000-0xf6adbfff] (PCI address [0xf6adb000-0xf6adbfff])
> > [26261.896149] e1000e 0000:00:19.0: BAR 2: set to [io  0xefe0-0xefff] (PCI address [0xefe0-0xefff])
> > [26261.896169] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > [26261.896196] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> > [26261.896241] e1000e 0000:00:19.0: PME# disabled
> > [26261.896316] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [26261.972148] e1000e 0000:00:19.0: PME# enabled
> > [26268.192160] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf6ae0000-0xf6afffff] (PCI address [0xf6ae0000-0xf6afffff])
> > [26268.192168] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf6adb000-0xf6adbfff] (PCI address [0xf6adb000-0xf6adbfff])
> > [26268.192175] e1000e 0000:00:19.0: BAR 2: set to [io  0xefe0-0xefff] (PCI address [0xefe0-0xefff])
> > [26268.192194] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > [26268.192219] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> > [26268.192274] e1000e 0000:00:19.0: PME# disabled
> > [26268.213875] e1000e 0000:00:19.0: PME# enabled
> > [26269.172481] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > [26269.172497] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0xefe1)
> > [26269.172502] e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xf6adb000)
> > [26269.172507] e1000e 0000:00:19.0: restoring config space at offset 0x4 (was 0x0, writing 0xf6ae0000)
> > [26269.172515] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> > [26269.174262] e1000e 0000:00:19.0: PME# disabled
> > [26269.174339] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [26272.384806] e1000e 0000:00:19.0: PME# enabled
> > [26274.688310] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26275.482490] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26276.277343] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26277.075194] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26277.870807] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26278.667881] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26279.463492] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26280.258982] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26281.056598] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26281.855386] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26282.649838] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26283.445674] e1000e 0000:00:19.0: eth0: Error reading PHY register
> > [26289.848036] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf6ae0000-0xf6afffff] (PCI address [0xf6ae0000-0xf6afffff])
> > [26289.848044] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf6adb000-0xf6adbfff] (PCI address [0xf6adb000-0xf6adbfff])
> > [26289.848050] e1000e 0000:00:19.0: BAR 2: set to [io  0xefe0-0xefff] (PCI address [0xefe0-0xefff])
> > [26289.848067] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > [26289.848090] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> > [26289.848146] e1000e 0000:00:19.0: PME# disabled
> > [26289.940279] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [26289.996092] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [26289.996761] ADDRCONF(NETDEV_UP): eth0: link is not ready
> > [26291.088343] e1000e 0000:00:19.0: PME# enabled
> > [26900.272077] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf6ae0000-0xf6afffff] (PCI address [0xf6ae0000-0xf6afffff])
> > [26900.272096] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf6adb000-0xf6adbfff] (PCI address [0xf6adb000-0xf6adbfff])
> > [26900.272111] e1000e 0000:00:19.0: BAR 2: set to [io  0xefe0-0xefff] (PCI address [0xefe0-0xefff])
> > [26900.272142] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > [26900.272180] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> > [26900.272250] e1000e 0000:00:19.0: PME# disabled
> > [26900.272379] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [26900.274426] e1000e 0000:00:19.0: eth0: MAC Wakeup cause - Link Status Change
> > [26905.560584] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
> > [26905.560591] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
> > [26905.560650] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> > [26905.560665] e1000e 0000:00:19.0: setting latency timer to 64
> > [26905.560836] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [26905.744547] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:21:70:e1:bb:4c
> > [26905.744552] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> > [26905.744581] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1004FF-0FF
> > [26905.744594] e1000e 0000:00:19.0: PME# enabled
> > [26905.880141] e1000e 0000:00:19.0: BAR 0: set to [mem 0xf6ae0000-0xf6afffff] (PCI address [0xf6ae0000-0xf6afffff])
> > [26905.880149] e1000e 0000:00:19.0: BAR 1: set to [mem 0xf6adb000-0xf6adbfff] (PCI address [0xf6adb000-0xf6adbfff])
> > [26905.880155] e1000e 0000:00:19.0: BAR 2: set to [io  0xefe0-0xefff] (PCI address [0xefe0-0xefff])
> > [26905.880172] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> > [26905.880194] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
> > [26905.880247] e1000e 0000:00:19.0: PME# disabled
> > [26905.968320] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [26906.024395] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> > [26906.025907] ADDRCONF(NETDEV_UP): eth0: link is not ready
> > [26907.112415] e1000e 0000:00:19.0: PME# enabled
> > [27308.975856] device eth0 entered promiscuous mode
> > [27326.414382] device eth0 left promiscuous mode
> > [27336.815362] device eth0 entered promiscuous mode
> >
> > * Right after start up: machine is in docking station, network is working
> > fine.
> > * At 25136: resume machine, not in docking station, no network cable
> > plugged in, so network connection was not tested.
> > * At 26261: resume machine, in docking station, network cable plugged in,
> > but network connection is not working
> 
> but was the light blinking or solid? (link light) or was it just out.
> 
> > * At 26900: rmmod e1000e && modprobe e1000e: network still not working
> 
> it almost sounds like something in the docking station is not quite
> waking successfully.  If the device is in D3, the wake signal was
> either missed by the system, or never asserted.  If you unplug the
> link and plug it back in, with the driver loaded and it reporting D3
> (should go to PME+ and then D0 once cable is plugged in ) does it
> help?

I don't have the docking station at hand here, but I was able to
reproduce the problem without the docking station.

Full syslog (221 KB) is at
http://artipc10.vub.ac.be/~frederik/e1000e/syslog

This is what happened:
* 21:33:11: cold boot, network cable plugged in, network working fine
* 21:35:24: start suspend to ram
* 21:35:40: resume system, e1000e network working fine (however, wlan
now refuses to connect, but I have not investigated that, not sure if
whether this might be related or not)
* 21:52:44: logs are filled up with an endless loop of these messages (I
think I disconnected the network cable at that time:

Sep  9 21:52:44 defected kernel: [ 1188.440061] ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0xfed1c000-0xfed1c3ff] (PCI address [0xfed1c000-0xfed1c3ff])
Sep  9 21:52:44 defected kernel: [ 1188.440097] ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x104)
Sep  9 21:52:44 defected kernel: [ 1188.440137] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
Sep  9 21:52:44 defected kernel: [ 1188.447422] ehci_hcd 0000:00:1d.7: PME# disabled
Sep  9 21:52:44 defected kernel: [ 1188.447446] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Sep  9 21:52:44 defected kernel: [ 1188.447461] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Sep  9 21:52:44 defected kernel: [ 1188.447519] ehci_hcd 0000:00:1d.7: PCI INT A disabled
Sep  9 21:52:44 defected kernel: [ 1188.447588] ehci_hcd 0000:00:1d.7: PME# enabled
Sep  9 21:52:44 defected kernel: [ 1188.468704] ehci_hcd 0000:00:1a.7: BAR 0: set to [mem 0xfed1c400-0xfed1c7ff] (PCI address [0xfed1c400-0xfed1c7ff])
Sep  9 21:52:44 defected kernel: [ 1188.468739] ehci_hcd 0000:00:1a.7: restoring config space at offset 0xf (was 0x300, writing 0x30a)
Sep  9 21:52:44 defected kernel: [ 1188.468778] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
Sep  9 21:52:44 defected kernel: [ 1188.476179] ehci_hcd 0000:00:1a.7: PME# disabled
Sep  9 21:52:44 defected kernel: [ 1188.476201] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Sep  9 21:52:44 defected kernel: [ 1188.476215] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Sep  9 21:52:44 defected kernel: [ 1188.476264] ehci_hcd 0000:00:1a.7: PCI INT C disabled
Sep  9 21:52:44 defected kernel: [ 1188.476325] ehci_hcd 0000:00:1a.7: PME# enabled
Sep  9 21:52:44 defected kernel: [ 1188.500063] ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0xfed1c000-0xfed1c3ff] (PCI address [0xfed1c000-0xfed1c3ff])
Sep  9 21:52:44 defected kernel: [ 1188.500097] ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x104)
Sep  9 21:52:44 defected kernel: [ 1188.500136] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
Sep  9 21:52:44 defected kernel: [ 1188.507398] ehci_hcd 0000:00:1d.7: PME# disabled
Sep  9 21:52:44 defected kernel: [ 1188.507418] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Sep  9 21:52:44 defected kernel: [ 1188.507431] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Sep  9 21:52:44 defected kernel: [ 1188.507499] ehci_hcd 0000:00:1d.7: PCI INT A disabled
Sep  9 21:52:44 defected kernel: [ 1188.507560] ehci_hcd 0000:00:1d.7: PME# enabled
Sep  9 21:52:44 defected kernel: [ 1188.528053] ehci_hcd 0000:00:1a.7: BAR 0: set to [mem 0xfed1c400-0xfed1c7ff] (PCI address [0xfed1c400-0xfed1c7ff])
Sep  9 21:52:44 defected kernel: [ 1188.528085] ehci_hcd 0000:00:1a.7: restoring config space at offset 0xf (was 0x300, writing 0x30a)
Sep  9 21:52:44 defected kernel: [ 1188.528124] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
Sep  9 21:52:44 defected kernel: [ 1188.535363] ehci_hcd 0000:00:1a.7: PME# disabled
Sep  9 21:52:44 defected kernel: [ 1188.535382] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Sep  9 21:52:44 defected kernel: [ 1188.535396] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Sep  9 21:52:44 defected kernel: [ 1188.535455] ehci_hcd 0000:00:1a.7: PCI INT C disabled
Sep  9 21:52:44 defected kernel: [ 1188.535517] ehci_hcd 0000:00:1a.7: PME# enabled
Sep  9 21:52:44 defected kernel: [ 1188.560164] ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0xfed1c000-0xfed1c3ff] (PCI address [0xfed1c000-0xfed1c3ff])
Sep  9 21:52:44 defected kernel: [ 1188.560198] ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x104)
Sep  9 21:52:44 defected kernel: [ 1188.560237] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
Sep  9 21:52:44 defected kernel: [ 1188.568578] ehci_hcd 0000:00:1d.7: PME# disabled
Sep  9 21:52:44 defected kernel: [ 1188.568600] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Sep  9 21:52:44 defected kernel: [ 1188.568614] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Sep  9 21:52:44 defected kernel: [ 1188.568663] ehci_hcd 0000:00:1d.7: PCI INT A disabled
Sep  9 21:52:44 defected kernel: [ 1188.568724] ehci_hcd 0000:00:1d.7: PME# enabled


Are there any other tests I can do to help finding out what's wrong?
-- 
Frederik Himpe <fhimpe@telenet.be>

