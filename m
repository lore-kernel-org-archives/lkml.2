Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab0I0Kz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:55:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab0I0Kz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:55:27 -0400
From: Bernhard Walle <walle@corscience.de>
To: khali@linux-fr.org
Cc: ddaney@caviumnetworks.com, rade.bozic.ext@nsn.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: I2C: Return -ETIMEDOUT in octeon_i2c_wait() on timeout
Date: Mon, 27 Sep 2010 12:55:16 +0200
Message-Id: <1285584916-21317-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V02:K0:HfbH/PM1sPTIMZz78/QewVANaJw0FxfYrde2PDoZu0D
 CtpRPrh/OXGkQ2HwFZUiAXbpOmT3i8HUeKqOMybwAdJHqzehPd
 PUwuWV/p0RLHrDq8kjecw5/JVKucJXKg9Ury4v82huOATB+Xvq
 9iK2wIZ/uU3Dy/w2iBvSoIXfJ92fZbQDx7G9pd3IpM6wfhL+rR
 3cUmrgmKtsogUMnPxNOAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make sense to set result to -ETIMEDOUT but return 0 (success)
afterwards. Since there's code in octeon_i2c_start() to handle the
error, it should be called.

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 drivers/i2c/busses/i2c-octeon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index 0e9f85d..56dbe54 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -218,7 +218,7 @@ static int octeon_i2c_wait(struct octeon_i2c *i2c)
 		return result;
 	} else if (result == 0) {
 		dev_dbg(i2c->dev, "%s: timeout\n", __func__);
-		result = -ETIMEDOUT;
+		return -ETIMEDOUT;
 	}
 
 	return 0;
-- 
1.7.0.4

