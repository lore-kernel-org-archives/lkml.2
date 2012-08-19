Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2HSHbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 03:31:01 -0400
Received: from bounces.ut.ee ([193.40.5.137]:47327 "EHLO bounces.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab2HSHa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 03:30:59 -0400
Date: Sun, 19 Aug 2012 10:30:57 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: printks messed up in 3.6-rc2+git
Message-ID: <alpine.SOC.1.00.1208191026340.18296@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Lots of broken HPET messages scattered in PCI prontks like this:
pcieport 0000:00:0c.0: Force enabled HPET at 0x%lx
irq 40 for MSI/MSI-X
pcieport 0000:00:0d.0: Force enabled HPET at 0x%lx
irq 41 for MSI/MSI-X
pcieport 0000:00:0e.0: Force enabled HPET at 0x%lx
irq 42 for MSI/MSI-X
pcieport 0000:00:0f.0: Force enabled HPET at 0x%lx
irq 43 for MSI/MSI-X

2. Lots of \0x10 in different printk lines, like this:

pci 0000:00:05.0: \x010Enabling HT MSI Mapping
pci 0000:00:05.1: \x010Enabling HT MSI Mapping
pci 0000:00:05.2: \x010Enabling HT MSI Mapping
pci 0000:00:06.0: \x010Enabling HT MSI Mapping
pci 0000:00:06.1: \x010Enabling HT MSI Mapping
pci 0000:00:08.0: \x010Enabling HT MSI Mapping
pci 0000:00:09.0: \x010Enabling HT MSI Mapping
pci 0000:00:0c.0: \x010Enabling HT MSI Mapping
pci 0000:00:0d.0: \x010Enabling HT MSI Mapping
pci 0000:00:0e.0: \x010Enabling HT MSI Mapping
pci 0000:00:0f.0: \x010Enabling HT MSI Mapping
and this:
usb 2-8: \x010new low-speed USB device number 5 using ohci_hcd
usb 2-8: \x010New USB device found, idVendor=0592, idProduct=0002
usb 2-8: \x010New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-8: %s: Can't disable non-U1 or U2 state.

3. Many more %s and runtogether lines:

sata_nv 0000:00:05.1: %s: ino %lu, used %d with only %d reserved data blocksUsing SWNCQ mode

-- 
Meelis Roos (mroos@linux.ee)
