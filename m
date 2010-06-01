Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0FAK2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:28:47 -0400
Received: from lo.gmane.org ([80.91.229.12]:52590 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0FAK2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:28:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Jindrich Makovicka <makovick@gmail.com>
Subject: [PATCH] DVB flexcop-pci sanitize driver name to avoid warning on
 load
Date: Tue, 1 Jun 2010 12:28:35 +0200
Message-ID: <20100601122835.274164cd@holly>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/LTIRuvntKwZbTVEE8wiuAFy"
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 84.42.166.196
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/LTIRuvntKwZbTVEE8wiuAFy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

DVB driver for Flexcop/Technisat receiver currently calls request_irq()
with a long driver name containing slashes. This triggers a warning
when kernel tries to create /proc/irq/[NN]/[driver name] directory
(attached to avoid mangling).

The patch in attachment changes the driver name used in
pci_request_regions() and request_irq() to a shorter version without
slashes.

Signed-off-by: Jindrich Makovicka <makovick@gmail.com>

-- 
Jindrich Makovicka

--MP_/LTIRuvntKwZbTVEE8wiuAFy
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=warn.txt

Jun  1 11:53:30 holly kernel: flexcop-pci: will use the HW PID filter.
Jun  1 11:53:30 holly kernel: flexcop-pci: card revision 2
Jun  1 11:53:30 holly kernel: b2c2_flexcop_pci 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jun  1 11:53:30 holly kernel: ------------[ cut here ]------------
Jun  1 11:53:30 holly kernel: WARNING: at fs/proc/generic.c:317 __xlate_proc_name+0xb5/0xd0()
Jun  1 11:53:30 holly kernel: Hardware name: P55M-UD4
Jun  1 11:53:30 holly kernel: name 'Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver'
Jun  1 11:53:30 holly kernel: Modules linked in: b2c2_flexcop_pci(+) btusb b2c2_flexcop videodev snd_timer snd_seq_device usbhid(+) bluetooth snd v4l2_compat_ioctl32 blackmagic(P+) usb_storage i2c_i801 dvb_core snd_page_alloc nvidia(P) i2c_core lirc_mceusb2 lirc_dev uhci_hcd ehci_hcd firewire_ohci firewire_core r8169 mii usbcore [last unloaded: scsi_wait_scan]
Jun  1 11:53:30 holly kernel: Pid: 1363, comm: modprobe Tainted: P            2.6.35-rc1 #2
Jun  1 11:53:30 holly kernel: Call Trace:
Jun  1 11:53:30 holly kernel:  [<ffffffff8103f58b>] ? warn_slowpath_common+0x7b/0xc0
Jun  1 11:53:30 holly kernel:  [<ffffffff8103f685>] ? warn_slowpath_fmt+0x45/0x50
Jun  1 11:53:30 holly kernel:  [<ffffffff811102c5>] ? __xlate_proc_name+0xb5/0xd0
Jun  1 11:53:30 holly kernel:  [<ffffffff8111089e>] ? __proc_create+0x7e/0x150
Jun  1 11:53:30 holly kernel:  [<ffffffff81111247>] ? proc_mkdir_mode+0x27/0x60
Jun  1 11:53:30 holly kernel:  [<ffffffff81078b15>] ? register_handler_proc+0x115/0x130
Jun  1 11:53:30 holly kernel:  [<ffffffff81076291>] ? __setup_irq+0x1d1/0x320
Jun  1 11:53:30 holly kernel:  [<ffffffffa0048160>] ? flexcop_pci_isr+0x0/0x190 [b2c2_flexcop_pci]
Jun  1 11:53:30 holly kernel:  [<ffffffff810764e3>] ? request_threaded_irq+0x103/0x160
Jun  1 11:53:30 holly kernel:  [<ffffffffa0048495>] ? flexcop_pci_probe+0x1a5/0x330 [b2c2_flexcop_pci]
Jun  1 11:53:30 holly kernel:  [<ffffffff81238202>] ? local_pci_probe+0x12/0x20
Jun  1 11:53:30 holly kernel:  [<ffffffff81238bbc>] ? pci_device_probe+0x8c/0xc0
Jun  1 11:53:30 holly kernel:  [<ffffffff812bcaca>] ? driver_sysfs_add+0x5a/0x80
Jun  1 11:53:30 holly kernel:  [<ffffffff812bcbf7>] ? driver_probe_device+0x87/0x1a0
Jun  1 11:53:30 holly kernel:  [<ffffffff812bcda3>] ? __driver_attach+0x93/0xa0
Jun  1 11:53:30 holly kernel:  [<ffffffff812bcd10>] ? __driver_attach+0x0/0xa0
Jun  1 11:53:30 holly kernel:  [<ffffffff812bc328>] ? bus_for_each_dev+0x58/0x80
Jun  1 11:53:30 holly kernel:  [<ffffffff812bbb00>] ? bus_add_driver+0xb0/0x250
Jun  1 11:53:30 holly kernel:  [<ffffffff812bd090>] ? driver_register+0x70/0x130
Jun  1 11:53:30 holly kernel:  [<ffffffff81238e6c>] ? __pci_register_driver+0x4c/0xc0
Jun  1 11:53:30 holly kernel:  [<ffffffffa005b000>] ? flexcop_pci_module_init+0x0/0x20 [b2c2_flexcop_pci]
Jun  1 11:53:30 holly kernel:  [<ffffffff810001d4>] ? do_one_initcall+0x34/0x1a0
Jun  1 11:53:30 holly kernel:  [<ffffffff8106fc4e>] ? sys_init_module+0xde/0x260
Jun  1 11:53:30 holly kernel:  [<ffffffff8100246b>] ? system_call_fastpath+0x16/0x1b
Jun  1 11:53:30 holly kernel: ---[ end trace 14b94af06f60b8de ]---
Jun  1 11:53:30 holly kernel: DVB: registering new adapter (FlexCop Digital TV device)
Jun  1 11:53:30 holly kernel: b2c2-flexcop: MAC address = 00:d0:d7:0c:ea:51

--MP_/LTIRuvntKwZbTVEE8wiuAFy
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=b2c2.diff

--- flexcop-pci.c~	2010-05-16 23:17:36.000000000 +0200
+++ flexcop-pci.c	2010-06-01 12:10:05.982776836 +0200
@@ -38,7 +38,7 @@
 	DEBSTATUS);
 
 #define DRIVER_VERSION "0.1"
-#define DRIVER_NAME "Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver"
+#define DRIVER_NAME "b2c2_flexcop_pci"
 #define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@desy.de>"
 
 struct flexcop_pci {
@@ -448,5 +448,5 @@
 module_exit(flexcop_pci_module_exit);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_NAME);
+MODULE_DESCRIPTION("Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver");
 MODULE_LICENSE("GPL");


--MP_/LTIRuvntKwZbTVEE8wiuAFy--


