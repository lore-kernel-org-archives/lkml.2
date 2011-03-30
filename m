Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1C3M5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:57:45 -0400
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:44303 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1C3M5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:57:44 -0400
X-AuditID: c1b4fb3d-b7bbbae000005311-8c-4d9328c6867c
From: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
To: mchehab@redhat.com
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
Subject: [PATCH 1/2] i7core_edac: Add xeon 5600 generic non core registers
Date: Wed, 30 Mar 2011 15:21:22 +0200
Message-ID: <1301491283-14128-1-git-send-email-samuel.gabrielsson@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables writing to registers in device 0 function 0 such as
MC_CFG_CONTROL. This also fixes a bug for intel xeon 5600 series
when writing to inject_enable where we would get an Oops because
pvt->pci_noncore was not set.

Signed-off-by: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
---
 drivers/edac/i7core_edac.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 81154ab..1db6092 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -322,6 +322,9 @@ static const struct pci_id_descr pci_dev_descr_lynnfield[] = {
 };
 
 static const struct pci_id_descr pci_dev_descr_i7core_westmere[] = {
+		/* Generic Non-core registers */
+	{ PCI_DESCR(0, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_REV2) },
+
 		/* Memory controller */
 	{ PCI_DESCR(3, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_MCR_REV2)     },
 	{ PCI_DESCR(3, 1, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_TAD_REV2)  },
-- 
1.7.1

