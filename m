Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0IJXou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:44:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:20868 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab0IJXot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:44:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,348,1280732400"; 
   d="scan'208";a="836713358"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.35.4] irq: irq and pci_ids patch for Intel Patsburg DeviceIDs
Date: Fri, 10 Sep 2010 16:36:39 -0700
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, khali@linux-fr.org,
        seth.heasley@intel.com
References: <201003251611.37706.seth.heasley@intel.com>
In-Reply-To: <201003251611.37706.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009101636.39962.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LPC Controller DeviceIDs for the Intel Patsburg PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.35.4/include/linux/pci_ids.h.orig	2010-08-26 16:47:12.000000000 -0700
+++ linux-2.6.35.4/include/linux/pci_ids.h	2010-09-10 16:34:06.000000000 -0700
@@ -2423,6 +2423,7 @@
 #define PCI_DEVICE_ID_INTEL_CPT_SMBUS	0x1c22
 #define PCI_DEVICE_ID_INTEL_CPT_LPC_MIN	0x1c41
 #define PCI_DEVICE_ID_INTEL_CPT_LPC_MAX	0x1c5f
+#define PCI_DEVICE_ID_INTEL_PBG_LPC	0x1d40
 #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
 #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
 #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
--- linux-2.6.35.4/arch/x86/pci/irq.c.orig	2010-08-26 16:47:12.000000000 -0700
+++ linux-2.6.35.4//arch/x86/pci/irq.c	2010-09-10 16:30:39.000000000 -0700
@@ -589,6 +589,7 @@
 	case PCI_DEVICE_ID_INTEL_ICH10_1:
 	case PCI_DEVICE_ID_INTEL_ICH10_2:
 	case PCI_DEVICE_ID_INTEL_ICH10_3:
+	case PCI_DEVICE_ID_INTEL_PBG_LPC:
 		r->name = "PIIX/ICH";
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
