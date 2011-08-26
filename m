Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1HZSqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:46:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28031 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1HZSo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:44:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com,
        joe@perches.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH 1/6] xen-pcifront: Update warning comment to use 'e820_host' option.
Date: Fri, 26 Aug 2011 14:44:25 -0400
Message-Id: <1314384270-19850-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314384270-19850-1-git-send-email-konrad.wilk@oracle.com>
References: <1314384270-19850-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A02020B.4E57E99F.017F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: stable@kernel.org
[v2: Made the string less broken up. Suggested by Joe Perches]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/xen-pcifront.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 492b7d8..d4e7a10 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -400,9 +400,8 @@ static int pcifront_claim_resource(struct pci_dev *dev, void *data)
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
-- 
1.7.4.1

