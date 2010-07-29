Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0G2KpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:45:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51614 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0G2KpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TH22/3LXbdkgZKqPmBoFGS/5+vQ7+pL+03lVp07sGKoiDzOQ8wMG4wItxcoa8JNMN7
         SGepAigDj2X7n5Gd0gFCKxPE3U2ANEsCUbA3aM8JE9u2vponH81HHQNSP3HZJFEkkTn/
         cvfa/f6InVd5WpTyShG+CVh3FBD1etmC2X6Co=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10 v2] arm: leds: check return value of request_region()
Date: Thu, 29 Jul 2010 14:44:26 +0400
Message-Id: <1280400267-4659-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_region() may fail, if so return -EBUSY.

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
+		return -EBUSY;
 	temp = sequoia_read(0x09);
 	temp |= 1<<10;
 	sequoia_write(temp,0x09);
-- 
1.7.0.4

