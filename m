Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1AXMkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:40:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab1AXMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:40:43 -0500
From: Bernhard Walle <walle@corscience.de>
To: ben-linux@fluff.org
Cc: ddaney@caviumnetworks.com, ralf@linux-mips.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: octeon: Make the timeout independent of CONFIG_HZ
Date: Mon, 24 Jan 2011 13:40:26 +0100
Message-Id: <1295872826-22129-1-git-send-email-walle@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4D3D7290.9050203@corscience.de>
References: <4D3D7290.9050203@corscience.de>
X-Provags-ID: V02:K0:VLw60/Ni6qM+Lr/zYsES2TP8fAI4DVNr+vovK5kkAay
 NX250936ns6pXawpPIwLYGuuD4xfDYID7IjvLoQlAF2Imbal/l
 RK+j9dT/6ywrnbyqvMK7/y8hx29Hf9c4oIOaRQ63MfSzoTjUtr
 OI6+he8EHq/53suu72JYzFY3XHM6lamVPdoOsns2gNJLFRFlSh
 cTiD2dy6X+hff3rMt1g8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the timeout in the struct i2c_adapter use jiffies as unit and a
timeout should be independent of CONFIG_HZ, use a value of HZ/50 which
is equal to the current value 2 for CONFIG_HZ=100.

Signed-off-by: Bernhard Walle <walle@corscience.de>
---
 drivers/i2c/busses/i2c-octeon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index 4cffda5..d07e5c7 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -469,7 +469,7 @@ static struct i2c_adapter octeon_i2c_ops = {
 	.owner = THIS_MODULE,
 	.name = "OCTEON adapter",
 	.algo = &octeon_i2c_algo,
-	.timeout = 2,
+	.timeout = HZ/50,
 };
 
 /**
-- 
1.7.1

