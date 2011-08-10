Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1HJRm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:42:29 -0400
Received: from www17.your-server.de ([213.133.104.17]:34996 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1HJRm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:42:29 -0400
Subject: [PATCH] drivers/char: don't use IS_ERR()
From: Thomas Meyer <thomas@m3y3r.de>
To: Andrew Morton <akpm@linux-foundation.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 10 Aug 2011 19:41:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312998113.5589.204.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 The various basic memory allocation functions don't return ERR_PTR

 The semantic patch that makes this change is available
 in scripts/coccinelle/null/eno.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff --git a/drivers/char/msm_smd_pkt.c b/drivers/char/msm_smd_pkt.c
index b6f8a65..ceece48 100644
--- a/drivers/char/msm_smd_pkt.c
+++ b/drivers/char/msm_smd_pkt.c
@@ -379,9 +379,8 @@ static int __init smd_pkt_init(void)
 	for (i = 0; i < NUM_SMD_PKT_PORTS; ++i) {
 		smd_pkt_devp[i] = kzalloc(sizeof(struct smd_pkt_dev),
 					  GFP_KERNEL);
-		if (IS_ERR(smd_pkt_devp[i])) {
-			r = PTR_ERR(smd_pkt_devp[i]);
-			pr_err("kmalloc() failed %d\n", r);
+		if (!smd_pkt_devp[i]) {
+			pr_err("kmalloc() failed\n");
 			goto clean_cdevs;
 		}
 


