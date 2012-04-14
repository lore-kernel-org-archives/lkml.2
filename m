Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2DNUsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 16:48:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38906 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab2DNUss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 16:48:48 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/crypto/amcc/crypto4xx_core.c: move up err_request_irq label
Date: Sat, 14 Apr 2012 22:48:41 +0200
Message-Id: <1334436521-28622-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Move the err_request_irq error label up to reflect that tasklet_init and
irq_of_parse_and_map have taken place.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/crypto/amcc/crypto4xx_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 13f8e1a..802e851 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1244,9 +1244,9 @@ err_start_dev:
 	iounmap(core_dev->dev->ce_base);
 err_iomap:
 	free_irq(core_dev->irq, dev);
+err_request_irq:
 	irq_dispose_mapping(core_dev->irq);
 	tasklet_kill(&core_dev->tasklet);
-err_request_irq:
 	crypto4xx_destroy_sdr(core_dev->dev);
 err_build_sdr:
 	crypto4xx_destroy_gdr(core_dev->dev);

