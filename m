Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab1KJDY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:24:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933985Ab1KJDYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:24:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:07 2011
Message-Id: <20111109212706.992069651@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [066/262] xen-pcifront: Update warning comment to use e820_host option.
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 917e3e65c35459d52f0d0b890aa5df0cad07a051 upstream.

With Xen changeset 23428 "libxl: Add 'e820_host' option to config file"
the E820 as seen from the host can now be passed into the guest.
This means that a PV guest can now:
 - Use the correct PCI I/O gap. Before these patches, Linux guest would
   boot up and would tell:
   [    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:c0000000)
   while in actuality the PCI I/O gap should have been:
   [    0.000000] Allocating PCI resources starting at b0000000 (gap: b0000000:4c000000)

 - The PV domain with PCI devices was limited to 3GB. It now can be booted
   with 4GB, 8GB, or whatever number you want. The PCI devices will now _not_ conflict
   with System RAM. Meaning the drivers can load.

CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org
[v2: Made the string less broken up. Suggested by Joe Perches]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/xen-pcifront.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -400,9 +400,8 @@ static int pcifront_claim_resource(struc
 			dev_info(&pdev->xdev->dev, "claiming resource %s/%d\n",
 				pci_name(dev), i);
 			if (pci_claim_resource(dev, i)) {
-				dev_err(&pdev->xdev->dev, "Could not claim "
-					"resource %s/%d! Device offline. Try "
-					"giving less than 4GB to domain.\n",
+				dev_err(&pdev->xdev->dev, "Could not claim resource %s/%d! "
+					"Device offline. Try using e820_host=1 in the guest config.\n",
 					pci_name(dev), i);
 			}
 		}


