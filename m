Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1EGRny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 13:43:54 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46420 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754332Ab1EGRnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 13:43:52 -0400
To: linux-rdma@vger.kernel.org
Subject: [PATCH 2/2] qib: use pci_dev->revision
Content-Disposition: inline
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
Date: Sat, 7 May 2011 21:41:56 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105072141.56328.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver reads PCI revision ID from the PCI configuration register while it's
already stored by PCI subsystem in the 'revision' field of 'struct pci_dev'...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

 drivers/infiniband/hw/qib/qib_pcie.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/drivers/infiniband/hw/qib/qib_pcie.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/qib/qib_pcie.c
+++ linux-2.6/drivers/infiniband/hw/qib/qib_pcie.c
@@ -526,11 +526,8 @@ static int qib_tune_pcie_coalesce(struct
 	 */
 	devid = parent->device;
 	if (devid >= 0x25e2 && devid <= 0x25fa) {
-		u8 rev;
-
 		/* 5000 P/V/X/Z */
-		pci_read_config_byte(parent, PCI_REVISION_ID, &rev);
-		if (rev <= 0xb2)
+		if (parent->revision <= 0xb2)
 			bits = 1U << 10;
 		else
 			bits = 7U << 10;
