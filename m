Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab0HJU2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:28:42 -0400
Received: from 8bytes.org ([88.198.83.132]:38605 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab0HJU2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:28:40 -0400
Date: Tue, 10 Aug 2010 22:28:39 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG:
	unable to handle kernel NULL pointer dereference at 0000000000000198
Message-ID: <20100810202839.GS23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it> <20100810180122.GR23755@8bytes.org> <1609756756.20100810200514@eikelenboom.it>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <1609756756.20100810200514@eikelenboom.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 10, 2010 at 08:05:14PM +0200, Sander Eikelenboom wrote:
> Could you also provide a perhaps more specific message what is wrong
> with the bios, that i could forward to MSI, in the hope it will reach
> the bios engineers someday ? :-)

Lets first prove that my theory is right before contacting MSI directly.
Can you try the attached patch? it should fix the boot-crash. When the
system booted successfully please try some USB device (make sure it uses
the seperate usb-controler, I guess the seperate device is responsible
for USB 3, so try to plug a device into one of your USB 3 ports).
If you finished that please send me whether it worked or not and the
full dmesg output of the system.

	Joerg


--3V7upXqbjpZ4EhLz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="iommu-crash-fix.diff"

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0d20286..6b4fb05 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -153,6 +153,8 @@ static int iommu_init_device(struct device *dev)
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
 	if (pdev)
 		dev_data->alias = &pdev->dev;
+	else
+		dev_data->alias = dev;
 
 	atomic_set(&dev_data->bind, 0);
 

--3V7upXqbjpZ4EhLz--
