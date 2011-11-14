Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1KNJju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:39:50 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:45981 "EHLO
	AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754109Ab1KNJjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:39:48 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/5] regmap: Do not call regcache_exit from regcache_rbtree_init error path
Date: Mon, 14 Nov 2011 10:40:18 +0100
Message-ID: <1321263619-25891-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321263619-25891-1-git-send-email-lars@metafoo.de>
References: <1321263619-25891-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling regcache_exit from regcache_rbtree_init is a layering violation and
might cause double frees. In case of an error only free those structures which
have been allocated in this function.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache-rbtree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index e314984..e71320f 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -17,6 +17,7 @@
 
 static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 				 unsigned int value);
+static int regcache_rbtree_exit(struct regmap *map);
 
 struct regcache_rbtree_node {
 	/* the actual rbtree node holding this block */
@@ -149,7 +150,7 @@ static int regcache_rbtree_init(struct regmap *map)
 	return 0;
 
 err:
-	regcache_exit(map);
+	regcache_rbtree_exit(map);
 	return ret;
 }
 
-- 
1.7.7.1


