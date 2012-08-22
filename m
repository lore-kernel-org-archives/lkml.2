Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab2HVQv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:51:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36973 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab2HVQvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:51:54 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, andiry@gmail.com
Subject: [PATCH 0/1] xhci: Recognize USB 3.0 devices as superspeed at powerup
Date: Wed, 22 Aug 2012 11:51:50 -0500
Message-Id: <1345654310-5895-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

On Intel Panther Point chipset USB 3.0 devices show up as
high-speed devices on powerup, but after an s3 cycle they are
correctly recognized as SuperSpeed. At powerup switch the port
to xHCI so that USB 3.0 devices are correctly recognized.

This is a second attempt at fixing this based on review comments
to my earlier patch from Andiry Xu

BugLink: http://bugs.launchpad.net/bugs/1000424


Test results after applying patch
==================================

USB 3.0 device connected to SuperSpeed port
--------------------------------------------
[   34.694033] usb 4-1: new SuperSpeed USB device number 2 using xhci_hcd
[   34.712925] scsi6 : usb-storage 4-1:1.0
[   35.709947] scsi 6:0:0:0: Direct-Access     JetFlash Transcend 16GB   1.00 PQ: 0 ANSI: 5
[   35.710886] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   35.711475] sd 6:0:0:0: [sdc] 30871552 512-byte logical blocks: (15.8 GB/14.7 GiB)
[   35.712721] sd 6:0:0:0: [sdc] Write Protect is off
[   35.712725] sd 6:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   35.712841] sd 6:0:0:0: [sdc] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
[   35.714627]  sdc: sdc1

USB 3.0 device connected to highspeed port
-------------------------------------------
[  148.128616] usb 1-1.2: new high-speed USB device number 5 using ehci_hcd
[  148.226040] scsi7 : usb-storage 1-1.2:1.0
[  149.225645] scsi 7:0:0:0: Direct-Access     JetFlash Transcend 16GB   1.00 PQ: 0 ANSI: 5
[  149.227690] sd 7:0:0:0: Attached scsi generic sg3 type 0
[  149.230196] sd 7:0:0:0: [sdc] 30871552 512-byte logical blocks: (15.8 GB/14.7 GiB)
[  149.230555] sd 7:0:0:0: [sdc] Write Protect is off
[  149.230563] sd 7:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  149.231333] sd 7:0:0:0: [sdc] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
[  149.235822]  sdc: sdc1
[  149.238035] sd 7:0:0:0: [sdc] Attached SCSI removable disk


Manoj Iyer (1):
  xhci: Recognize USB 3.0 devices as superspeed at powerup

 drivers/usb/host/pci-quirks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.9.5

