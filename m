Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab0KVFcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 00:32:03 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44123 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0KVFcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 00:32:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=i2A9+qV69TxKBpPzA76RmHiNHkI6wj32hnsVqZ5WDUwPCz9GA6uuUzvC0pbNGPNufp
         td9U/oxUzFd5mvnzeHrd3pWLIkuxbN5QZUt7Eo+f3sP6+eUTETxAQqxc4VZXoK1rOVcG
         C1vu++zFmXwIHE5OLlPqn931S+L9a6UwGeDAE=
Subject: [PATCH] Input: ams_delta_serio - fix wrong kfree in
	ams_delta_serio_exit
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Mon, 22 Nov 2010 13:36:58 +0800
Message-Id: <1290404218.6941.10.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serio_unregister_port() will call put_device() to free the memory.
Thus remove kfree(ams_delta_serio) after serio_unregister_port(ams_delta_serio).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/serio/ams_delta_serio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/ams_delta_serio.c b/drivers/input/serio/ams_delta_serio.c
index 8f1770e..ebe9553 100644
--- a/drivers/input/serio/ams_delta_serio.c
+++ b/drivers/input/serio/ams_delta_serio.c
@@ -172,6 +172,5 @@ static void __exit ams_delta_serio_exit(void)
 	free_irq(OMAP_GPIO_IRQ(AMS_DELTA_GPIO_PIN_KEYBRD_CLK), 0);
 	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_CLK);
 	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
-	kfree(ams_delta_serio);
 }
 module_exit(ams_delta_serio_exit);
-- 
1.7.2



