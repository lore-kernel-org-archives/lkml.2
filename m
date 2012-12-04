Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2LDUsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:48:18 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58401 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2LDUsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:48:16 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, gregkh@linuxfoundation.org,
        devendra.aaru@gmail.com, marcos.souza.org@gmail.com,
        andriy.shevchenko@linux.intel.com, devel@driverdev.osuosl.org,
        Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH] staging: csr: remove unneeded call to memset().
Date: Tue,  4 Dec 2012 21:41:07 +0100
Message-Id: <1354653667-28927-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In uf_send_pkt_to_encrypt(), the memory area zeroed by this call to memset() is
overwritten by a call to memcpy() a few instructions later, so it is not needed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/staging/csr/unifi_sme.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/csr/unifi_sme.c b/drivers/staging/csr/unifi_sme.c
index 7c6c413..7669037 100644
--- a/drivers/staging/csr/unifi_sme.c
+++ b/drivers/staging/csr/unifi_sme.c
@@ -1196,7 +1196,6 @@ void uf_send_pkt_to_encrypt(struct work_struct *work)
 
         if (pktBulkDataLength > 0) {
 		    pktBulkData = kmalloc(pktBulkDataLength, GFP_KERNEL);
-		    memset(pktBulkData, 0, pktBulkDataLength);
 	    } else {
 		    unifi_error(priv, "uf_send_pkt_to_encrypt() : invalid buffer\n");
 		    return;
-- 
1.7.10.4

