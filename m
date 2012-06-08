Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712Ab2FHIBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:01:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:62602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001Ab2FHIBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:01:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="149938485"
From: Xudong Hao <xudong.hao@intel.com>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, alex.williamson@redhat.com,
        ddutile@redhat.com, myron.stowe@redhat.com, xiantao.zhang@intel.com,
        xudong.hao@intel.com
Subject: [PATCH 3/4] Enable OBFF before device is used by driver
Date: Fri,  8 Jun 2012 16:01:31 +0800
Message-Id: <1339142492-13625-4-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1339142492-13625-1-git-send-email-xudong.hao@intel.com>
References: <1339142492-13625-1-git-send-email-xudong.hao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable OBFF(optimized buffer flush/fill) in pci_enable_device() function, make
sure this feature is enabled before device is used by driver.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
---
 drivers/pci/pci.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5e5e3ad..35127c1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1144,11 +1144,20 @@ static void pci_enable_dev_caps(struct pci_dev *dev)
 	 * tolerance for snooped & unsnooped memory transactions.
 	 */
 	pci_enable_ltr(dev);
+
+	/* 
+	 * OBFF (optimized buffer flush/fill), where supported,
+	 * can help improve energy efficiency by giving devices
+	 * information about when interrupts and other activity
+	 * will have a reduced power impact.
+	 */
+	pci_enable_obff(dev, PCI_EXP_OBFF_SIGNAL_L0);
 }
 
 static void pci_disable_dev_caps(struct pci_dev *dev)
 {
 	pci_disable_ltr(dev);
+	pci_disable_obff(dev);
 }
 
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
-- 
1.5.5

