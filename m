Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab0KVGBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 01:01:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50365 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0KVGBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 01:01:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=smTzpjyjg/v+KiaykekIMb14jcek/vJjlqmG2mmWh0O/9/d4XU0leZ59dGCsMjdpd6
         jrFiK79Pph07hXkO+I2c5UWK2kr/FbD1XWgbrHQViXZwW2CwfdPA3/RZSYETuMfprgTd
         XadscIZZLP1C9e9lgwUK5d+jhc1h24Yx8Kg1c=
Subject: [RFC][PATCH] Input: ct82c710 - remove a redundant
	serio_register_port()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Vojtech Pavlik <vojtech@ucw.cz>
Content-Type: text/plain
Date: Mon, 22 Nov 2010 14:06:47 +0800
Message-Id: <1290406007.6941.15.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already call serio_register_port() in ct82c710_probe(),
thus remove a redundant serio_register_port() in ct82c710_init().

Looks like this bug is introduced by 
916d83cfe5da1cda454d8b0ae233f06b58bd7f91
"Input: ct82c710 - convert to the new platform device interface"

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I don't have this hardware handy, I appreciate if someone can test this patch.

Regards,
Axel

 drivers/input/serio/ct82c710.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/ct82c710.c b/drivers/input/serio/ct82c710.c
index 4a30846..0f8304a 100644
--- a/drivers/input/serio/ct82c710.c
+++ b/drivers/input/serio/ct82c710.c
@@ -237,8 +237,6 @@ static int __init ct82c710_init(void)
 	if (error)
 		goto err_free_device;
 
-	serio_register_port(ct82c710_port);
-
 	printk(KERN_INFO "serio: C&T 82c710 mouse port at %#llx irq %d\n",
 		(unsigned long long)CT82C710_DATA, CT82C710_IRQ);
 
-- 
1.7.2



