Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab0ISHWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 03:22:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44610 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751103Ab0ISHWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 03:22:35 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX193dzU5LK53L/KtKF56vT4cZNxsK6ZeeseA8+p2Uw
	Qr6TGO/K4JBL91
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 07/12] viafb: reduce I2C timeout and delay
Date: Sun, 19 Sep 2010 07:33:48 +0000
Message-Id: <bc04fc99ee764b565490e48226899ce0567189e3.1284879532.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <171e0fb74a34b069c0c12aa90c56d5e5da5489c6.1284879532.git.FlorianSchandinat@gmx.de>
References: <171e0fb74a34b069c0c12aa90c56d5e5da5489c6.1284879532.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1284879532.git.FlorianSchandinat@gmx.de>
References: <cover.1284879532.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: reduce I2C timeout and delay

This patch reduces the value for I2C timeout and udelay.
The udelay was reduced to 10 (old: 40) which is still very high as for
standard-mode I2C even 5 should work. This gives a speedup of factor 4
when talking to I2C devices.
The timeout was reduced to 2 (old: 20) which is taken from the radeon
driver so it should work as well. This gives a speedup of factor 10 when
detecting that there is no I2C device we want to talk to.
This causes a huge improvement of device initialization time.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via_i2c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 021112e..3844b55 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -202,8 +202,8 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
 	algo->setscl = via_i2c_setscl;
 	algo->getsda = via_i2c_getsda;
 	algo->getscl = via_i2c_getscl;
-	algo->udelay = 40;
-	algo->timeout = 20;
+	algo->udelay = 10;
+	algo->timeout = 2;
 	algo->data = adap_cfg;
 
 	sprintf(adapter->name, "viafb i2c io_port idx 0x%02x",
-- 
1.6.3.2

