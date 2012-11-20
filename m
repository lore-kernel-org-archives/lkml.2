Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab2KTQEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:04:11 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:38025 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2KTQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:04:09 -0500
From: Betty Dall <betty.dall@hp.com>
To: bhelgaas@google.com, jbarnes@virtuousgeek.org, alex.williamson@redhat.com,
        wangyijing@huawei.com, ddutile@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20PCI=3A=20add=20PCIe=208=2E0=20GT/s=20supported=20link=20speed=20define?=
Date: Tue, 20 Nov 2012 11:58:59 -0700
Message-Id: <1353437939-29210-1-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new define for the 8.0 GT/s supported link speed added in the PCI
3.0 specification.  This is used to identify a device's current link speed
(PCI_EXP_CLS).

Here is the section of the PCI 3.0 specification:
"Supported Link Speeds Vector – This field indicates the
supported Link speed(s) of the associated Port. For each bit, a
value of 1b indicates that the corresponding Link speed is
supported; otherwise, the Link speed is not supported.
Bit definitions within this field are:
Bit 0 2.5 GT/s
Bit 1 5.0 GT/s
Bit 2 8.0 GT/s
Bits 6:3 RsvdP
Multi-Function devices associated with an Upstream Port must
report the same value in this field for all Functions."

Signed-off-by: Betty Dall <betty.dall@hp.com>
---
 include/uapi/linux/pci_regs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 20ae747..0cf8abb 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -469,6 +469,7 @@
 #define  PCI_EXP_LNKSTA_CLS	0x000f	/* Current Link Speed */
 #define  PCI_EXP_LNKSTA_CLS_2_5GB 0x01	/* Current Link Speed 2.5GT/s */
 #define  PCI_EXP_LNKSTA_CLS_5_0GB 0x02	/* Current Link Speed 5.0GT/s */
+#define  PCI_EXP_LNKSTA_CLS_8_0GB 0x04	/* Current Link Speed 8.0GT/s */
 #define  PCI_EXP_LNKSTA_NLW	0x03f0	/* Nogotiated Link Width */
 #define  PCI_EXP_LNKSTA_NLW_SHIFT 4	/* start of NLW mask in link status */
 #define  PCI_EXP_LNKSTA_LT	0x0800	/* Link Training */
-- 
1.7.7.6

