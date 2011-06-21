Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1FUJpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:45:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:40808 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1FUJpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:45:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: 3.0-rc3 kmemleak reports
Date: Tue, 21 Jun 2011 11:40:15 +0200
Message-ID: <itpou0$leu$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: tc-gate2.pci.uni-heidelberg.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reasons I build a kernel with kmemleak support and got a few 
reports.

(squeeze-x86_64)fslab2:~# cat /sys/kernel/debug/kmemleak

unreferenced object 0xffff8800bf738000 (size 512):
   comm "swapper", pid 1, jiffies 4294892604 (age 48783.440s)
   hex dump (first 32 bytes):
     00 00 00 cc 00 00 00 00 ff ff 3f ce 00 00 00 00  ..........?.....
     c8 e3 49 bf 00 88 ff ff 00 02 00 00 00 00 00 00  ..I.............
   backtrace:
     [<ffffffff813779be>] kmemleak_alloc+0x5e/0xc0
     [<ffffffff8113c3f3>] __kmalloc+0x133/0x1e0
     [<ffffffff812d8ad9>] get_current_resources+0x79/0x1b0
     [<ffffffff8137cdff>] pci_acpi_scan_root+0x14a/0x1a7
     [<ffffffff8137bb30>] acpi_pci_root_add+0x197/0x36b
     [<ffffffff8123179a>] acpi_device_probe+0x50/0x122
     [<ffffffff812a21e7>] really_probe+0x77/0x240
     [<ffffffff812a23eb>] driver_probe_device+0x3b/0x80
     [<ffffffff812a24cb>] __driver_attach+0x9b/0xa0
     [<ffffffff812a14ec>] bus_for_each_dev+0x6c/0xa0
     [<ffffffff812a1f9e>] driver_attach+0x1e/0x20
     [<ffffffff812a1940>] bus_add_driver+0x200/0x2b0
     [<ffffffff812a2b30>] driver_register+0x80/0x150
     [<ffffffff81232705>] acpi_bus_register_driver+0x43/0x45
     [<ffffffff8188df34>] acpi_pci_root_init+0x1e/0x2d
     [<ffffffff81002073>] do_one_initcall+0x43/0x190

unreferenced object 0xffff8801fa6c8948 (size 192):
   comm "swapper", pid 1, jiffies 4294892696 (age 48783.072s)
   hex dump (first 32 bytes):
     00 00 50 df 00 00 00 00 ff ff 6f df 00 00 00 00  ..P.......o.....
     18 1e 7b fa 01 88 ff ff 00 02 00 00 00 00 00 00  ..{.............
   backtrace:
     [<ffffffff813779be>] kmemleak_alloc+0x5e/0xc0
     [<ffffffff8113c3f3>] __kmalloc+0x133/0x1e0
     [<ffffffff812d8ad9>] get_current_resources+0x79/0x1b0
     [<ffffffff8137cdff>] pci_acpi_scan_root+0x14a/0x1a7
     [<ffffffff8137bb30>] acpi_pci_root_add+0x197/0x36b
     [<ffffffff8123179a>] acpi_device_probe+0x50/0x122
     [<ffffffff812a21e7>] really_probe+0x77/0x240
     [<ffffffff812a23eb>] driver_probe_device+0x3b/0x80
     [<ffffffff812a24cb>] __driver_attach+0x9b/0xa0
     [<ffffffff812a14ec>] bus_for_each_dev+0x6c/0xa0
     [<ffffffff812a1f9e>] driver_attach+0x1e/0x20
     [<ffffffff812a1940>] bus_add_driver+0x200/0x2b0
     [<ffffffff812a2b30>] driver_register+0x80/0x150
     [<ffffffff81232705>] acpi_bus_register_driver+0x43/0x45
     [<ffffffff8188df34>] acpi_pci_root_init+0x1e/0x2d
     [<ffffffff81002073>] do_one_initcall+0x43/0x190
unreferenced object 0xffff8801fa7b1e18 (size 16):
   comm "swapper", pid 1, jiffies 4294892696 (age 48783.076s)
   hex dump (first 16 bytes):
     50 43 49 20 42 75 73 20 30 30 30 30 3a 38 30 00  PCI Bus 0000:80.
   backtrace:
     [<ffffffff813779be>] kmemleak_alloc+0x5e/0xc0
     [<ffffffff8113c3f3>] __kmalloc+0x133/0x1e0
     [<ffffffff811f9d17>] kvasprintf+0x57/0x90
     [<ffffffff811f9d88>] kasprintf+0x38/0x40
     [<ffffffff812d8afb>] get_current_resources+0x9b/0x1b0
     [<ffffffff8137cdff>] pci_acpi_scan_root+0x14a/0x1a7
     [<ffffffff8137bb30>] acpi_pci_root_add+0x197/0x36b
     [<ffffffff8123179a>] acpi_device_probe+0x50/0x122
     [<ffffffff812a21e7>] really_probe+0x77/0x240
     [<ffffffff812a23eb>] driver_probe_device+0x3b/0x80
     [<ffffffff812a24cb>] __driver_attach+0x9b/0xa0
     [<ffffffff812a14ec>] bus_for_each_dev+0x6c/0xa0
     [<ffffffff812a1f9e>] driver_attach+0x1e/0x20
     [<ffffffff812a1940>] bus_add_driver+0x200/0x2b0
     [<ffffffff812a2b30>] driver_register+0x80/0x150
     [<ffffffff81232705>] acpi_bus_register_driver+0x43/0x45

