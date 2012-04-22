Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2DVMoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 08:44:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53974 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab2DVMoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 08:44:22 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/parport/parport_gsc.c: add missing kfree
Date: Sun, 22 Apr 2012 14:44:15 +0200
Message-Id: <1335098655-18387-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Free ops as done just below.
Adjust some spacing to please checkpatch.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/parport/parport_gsc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 5d6de38..d2dcb27 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -270,15 +270,16 @@ struct parport *__devinit parport_gsc_probe_port (unsigned long base,
 	p->physport = p;
 	if (!parport_SPP_supported (p)) {
 		/* No port. */
-		kfree (priv);
+		kfree(priv);
+		kfree(ops);
 		return NULL;
 	}
 	parport_PS2_supported (p);
 
 	if (!(p = parport_register_port(base, PARPORT_IRQ_NONE,
 					PARPORT_DMA_NONE, ops))) {
-		kfree (priv);
-		kfree (ops);
+		kfree(priv);
+		kfree(ops);
 		return NULL;
 	}
 

