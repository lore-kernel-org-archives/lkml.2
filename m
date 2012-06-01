Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab2FAVQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 17:16:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab2FAVQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 17:16:28 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 1/4] PCI: make pci_ltr_supported static.
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        xudong.hao@linux.intel.com, ddutile@redhat.com, yu.zhao@intel.com
Date: Fri, 01 Jun 2012 15:16:25 -0600
Message-ID: <20120601211625.20328.37250.stgit@amt.stowe>
In-Reply-To: <20120601211619.20328.36769.stgit@amt.stowe>
References: <20120601211619.20328.36769.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI Express Latency Tolerance Reporting (LTR) feature's
pci_ltr_supported() routine is currently only used within
drivers/pci/pci.c so make it static.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/pci.c   |    4 ++--
 include/linux/pci.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 447e834..64471b1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -39,6 +39,7 @@ EXPORT_SYMBOL(pci_pci_problems);
 
 unsigned int pci_pm_d3_delay;
 
+static bool pci_ltr_supported(struct pci_dev *dev);
 static void pci_pme_list_scan(struct work_struct *work);
 
 static LIST_HEAD(pci_pme_list);
@@ -2169,7 +2170,7 @@ EXPORT_SYMBOL(pci_disable_obff);
  * RETURNS:
  * True if @dev supports latency tolerance reporting, false otherwise.
  */
-bool pci_ltr_supported(struct pci_dev *dev)
+static bool pci_ltr_supported(struct pci_dev *dev)
 {
 	int pos;
 	u32 cap;
@@ -2185,7 +2186,6 @@ bool pci_ltr_supported(struct pci_dev *dev)
 
 	return cap & PCI_EXP_DEVCAP2_LTR;
 }
-EXPORT_SYMBOL(pci_ltr_supported);
 
 /**
  * pci_enable_ltr - enable latency tolerance reporting
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d8c379d..b2bec26 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -875,7 +875,6 @@ enum pci_obff_signal_type {
 int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type);
 void pci_disable_obff(struct pci_dev *dev);
 
-bool pci_ltr_supported(struct pci_dev *dev);
 int pci_enable_ltr(struct pci_dev *dev);
 void pci_disable_ltr(struct pci_dev *dev);
 int pci_set_ltr(struct pci_dev *dev, int snoop_lat_ns, int nosnoop_lat_ns);

