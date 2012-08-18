Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2HRRde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:33:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:8308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab2HRRag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182354052"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 25/31] sections: Fix section conflicts in drivers/scsi
Date: Sat, 18 Aug 2012 10:30:16 -0700
Message-Id: <1345311022-26328-26-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/scsi/aacraid/linit.c        |    2 +-
 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 7199534..cb7f158 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -93,7 +93,7 @@ static DECLARE_PCI_DEVICE_TABLE(aac_pci_tbl) = {
 #elif defined(__devinitconst)
 static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
 #else
-static const struct pci_device_id aac_pci_tbl[] __devinitdata = {
+static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
 #endif
 	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si (Iguana/PERC2Si) */
 	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di (Opal/PERC3Di) */
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index ff80552..1c4120c 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -1012,7 +1012,7 @@ static struct sas_domain_function_template aic94xx_transport_functions = {
 	.lldd_ata_set_dmamode	= asd_set_dmamode,
 };
 
-static const struct pci_device_id aic94xx_pci_table[] __devinitdata = {
+static const struct pci_device_id aic94xx_pci_table[] __devinitconst = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x410),0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x412),0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x416),0, 0, 1},
-- 
1.7.7.6

