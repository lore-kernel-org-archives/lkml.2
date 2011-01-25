Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1AYQ2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:28:00 -0500
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:46094 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752104Ab1AYQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:27:59 -0500
Subject: [PATCH] crypt: ablkcipher: remove redundant NULL check
From: Davidlohr Bueso <dave@gnu.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        David Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 13:27:45 -0300
Message-ID: <1295972865.1998.9.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 crypto/ablkcipher.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index a854df2..fdc67d3 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -141,8 +141,7 @@ err:
 
 	if (walk->iv != req->info)
 		memcpy(req->info, walk->iv, tfm->crt_ablkcipher.ivsize);
-	if (walk->iv_buffer)
-		kfree(walk->iv_buffer);
+	kfree(walk->iv_buffer);
 
 	return err;
 }
-- 
1.7.1



