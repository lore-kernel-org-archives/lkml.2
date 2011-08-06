Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1HFI1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 04:27:04 -0400
Received: from www17.your-server.de ([213.133.104.17]:56445 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1HFI06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 04:26:58 -0400
Subject: [PATCH] n2_crypto: Fix a get/put_cpu() imbalance
From: Thomas Meyer <thomas@m3y3r.de>
To: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 06 Aug 2011 10:26:25 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312619188.5589.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

Fix a get/put_cpu() imbalance in the error case when qp == NULL

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index d0183ddb..6683b58 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1006,9 +1006,8 @@ static int n2_do_ecb(struct ablkcipher_request *req, bool encrypt)
 
        spin_unlock_irqrestore(&qp->lock, flags);
 
-       put_cpu();
-
 out:
+       put_cpu();
        n2_chunk_complete(req, NULL);
        return err;
 }
@@ -1096,9 +1095,8 @@ static int n2_do_chaining(struct ablkcipher_request *req, bool encrypt)
 
        spin_unlock_irqrestore(&qp->lock, flags);
 
-       put_cpu();
-
 out:
+       put_cpu();
        n2_chunk_complete(req, err ? NULL : final_iv_addr);
        return err;
 }







