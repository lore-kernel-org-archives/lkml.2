Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946369Ab2I1VkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:40:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032482Ab2I1U0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sreekanth Reddy <sreekanth.reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 096/218] SCSI: mpt2sas: Fix for issue - Unable to boot from the drive connected to HBA
Date: Fri, 28 Sep 2012 13:15:13 -0700
Message-Id: <20120928201512.572265918@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "sreekanth.reddy@lsi.com" <sreekanth.reddy@lsi.com>

commit 10cce6d8b5af0b32bc4254ae4a28423a74c0921c upstream.

This patch checks whether HBA is SAS2008 B0 controller.
if it is a SAS2008 B0 controller then it use IO-APIC interrupt instead of MSIX,
as SAS2008 B0 controller doesn't support MSIX interrupts.

[jejb: fix whitespace problems]
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1202,6 +1202,13 @@ _base_check_enable_msix(struct MPT2SAS_A
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


