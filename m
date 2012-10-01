Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950Ab2JAXUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:20:52 -0400
Received: from 1wt.eu ([62.212.114.60]:35387 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955Ab2JAXBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:34 -0400
Message-Id: <20121001225204.140117872@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Richard Kennedy <richard@rsk.demon.co.uk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, Willy Tarreau <w@1wt.eu>
Subject: [ 154/180] random: Reorder struct entropy_store to remove padding on 64bits
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Kennedy <richard@rsk.demon.co.uk>

commit 4015d9a865e3bcc42d88bedc8ce1551000bab664 upstream.

Re-order structure entropy_store to remove 8 bytes of padding on
64 bit builds, so shrinking this structure from 72 to 64 bytes
and allowing it to fit into one cache line.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 3a19e2d..a6e258b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -406,8 +406,8 @@ struct entropy_store {
 	struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
-	int limit;
 	struct entropy_store *pull;
+	int limit;
 
 	/* read-write data: */
 	spinlock_t lock;
-- 
1.7.2.1.45.g54fbc



