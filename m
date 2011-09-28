Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab1I1Wqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:46:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970Ab1I1Wqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:43 2011
Message-Id: <20110928220143.561313622@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [173/244] [SCSI] mpt2sas: Adding support for customer specific branding
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Kashyap, Desai" <kashyap.desai@lsi.com>

commit ab3e5f60d1fc8fe725d02510ff820ff207a8dbef upstream.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   19 +++++++++++++++++--
 drivers/scsi/mpt2sas/mpt2sas_base.h |    3 +++
 2 files changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1740,9 +1740,11 @@ _base_display_dell_branding(struct MPT2S
 static void
 _base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
 {
-	if (ioc->pdev->subsystem_vendor == PCI_VENDOR_ID_INTEL &&
-	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008) {
+	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_INTEL)
+		return;
 
+	switch (ioc->pdev->device) {
+	case MPI2_MFGPAGE_DEVID_SAS2008:
 		switch (ioc->pdev->subsystem_device) {
 		case MPT2SAS_INTEL_RMS2LL080_SSDID:
 			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
@@ -1752,7 +1754,20 @@ _base_display_intel_branding(struct MPT2
 			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 			    MPT2SAS_INTEL_RMS2LL040_BRANDING);
 			break;
+		default:
+			break;
+		}
+	case MPI2_MFGPAGE_DEVID_SAS2308_2:
+		switch (ioc->pdev->subsystem_device) {
+		case MPT2SAS_INTEL_RS25GB008_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RS25GB008_BRANDING);
+			break;
+		default:
+			break;
 		}
+	default:
+		break;
 	}
 }
 
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -161,12 +161,15 @@
 				"Intel Integrated RAID Module RMS2LL080"
 #define MPT2SAS_INTEL_RMS2LL040_BRANDING	\
 				"Intel Integrated RAID Module RMS2LL040"
+#define MPT2SAS_INTEL_RS25GB008_BRANDING       \
+				"Intel(R) RAID Controller RS25GB008"
 
 /*
  * Intel HBA SSDIDs
  */
 #define MPT2SAS_INTEL_RMS2LL080_SSDID          0x350E
 #define MPT2SAS_INTEL_RMS2LL040_SSDID          0x350F
+#define MPT2SAS_INTEL_RS25GB008_SSDID          0x3000
 
 
 /*


