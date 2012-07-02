Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab2GBTsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:48:31 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:58554 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2GBTsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:48:30 -0400
Message-ID: <1341258507.4325.7.camel@piranha.localdomain>
Subject: 3.5-rc4: Sense Key : Illegal Request [current] when booting with
 audio cd in sr0
From: Frederik Himpe <fhimpe@telenet.be>
To: linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 21:48:27 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had an audio cd in my DVD+-RW drive when I booted up my Linux 3.5-rc4
system. While booting, I saw lots of errors related to sr0 scrolling
over the screen continuously, until I ejected the disc from the driver.
After that the system continued booting normally.

Seems like my log buffers overflowed because of the flood of errors.
Here is a sample of what I found in my logs:

Jul  2 21:05:04 piranha kernel: [   13.542408] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul  2 21:05:04 piranha kernel: [   13.542409] sr 2:0:0:0: [sr0]  
Jul  2 21:05:04 piranha kernel: [   13.542411] Sense Key : Illegal Request [current] 
Jul  2 21:05:04 piranha kernel: [   13.542412] sr 2:0:0:0: [sr0]  
Jul  2 21:05:04 piranha kernel: [   13.542415] Add. Sense: Illegal mode for this track
Jul  2 21:05:04 piranha kernel: [   13.542416] sr 2:0:0:0: [sr0] CDB: 
Jul  2 21:05:04 piranha kernel: [   13.542420] Read(10): 28 00 00 00 00 01 00 00 01 00
Jul  2 21:05:04 piranha kernel: [   13.542422] end_request: I/O error, dev sr0, sector 4
Jul  2 21:05:04 piranha kernel: [   13.548531] sr 2:0:0:0: [sr0]  
Jul  2 21:05:04 piranha kernel: [   13.548533] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul  2 21:05:04 piranha kernel: [   13.548534] sr 2:0:0:0: [sr0]  
Jul  2 21:05:04 piranha kernel: [   13.548536] Sense Key : Illegal Request [current] 
Jul  2 21:05:04 piranha kernel: [   13.548537] sr 2:0:0:0: [sr0]  
Jul  2 21:05:04 piranha kernel: [   13.548540] Add. Sense: Illegal mode for this track
Jul  2 21:05:04 piranha kernel: [   13.548541] sr 2:0:0:0: [sr0] CDB: 
Jul  2 21:05:04 piranha kernel: [   13.548546] Read(10): 28 00 00 00 00 04 00 00 01 00
Jul  2 21:05:04 piranha kernel: [   13.548547] end_request: I/O error, dev sr0, sector 16
Jul  2 21:05:04 piranha kernel: [   13.554677] sr 2:0:0:0: [sr0]  
Jul  2 21:05:04 piranha kernel: [   13.554678] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul  2 21:05:04 piranha kernel: [   13.554680] sr 2:0:0:0: [sr0]  
Jul  2 21:05:04 piranha kernel: [   13.554681] Sense Key : Illegal Request [current] 
Jul  2 21:05:04 piranha kernel: [   13.554683] sr 2:0:0:0: [sr0]  
Jul  2 21:05:04 piranha kernel: [   13.554685] Add. Sense: Illegal mode for this track
Jul  2 21:05:04 piranha kernel: [   13.554687] sr 2:0:0:0: [sr0] CDB: 
Jul  2 21:05:04 piranha kernel: [   13.554691] Read(10): 28 00 00 00 00 05 00 00 01 00
Jul  2 21:05:04 piranha kernel: [   13.554693] end_request: I/O error, dev sr0, sector 20
Jul  2 21:05:04 piranha kernel: [   13.560842] sr 2:0:0:0: [sr0]  
Jul  2 21:05:04 piranha kernel: [   13.560844] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul  2 21:05:04 piranha kernel: [   13.560845] sr 2:0:0:0: [sr0]  

System is an Asrock H77 Pro4/MVP motherboard with a Lite-On sata
dvd-drive iHAS124.

00:00.0 Host bridge [0600]: Intel Corporation 3rd Gen Core processor DRAM Controller [8086:0150] (rev 09)
00:01.0 PCI bridge [0604]: Intel Corporation 3rd Gen Core processor PCI Express Root Port [8086:0151] (rev 09)
00:02.0 Display controller [0380]: Intel Corporation 3rd Gen Core processor Graphics Controller [8086:0162] (rev 09)
00:14.0 USB controller [0c03]: Intel Corporation 7 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04)
00:16.0 Communication controller [0780]: Intel Corporation 7 Series Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
00:1a.0 USB controller [0c03]: Intel Corporation 7 Series Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
00:1b.0 Audio device [0403]: Intel Corporation 7 Series Chipset Family High Definition Audio Controller [8086:1e20] (rev 04)
00:1c.0 PCI bridge [0604]: Intel Corporation 7 Series Chipset Family PCI Express Root Port 1 [8086:1e10] (rev c4)
00:1c.4 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev c4)
00:1c.5 PCI bridge [0604]: Intel Corporation 7 Series Chipset Family PCI Express Root Port 6 [8086:1e1a] (rev c4)
00:1c.7 PCI bridge [0604]: Intel Corporation 7 Series Chipset Family PCI Express Root Port 8 [8086:1e1e] (rev c4)
00:1d.0 USB controller [0c03]: Intel Corporation 7 Series Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
00:1f.0 ISA bridge [0601]: Intel Corporation H77 Express Chipset LPC Controller [8086:1e4a] (rev 04)
00:1f.2 SATA controller [0106]: Intel Corporation 7 Series Chipset Family 6-port SATA AHCI Controller [8086:1e02] (rev 04)
00:1f.3 SMBus [0c05]: Intel Corporation 7 Series Chipset Family SMBus Controller [8086:1e22] (rev 04)
01:00.0 VGA compatible controller [0300]: Advanced Micro Devices [AMD] nee ATI PITCAIRN PRO [Radeon HD 7800 Series] [1002:6819]
01:00.1 Audio device [0403]: Advanced Micro Devices [AMD] nee ATI Device [1002:aab0]
03:00.0 PCI bridge [0604]: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge [1b21:1080] (rev 01)
05:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 06)
06:00.0 SATA controller [0106]: ASMedia Technology Inc. ASM1062 Serial ATA Controller [1b21:0612] (rev 01)


-- 
Frederik Himpe <fhimpe@telenet.be>

