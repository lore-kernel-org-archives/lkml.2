Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab0JVTVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:21:07 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:4710 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822Ab0JVTVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:21:04 -0400
Subject: [PATCH 1/5] cciss: remove controllers supported by hpsa
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Date: Fri, 22 Oct 2010 14:21:01 -0500
Message-ID: <20101022192101.25567.40578.stgit@beardog.cce.hp.com>
In-Reply-To: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
References: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

We would prefer not to have any overlap between the two drivers.
Remove the cciss_allow_hpsa option, as it it is no longer needed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   46 ++++------------------------------------------
 1 files changed, 4 insertions(+), 42 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 41f9acb..dea1f2a 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -66,12 +66,6 @@ MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
 MODULE_VERSION("3.6.26");
 MODULE_LICENSE("GPL");
 
-static int cciss_allow_hpsa;
-module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(cciss_allow_hpsa,
-	"Prevent cciss driver from accessing hardware known to be "
-	" supported by the hpsa driver");
-
 #include "cciss_cmd.h"
 #include "cciss.h"
 #include <linux/cciss_ioctl.h>
@@ -98,19 +92,6 @@ static const struct pci_device_id cciss_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3350},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3351},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3352},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3353},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{0,}
 };
 
@@ -131,6 +112,8 @@ static struct board_type products[] = {
 	{0x409D0E11, "Smart Array 6400 EM", &SA5_access},
 	{0x40910E11, "Smart Array 6i", &SA5_access},
 	{0x3225103C, "Smart Array P600", &SA5_access},
+	{0x3223103C, "Smart Array P800", &SA5_access},
+	{0x3234103C, "Smart Array P400", &SA5_access},
 	{0x3235103C, "Smart Array P400i", &SA5_access},
 	{0x3211103C, "Smart Array E200i", &SA5_access},
 	{0x3212103C, "Smart Array E200", &SA5_access},
@@ -138,24 +121,7 @@ static struct board_type products[] = {
 	{0x3214103C, "Smart Array E200i", &SA5_access},
 	{0x3215103C, "Smart Array E200i", &SA5_access},
 	{0x3237103C, "Smart Array E500", &SA5_access},
-/* controllers below this line are also supported by the hpsa driver. */
-#define HPSA_BOUNDARY 0x3223103C
-	{0x3223103C, "Smart Array P800", &SA5_access},
-	{0x3234103C, "Smart Array P400", &SA5_access},
-	{0x323D103C, "Smart Array P700m", &SA5_access},
-	{0x3241103C, "Smart Array P212", &SA5_access},
-	{0x3243103C, "Smart Array P410", &SA5_access},
-	{0x3245103C, "Smart Array P410i", &SA5_access},
-	{0x3247103C, "Smart Array P411", &SA5_access},
-	{0x3249103C, "Smart Array P812", &SA5_access},
-	{0x324A103C, "Smart Array P712m", &SA5_access},
-	{0x324B103C, "Smart Array P711m", &SA5_access},
-	{0x3350103C, "Smart Array", &SA5_access},
-	{0x3351103C, "Smart Array", &SA5_access},
-	{0x3352103C, "Smart Array", &SA5_access},
-	{0x3353103C, "Smart Array", &SA5_access},
-	{0x3354103C, "Smart Array", &SA5_access},
-	{0x3355103C, "Smart Array", &SA5_access},
+	{0x323d103c, "Smart Array P700M", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
@@ -3967,13 +3933,9 @@ static int __devinit cciss_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
 			subsystem_vendor_id;
 
-	for (i = 0; i < ARRAY_SIZE(products); i++) {
-		/* Stand aside for hpsa driver on request */
-		if (cciss_allow_hpsa && products[i].board_id == HPSA_BOUNDARY)
-			return -ENODEV;
+	for (i = 0; i < ARRAY_SIZE(products); i++)
 		if (*board_id == products[i].board_id)
 			return i;
-	}
 	dev_warn(&pdev->dev, "unrecognized board ID: 0x%08x, ignoring.\n",
 		*board_id);
 	return -ENODEV;

