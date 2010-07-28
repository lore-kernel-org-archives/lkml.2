Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0G1JcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:32:08 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:58385 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754513Ab0G1JcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:32:05 -0400
Subject: [PATCH] random: reorder struct entropy_store to remove padding on
 64bits
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 10:32:01 +0100
Message-ID: <1280309521.2029.5.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-order structure entropy_store to remove 8 bytes of padding on
64 bit builds, so shrinking this structure from 72 to 64 bytes
and allowing it to fit into one cache line.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
patch against v2.6.35-rc6
built & tested on x86_64

regards
Richard



diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8d85587..caef35a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -407,8 +407,8 @@ struct entropy_store {
 	struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
-	int limit;
 	struct entropy_store *pull;
+	int limit;
 
 	/* read-write data: */
 	spinlock_t lock;


