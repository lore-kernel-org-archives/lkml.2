Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0G1QjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:39:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35241 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0G1QjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AgETnfE8+TiHayp4D0WE+b2NGiqq8yY9QNwo0pUuxqaql2p96iuMSqr8bW9EMYnHdk
         92Q83loDH9ingL5aE7CkY/Q/J/t558WllC9x9dMrIMf9h3nZOJkZVQXNL/yeQ/Ph5/Wf
         9MV7HerBEDppqZPSCBlPt5iCpCHSUXWjXjiQ0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] arm: leds: check return value of request_region()
Date: Wed, 28 Jul 2010 20:38:47 +0400
Message-Id: <1280335127-23145-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_region() may fail, if so return -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/arm/mach-shark/leds.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-shark/leds.c b/arch/arm/mach-shark/leds.c
index c9e32de..cb1a8f2 100644
--- a/arch/arm/mach-shark/leds.c
+++ b/arch/arm/mach-shark/leds.c
@@ -155,7 +155,8 @@ static int __init leds_init(void)
 	leds_event = sequoia_leds_event;
 
 	/* Make LEDs independent of power-state */
-	request_region(0x24,4,"sequoia");
+	if (request_region(0x24, 4, "sequoia") == NULL)
+		return -ENOMEM;
 	temp = sequoia_read(0x09);
 	temp |= 1<<10;
 	sequoia_write(temp,0x09);
-- 
1.7.0.4

