Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0IKRdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 13:33:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40561 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab0IKRdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 13:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dlhaebTIfKmO8Wm3+b045TflV6aIE/f/AFLC5Vp9e+HBu+UuQ9Djd0w01k4U4wsQqn
         i0w4J7Ie4FNTgwLMqWccc4N/bjLQhKVdWj1D8EIzGIfmh01N1c/jMtWUqbTDttrEkgln
         27dA5fFV1gQgLbXJwoM32TDCJdbulRUb7RNhE=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Joe Perches <joe@perches.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 2/2] media: cx23885: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 20:33:28 +0300
Message-Id: <28b7342272db43227dcb3a06931e2ab4dd866fe3.1284226282.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <0ffd3b30fbaa2168656dd17fbdb290cf2e0a867e.1284226281.git.andy.shevchenko@gmail.com>
References: <0ffd3b30fbaa2168656dd17fbdb290cf2e0a867e.1284226281.git.andy.shevchenko@gmail.com>
In-Reply-To: <0ffd3b30fbaa2168656dd17fbdb290cf2e0a867e.1284226281.git.andy.shevchenko@gmail.com>
References: <0ffd3b30fbaa2168656dd17fbdb290cf2e0a867e.1284226281.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/media/video/cx23885/cx23885-dvb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 3d70af2..0674ea1 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -1017,10 +1017,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* Read entire EEPROM */
 		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom, sizeof(eeprom));
-		printk(KERN_INFO "TeVii S470 MAC= "
-				"%02X:%02X:%02X:%02X:%02X:%02X\n",
-				eeprom[0xa0], eeprom[0xa1], eeprom[0xa2],
-				eeprom[0xa3], eeprom[0xa4], eeprom[0xa5]);
+		printk(KERN_INFO "TeVii S470 MAC= %pM\n", eeprom + 0xa0);
 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
 		break;
 		}
-- 
1.7.2.2

