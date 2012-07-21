Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2GUHVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:21:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60075 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2GUHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:21:37 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Mikko=20Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        =?UTF-8?q?Riku=20Mett=C3=A4l=C3=A4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>,
        Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 2/3] staging/csr: coding style fixes at sdio_linux_remove_irq and at install_irq
Date: Sat, 21 Jul 2012 13:06:29 +0545
Message-Id: <1342855289-2830-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following coding style problems were fixed:

1. move function return type from top to the starting of the function
2. remove all the spaces at the start of a line and used tabs

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/csr/sdio_mmc.c |   43 +++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/csr/sdio_mmc.c b/drivers/staging/csr/sdio_mmc.c
index d3fd57c..b203d2b 100644
--- a/drivers/staging/csr/sdio_mmc.c
+++ b/drivers/staging/csr/sdio_mmc.c
@@ -845,19 +845,18 @@ uf_glue_sdio_int_handler(struct sdio_func *func)
  *      Status of the removal.
  * ---------------------------------------------------------------------------
  */
-int
-csr_sdio_linux_remove_irq(CsrSdioFunction *function)
+int csr_sdio_linux_remove_irq(CsrSdioFunction *function)
 {
-    struct sdio_func *func = (struct sdio_func *)function->priv;
-    int r;
+	struct sdio_func *func = (struct sdio_func *)function->priv;
+	int r;
 
-    unifi_trace(NULL, UDBG1, "csr_sdio_linux_remove_irq\n");
+	unifi_trace(NULL, UDBG1, "csr_sdio_linux_remove_irq\n");
 
-    sdio_claim_host(func);
-    r = sdio_release_irq(func);
-    sdio_release_host(func);
+	sdio_claim_host(func);
+	r = sdio_release_irq(func);
+	sdio_release_host(func);
 
-    return r;
+	return r;
 
 } /* csr_sdio_linux_remove_irq() */
 
@@ -876,25 +875,23 @@ csr_sdio_linux_remove_irq(CsrSdioFunction *function)
  *      Status of the removal.
  * ---------------------------------------------------------------------------
  */
-int
-csr_sdio_linux_install_irq(CsrSdioFunction *function)
+int csr_sdio_linux_install_irq(CsrSdioFunction *function)
 {
-    struct sdio_func *func = (struct sdio_func *)function->priv;
-    int r;
+	struct sdio_func *func = (struct sdio_func *)function->priv;
+	int r;
 
-    unifi_trace(NULL, UDBG1, "csr_sdio_linux_install_irq\n");
+	unifi_trace(NULL, UDBG1, "csr_sdio_linux_install_irq\n");
 
-    /* Register our interrupt handle */
-    sdio_claim_host(func);
-    r = sdio_claim_irq(func, uf_glue_sdio_int_handler);
-    sdio_release_host(func);
+	/* Register our interrupt handle */
+	sdio_claim_host(func);
+	r = sdio_claim_irq(func, uf_glue_sdio_int_handler);
+	sdio_release_host(func);
 
-    /* If the interrupt was installed earlier, is fine */
-    if (r == -EBUSY) {
-        r = 0;
-    }
+	/* If the interrupt was installed earlier, is fine */
+	if (r == -EBUSY)
+		r = 0;
 
-    return r;
+	return r;
 } /* csr_sdio_linux_install_irq() */
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
-- 
1.7.9.5

