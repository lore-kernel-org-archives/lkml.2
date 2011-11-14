Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1KNJkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:40:32 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:14546
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab1KNJk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:40:28 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 0,13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/5] regmap: Do not call regcache_exit from regcache_lzo_init error path
Date: Mon, 14 Nov 2011 10:40:19 +0100
Message-ID: <1321263619-25891-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321263619-25891-1-git-send-email-lars@metafoo.de>
References: <1321263619-25891-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling regcache_exit from regcache_lzo_init is a layering violation and
might cause double frees. In case of an error only free those structures which
have been allocated in this function.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache-lzo.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 226ffc1..b7d1614 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -15,6 +15,8 @@
 
 #include "internal.h"
 
+static int regcache_lzo_exit(struct regmap *map);
+
 struct regcache_lzo_ctx {
 	void *wmem;
 	void *dst;
@@ -193,7 +195,7 @@ static int regcache_lzo_init(struct regmap *map)
 
 	return 0;
 err:
-	regcache_exit(map);
+	regcache_lzo_exit(map);
 	return ret;
 }
 
-- 
1.7.7.1


