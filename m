Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab0EYUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab0EYUZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:25:26 -0400
Date: Tue, 25 May 2010 16:25:21 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Dominik Brodowski <linux@dominikbrodowski.net>
cc: linux-kernel@vger.kernel.org
Subject: PCMCIA regression
Message-ID: <Pine.LNX.4.64.1005251619020.12278@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The commit a8408c17d0038b76a83affb1b56dc18fa1e7ed86 in Linux 2.6.34-rc6 
broke pcmcia for me. I use 3c574 network card in yenta socket on Armada 
7400 laptop. My distribution is Debian lenny.

Reverting the test for "s->functions" in pccard_validate_cis makes the 
network card work again.

Mikulas

May 20 14:17:21 gerlinda vmunix: ------------[ cut here ]------------
May 20 14:17:21 gerlinda vmunix: WARNING: at drivers/pcmcia/cistpl.c:1488 
pccard_validate_cis+0x287/0x2d0 [pcmcia]()
May 20 14:17:21 gerlinda vmunix: Modules linked in: 3c574_cs ohci_hcd 
pcmcia rtc_cmos crc32 ide_cd_mod rtc_core usbcore rtc_lib yenta_socket 
cdrom psmouse pcspkr rsrc_nonstatic nls_base pcmcia_core unix
May 20 14:17:21 gerlinda vmunix: Pid: 1486, comm: pccardd Not tainted 
2.6.34-fast #15
May 20 14:17:21 gerlinda vmunix: Call Trace:
May 20 14:17:21 gerlinda vmunix:  [<cc95cc57>] ? 
pccard_validate_cis+0x287/0x2d0 [pcmcia]
May 20 14:17:21 gerlinda vmunix:  [<cc95cc57>] ? 
pccard_validate_cis+0x287/0x2d0 [pcmcia]
May 20 14:17:21 gerlinda vmunix:  [<c10207d6>] ? 
warn_slowpath_common+0x76/0xd0 May 20 14:17:21 gerlinda vmunix:  
[<cc95cc57>] ? pccard_validate_cis+0x287/0x2d0 [pcmcia]
May 20 14:17:21 gerlinda vmunix:  [<c1020843>] ? 
warn_slowpath_null+0x13/0x20
May 20 14:17:21 gerlinda vmunix:  [<cc95cc57>] ? 
pccard_validate_cis+0x287/0x2d0 [pcmcia]
May 20 14:17:21 gerlinda vmunix:  [<cc83517a>] ? 
pcmcia_nonstatic_validate_mem+0xda/0x180 [rsrc_nonstatic]
May 20 14:17:21 gerlinda vmunix:  [<c10ce0af>] ? 
sysfs_addrm_finish+0x7f/0xb0
May 20 14:17:21 gerlinda vmunix:  [<cc9587c2>] ? pcmcia_card_add+0x72/0xf0 
[pcmcia]
May 20 14:17:21 gerlinda vmunix:  [<c10f39e0>] ? kobject_release+0x0/0xa0
May 20 14:17:21 gerlinda vmunix:  [<c10f44c9>] ? kref_put+0x29/0x60
May 20 14:17:21 gerlinda vmunix:  [<cc9577cc>] ? 
pcmcia_card_remove+0x8c/0xa0 [pcmcia]
May 20 14:17:21 gerlinda vmunix:  [<cc958a24>] ? pcmcia_requery+0x74/0x130 
[pcmcia]
May 20 14:17:21 gerlinda vmunix:  [<c101af4e>] ? set_next_entity+0x2e/0x70
May 20 14:17:21 gerlinda vmunix:  [<c101c500>] ? 
do_sched_setscheduler+0x90/0xa0May 20 14:17:21 gerlinda vmunix:  
[<c11c0883>] ? schedule+0x203/0x3c0
May 20 14:17:21 gerlinda vmunix:  [<cc818109>] ? pccardd+0x219/0x470 
[pcmcia_core]
May 20 14:17:21 gerlinda vmunix:  [<c11c095a>] ? schedule+0x2da/0x3c0
May 20 14:17:21 gerlinda vmunix:  [<cc817ef0>] ? pccardd+0x0/0x470 
[pcmcia_core]May 20 14:17:21 gerlinda vmunix:  [<c1035124>] ? 
kthread+0x74/0x80
May 20 14:17:21 gerlinda vmunix:  [<c10350b0>] ? kthread+0x0/0x80
May 20 14:17:21 gerlinda vmunix:  [<c10030f6>] ? 
kernel_thread_helper+0x6/0x10
May 20 14:17:21 gerlinda vmunix: ---[ end trace 256ec3e16d1d0f46 ]---



