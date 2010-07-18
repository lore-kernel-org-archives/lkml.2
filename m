Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0GRXIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 19:08:47 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:53068 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab0GRXIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 19:08:46 -0400
Date: Mon, 19 Jul 2010 01:13:24 +0200
From: Yann Dirson <ydirson@altern.org>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Yann Dirson <ydirson@altern.org>
Subject: [PATCH] via82cxxx: fix typo for VT6415 PCIE PATA IDE Host
 Controller support.
Message-ID: <1279494644-3762-1-git-send-email-ydirson@altern.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 1.7.1
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this fix, init of the via82cxxx driver causes a oops with a
stack resembling the one below, and the boot blocks between init of
USB devices and launch of init (was easy to bisect by booting with
init=/bin/sh).

 Pid: 279, comm: work_for_cpu Not tainted 2.6.34.1-00003-ga42ea77 #2
 Call Trace:
  [<ffffffff81045691>] ? warn_slowpath_common+0x76/0x8c
  [<ffffffff810456f9>] ? warn_slowpath_fmt+0x40/0x45
  [<ffffffff812eb5a1>] ? printk+0x40/0x47
  [<ffffffff8108e1fd>] ? enable_irq+0x3e/0x64
  [<ffffffffa0003900>] ? ide_probe_port+0x55c/0x589 [ide_core]
  [<ffffffffa0003f22>] ? ide_host_register+0x273/0x628 [ide_core]
  [<ffffffffa00083e3>] ? ide_pci_init_two+0x4da/0x5c5 [ide_core]
  [<ffffffff8106117e>] ? up+0xe/0x36
  [<ffffffff81045d7e>] ? release_console_sem+0x17e/0x1ae
  [<ffffffff812d945b>] ? klist_iter_exit+0x14/0x1e
  [<ffffffff8120ed23>] ? bus_find_device+0x75/0x83
  [<ffffffffa0022832>] ? via_init_one+0x269/0x28a [via82cxxx]
  [<ffffffffa00223a2>] ? init_chipset_via82cxxx+0x0/0x1ea [via82cxxx]
  [<ffffffff81059f25>] ? do_work_for_cpu+0x0/0x1b
  [<ffffffff81190c65>] ? local_pci_probe+0x12/0x16
  [<ffffffff81059f30>] ? do_work_for_cpu+0xb/0x1b
  [<ffffffff8105d0dd>] ? kthread+0x75/0x7d
  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
  [<ffffffff8105d068>] ? kthread+0x0/0x7d
  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
 ---[ end trace 89c8cb70379b5bda ]---

The typo was introduced in a354ae8747d0687093ce244e76b15b6174d2f098,
and affects 2.6.33-rc4 and later.

Signed-off-by: Yann Dirson <ydirson@altern.org>
---
 drivers/ide/via82cxxx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index 101f400..d2a0997 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -79,7 +79,7 @@ static struct via_isa_bridge {
 	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt6415",	PCI_DEVICE_ID_VIA_6410,     0x00, 0xff, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0xff, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-- 
1.7.1

