Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1KNJjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:39:52 -0500
Received: from mail-va3.bigfish.com ([216.32.180.10]:39950 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754119Ab1KNJjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:39:48 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/5] regmap: return ERR_PTR instead of NULL in regmap_init
Date: Mon, 14 Nov 2011 10:40:15 +0100
Message-ID: <1321263619-25891-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_init documentation states that it will either return a pointer to a
valid regmap structure or a ERR_PTR in case of an error. Currently it returns a
NULL pointer in case no bus or no config was given. Since NULL is not a
ERR_PTR a caller might assume that it is a pointer to a valid regmap structure,
so return a ERR_PTR(-EINVAL) instead.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index b08df85..b84ebf9 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -139,7 +139,7 @@ struct regmap *regmap_init(struct device *dev,
 	int ret = -EINVAL;
 
 	if (!bus || !config)
-		return NULL;
+		goto err;
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (map == NULL) {
-- 
1.7.7.1


