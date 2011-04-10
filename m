Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab1DJW7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 18:59:37 -0400
Received: from mail1.mail-ng.de ([79.140.41.65]:41403 "EHLO mail1.mail-ng.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab1DJW7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 18:59:35 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Apr 2011 18:59:35 EDT
Date: Mon, 11 Apr 2011 00:52:32 +0200
From: Lasse Lindner <linux@lasse-lindner.de>
To: linux-kernel@vger.kernel.org
Subject: dvb-t: crash with smsmdtv/smsdvb (2.6.38.2)
Message-ID: <20110411005232.24408178@ws>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this happens on 2.6.38.2 (I had the problem in .37 too, therefore I
upgraded) on an ARM machine (Guruplug ServerPlus) with my USB DVB-T
Stick from Hauppauge ("WinTV Ministick") in use with the
corresponding smsmdtv and smsdvb modules. The DVB-T Stick is 24/7 in
use by vdr (http://www.tvdr.de). I get this crash only  "every now
and then", like, a couple of hours or a couple of days (but it comes,
for sure). So I can only reproduce it by patience.

dmesg output:
--------------------------------------------------------------------------------------------------------------
[...]
Unable to handle kernel paging request at virtual address e1682000
pgd = df3fc000
[e1682000] *pgd=1f22e811, *pte=00000000, *ppte=00000000
Internal error: Oops: 7 [#1]
last sysfs file: /sys/devices/platform/orion-ehci.0/usb1/1-1/1-1.1/bcdDevice
Modules linked in: rfcomm l2cap xt_tcpudp iptable_filter ipt_addrtype ip_tables x_tables smsdvb dvb_core ir_lirc_codec smsusb lirc_dev smsmdtv rc_core pl2303 usbserial usb_storage btmrvl_sdio libertas_sdio btmrvl libertas bluetooth sg ehci_hcd
CPU: 0    Not tainted  (2.6.38.2 #1)
PC is at memcpy+0x188/0x3a4
LR is at 0xd95d0430
pc : [<c01d85a8>]    lr : [<d95d0430>]    psr: 20000013
sp : dbd73e90  ip : 7275626d  fp : dbd73eb0
r10: e1681f14  r9 : 61482073  r8 : 614405f9
r7 : 00726567  r6 : 00ff4e57  r5 : 01003000  r4 : 00450270
r3 : 00d95d04  r2 : 00000100  r1 : e1681ff4  r0 : 42f78e60
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005397f  Table: 1f3fc000  DAC: 00000015
Process vdr (pid: 5708, stack limit = 0xdbd72270)
Stack: (0xdbd73e90 to 0xdbd74000)
3e80:                                     42f78d93 dbd72000 0000026d 00000000
3ea0: dbd73eb4 42f78d93 000004fc c01e137c ddcd0340 dbd7f5e0 000004fc e131c194
3ec0: 42f78d93 000004fc 000004fc dbd72000 dbd73f10 000004fc 00000000 bf0c06d0
3ee0: e131c194 e131c194 42f78d93 000004fc dbd73f04 bf0b7424 e131c1a8 00000800
3f00: 00000d28 db469740 df2fd2d4 df2fd318 00000013 df2fd2d4 0000c089 e131c140
3f20: 00000003 42f78d93 dcd56300 00000ffd e131c1b0 00000000 42f79dbc bf0b75bc
3f40: 00001000 dcd56300 42f78d90 dbd73f80 00001000 dbd72000 00000000 c009dbf4
3f60: dcd56300 42f78d90 dcd56300 42f78d90 00000000 00000000 00001000 c009dd08
3f80: 00000000 00000000 00001000 00000001 00000005 00001000 42f78d90 00000003
3fa0: c0029c04 c0029a80 00000005 00001000 00000005 42f78d90 00001000 00000005
3fc0: 00000005 00001000 42f78d90 00000003 42f78d20 00000012 42f79d90 42f79dbc
3fe0: 00000000 42f78cf8 400358cc 40036034 80000010 00000005 1fffe831 1fffec31
Code: f5d1f07c e8b100f0 e1a0342e e2522020 (e8b15300) 
---[ end trace 27b9f433ce7b3d20 ]---


