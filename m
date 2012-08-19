Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2HSJrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 05:47:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39031 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2HSJrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 05:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1208191026340.18296@math.ut.ee>
References: <alpine.SOC.1.00.1208191026340.18296@math.ut.ee>
Date: Sun, 19 Aug 2012 17:47:02 +0800
Message-ID: <CACVXFVOMyti0+CSFeiiBJFcKouL456ngqO+ZnENSK60hwoUP6g@mail.gmail.com>
Subject: Re: printks messed up in 3.6-rc2+git
From: Ming Lei <tom.leiming@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 3:30 PM, Meelis Roos <mroos@linux.ee> wrote:
> 1. Lots of broken HPET messages scattered in PCI prontks like this:
> pcieport 0000:00:0c.0: Force enabled HPET at 0x%lx
> irq 40 for MSI/MSI-X
> pcieport 0000:00:0d.0: Force enabled HPET at 0x%lx
> irq 41 for MSI/MSI-X
> pcieport 0000:00:0e.0: Force enabled HPET at 0x%lx
> irq 42 for MSI/MSI-X
> pcieport 0000:00:0f.0: Force enabled HPET at 0x%lx
> irq 43 for MSI/MSI-X
>
> 2. Lots of \0x10 in different printk lines, like this:
>
> pci 0000:00:05.0: \x010Enabling HT MSI Mapping
> pci 0000:00:05.1: \x010Enabling HT MSI Mapping
> pci 0000:00:05.2: \x010Enabling HT MSI Mapping
> pci 0000:00:06.0: \x010Enabling HT MSI Mapping
> pci 0000:00:06.1: \x010Enabling HT MSI Mapping
> pci 0000:00:08.0: \x010Enabling HT MSI Mapping
> pci 0000:00:09.0: \x010Enabling HT MSI Mapping
> pci 0000:00:0c.0: \x010Enabling HT MSI Mapping
> pci 0000:00:0d.0: \x010Enabling HT MSI Mapping
> pci 0000:00:0e.0: \x010Enabling HT MSI Mapping
> pci 0000:00:0f.0: \x010Enabling HT MSI Mapping
> and this:
> usb 2-8: \x010new low-speed USB device number 5 using ohci_hcd
> usb 2-8: \x010New USB device found, idVendor=0592, idProduct=0002
> usb 2-8: \x010New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 2-8: %s: Can't disable non-U1 or U2 state.
>
> 3. Many more %s and runtogether lines:
>
> sata_nv 0000:00:05.1: %s: ino %lu, used %d with only %d reserved data blocksUsing SWNCQ mode

For me, it is kinds of like below:

[   15.379760] usb 1-1.2.3: mminit::memmap_init Initialising map node
%d zone %lu pfns %lu -> %lu
[   15.379760] default language 0x0409
[   15.393768] usb 1-1.2.3: mminit::memmap_init Initialising map node
%d zone %lu pfns %lu -> %lu
[   15.393768] udev 6, busnum 1, minor = 5
[   15.407012] usb 1-1.2.3: Oops - undefined instructionNew USB device
found, idVendor=0cf3, idProduct=9271
[   15.417175] usb 1-1.2.3: Oops - undefined instructionNew USB device
strings: Mfr=16, Product=32, SerialNumbe
r=48
[   15.430145] usb 1-1.2.3: Oops - undefined instructionProduct: USB2.0 WLAN
[   15.440643] usb 1-1.2.3: Oops - undefined instructionManufacturer: ATHEROS
[   15.447906] usb 1-1.2.3: Oops - undefined instructionSerialNumber: 12345



Thanks,
-- 
Ming Lei
