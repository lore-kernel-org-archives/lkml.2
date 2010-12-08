Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0LHONi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:13:38 -0500
Received: from oversea.ee-post.com ([205.209.161.131]:49467 "ehlo
	oversea.ee-post.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0LHONh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:13:37 -0500
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2010 09:13:37 EST
X-Penetrate-Bounce: Yes
X-Lasthop: 116.246.17.251
Message-ID: <EF6DDE218DB34702B1FA84D6CD7EA771@baoyb>
From: "baoyb" <baoyb@avit.org.cn>
To: <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, <alan@linux.intel.com>
Subject: Kernel Oops at tty_buffer_request_room when using pppd program (2.6.37-rc4)
Date: Wed, 8 Dec 2010 21:55:09 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="gb2312";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:

We are using a USB 3G card(HUAWEI e180) and wvdial+pppd(version 2.4.5) 
program. Sometimes kernel will crash when pppd disconnect the link. Our cpu 
platform is AMCC ppc405EX and kernel version is 2.6.37-rc4.
The following is log info when oops happened.

Unable to handle kernel paging request for data at address 0x000000d8
Faulting instruction address: 0xc0175a5c
Oops: Kernel access of bad area, sig: 11 [#1]
PowerPC 40x Platform
last sysfs file: /sys/kernel/uevent_seqnum
Modules linked in:
NIP: c0175a5c LR: c0175d9c CTR: c0211b6c
REGS: c77f7d50 TRAP: 0300   Not tainted  (2.6.37-rc4)
MSR: 00021030 <ME,CE,IR,DR>  CR: 88482028  XER: 2000005f
DEAR: 000000d8, ESR: 00000000
TASK = c71ec000[1500] 'wvdial' THREAD: c284e000
GPR00: 00021030 c77f7e00 c71ec000 00000000 0000000e 00000000 0000000e 
c0410580
GPR08: c683db00 00000000 00000001 c03c51f8 88482028 10073ef4 ffffffb9 
ffffff94
GPR16: 00000000 fde037e0 00200200 00100100 00000001 ffffff8d c712ca0c 
00000000
GPR24: c71120d4 00000000 00000000 0000000e 00021030 00000000 00000000 
0000000e
NIP [c0175a5c] tty_buffer_request_room+0x2c/0x194
LR [c0175d9c] tty_insert_flip_string_fixed_flag+0x3c/0xb0
Call Trace:
[c77f7e00] [00000003] 0x3 (unreliable)
[c77f7e30] [c0175d9c] tty_insert_flip_string_fixed_flag+0x3c/0xb0
[c77f7e60] [c0211cd0] usb_wwan_indat_callback+0x164/0x170
[c77f7e80] [c01e541c] usb_hcd_giveback_urb+0x5c/0xdc
[c77f7e90] [c01f65f0] ehci_urb_done+0xe4/0xf8
[c77f7eb0] [c01f66b8] qh_completions+0xb4/0x4d0
[c77f7f10] [c01f7788] ehci_work+0xdc/0x990
[c77f7f60] [c01fb014] ehci_irq+0x1c0/0x224
[c77f7f90] [c01e5984] usb_hcd_irq+0x68/0xa8
[c77f7fa0] [c0052848] handle_IRQ_event+0x54/0x12c
[c77f7fc0] [c00553ac] handle_level_irq+0xa0/0x13c
[c77f7fd0] [c0017ca4] uic_irq_cascade+0x100/0x128
[c77f7ff0] [c000cdb4] call_handle_irq+0x18/0x28
[c284ff10] [c0005230] do_IRQ+0xa4/0x140
[c284ff40] [c000da98] ret_from_except+0x0/0x18
Instruction dump:
4e800020 9421ffd0 7c0802a6 7d800026 bf410018 90010034 91810014 7c7e1b78
7c9f2378 7f8000a6 5780045e 7c000124 <83a300d8> 2e1d0000 4192014c 813d0010
Kernel panic - not syncing: Fatal exception in interrupt
Call Trace:
[c77f7c80] [c000700c] show_stack+0x44/0x16c (unreliable)
[c77f7cc0] [c00211f4] panic+0xa4/0x1dc
[c77f7d10] [c000abd8] die+0x190/0x19c
[c77f7d30] [c001091c] bad_page_fault+0xc0/0x108
[c77f7d40] [c000d904] handle_page_fault+0x7c/0x80
[c77f7e00] [00000003] 0x3
[c77f7e30] [c0175d9c] tty_insert_flip_string_fixed_flag+0x3c/0xb0
[c77f7e60] [c0211cd0] usb_wwan_indat_callback+0x164/0x170
[c77f7e80] [c01e541c] usb_hcd_giveback_urb+0x5c/0xdc
[c77f7e90] [c01f65f0] ehci_urb_done+0xe4/0xf8
[c77f7eb0] [c01f66b8] qh_completions+0xb4/0x4d0
[c77f7f10] [c01f7788] ehci_work+0xdc/0x990
[c77f7f60] [c01fb014] ehci_irq+0x1c0/0x224
[c77f7f90] [c01e5984] usb_hcd_irq+0x68/0xa8
[c77f7fa0] [c0052848] handle_IRQ_event+0x54/0x12c
[c77f7fc0] [c00553ac] handle_level_irq+0xa0/0x13c
[c77f7fd0] [c0017ca4] uic_irq_cascade+0x100/0x128
[c77f7ff0] [c000cdb4] call_handle_irq+0x18/0x28
[c284ff10] [c0005230] do_IRQ+0xa4/0x140
[c284ff40] [c000da98] ret_from_except+0x0/0x18
Rebooting in 1 seconds..


Any suggestions will be very appreciated.

Regards,

YunBing

 Shanghai Accurate Video Info-Tech Co.,Ltd.

Room 302-306, No.1 Building, No.33 Le Shan Road, Shanghai, 200030

TEL: 86-21-51556408-17(Ext.)

FAX: 86-21-51556407

Company Homepage: www.avit.org.cn 

