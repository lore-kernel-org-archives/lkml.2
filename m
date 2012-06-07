Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab2FGI0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:26:50 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:53494 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758286Ab2FGIZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:25:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAPdk0E9bdWOb/2dsb2JhbABFhU6uToEHghkBBSMPAUYQJQImAgJXBxKID6YUkmWBI4oDhG2BEgOVHY96gmKBVA
X-IronPort-AV: E=Sophos;i="4.75,730,1330902000"; 
   d="scan'208";a="923788924"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: gregkh@linuxfoundation.org, siglesias@igalia.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 9/9] Staging: ipack/bridges/tpci200: change device table definition and export it.
Date: Thu,  7 Jun 2012 10:24:58 +0200
Message-Id: <1339057498-5256-9-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339057498-5256-1-git-send-email-magomez@igalia.com>
References: <1339057498-5256-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DEFINE_PCI_DEVICE_TABLE() to create the device table and add
MODULE_DEVICE_TABLE() to export it.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 51448c7..75bb7e2 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -870,12 +870,14 @@ static void __devexit tpci200_pci_remove(struct pci_dev *dev)
 	}
 }
 
-static struct pci_device_id tpci200_idtable[2] = {
+static DEFINE_PCI_DEVICE_TABLE(tpci200_idtable) = {
 	{ TPCI200_VENDOR_ID, TPCI200_DEVICE_ID, TPCI200_SUBVENDOR_ID,
 	  TPCI200_SUBDEVICE_ID },
 	{ 0, },
 };
 
+MODULE_DEVICE_TABLE(pci, tpci200_idtable);
+
 static struct pci_driver tpci200_pci_drv = {
 	.name = "tpci200",
 	.id_table = tpci200_idtable,
-- 
1.7.9.5

