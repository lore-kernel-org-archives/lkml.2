Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2CWKCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 06:02:48 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:8653 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab2CWKCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:02:46 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regmap: rbtree: Fix register default look-up in sync
Date: Fri, 23 Mar 2012 11:04:57 +0100
Message-ID: <1332497097-17846-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code currently passes the register offset in the current block to
regcache_lookup_reg. This works fine as long as there is only one block and with
base register of 0, but in all other cases it will look-up the default for a
wrong register, which can cause unnecessary register writes. This patch fixes
it by passing the actual register number to regcache_lookup_reg.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: <stable@vger.kernel.org>
---
 drivers/base/regmap/regcache-rbtree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 8d51916..de7241c 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -395,7 +395,7 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 							   map->cache_word_size);
 
 			/* Is this the hardware default?  If so skip. */
-			ret = regcache_lookup_reg(map, i);
+			ret = regcache_lookup_reg(map, regtmp);
 			if (ret >= 0 && val == map->reg_defaults[ret].def)
 				continue;
 
-- 
1.7.9.1


