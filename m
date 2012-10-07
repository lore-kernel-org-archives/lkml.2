Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2JGXZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:25:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38722 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582Ab2JGXXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:31 -0400
Message-Id: <20121007225838.038472923@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "sreekanth.reddy@lsi.com" <sreekanth.reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 024/108] [SCSI] mpt2sas: Fix for issue - Unable to boot from the drive
 connected to HBA
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "sreekanth.reddy@lsi.com" <sreekanth.reddy@lsi.com>

commit 10cce6d8b5af0b32bc4254ae4a28423a74c0921c upstream.

This patch checks whether HBA is SAS2008 B0 controller.
if it is a SAS2008 B0 controller then it use IO-APIC interrupt instead of MSIX,
as SAS2008 B0 controller doesn't support MSIX interrupts.

[jejb: fix whitespace problems]
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index b25757d..9d5a56c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1209,6 +1209,13 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	u16 message_control;
 
 
+	/* Check whether controller SAS2008 B0 controller,
+	   if it is SAS2008 B0 controller use IO-APIC instead of MSIX */
+	if (ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008 &&
+	    ioc->pdev->revision == 0x01) {
+		return -EINVAL;
+	}
+
 	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
 	if (!base) {
 		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "msix not "


