Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1BNKhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:37:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BNKhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:37:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ki7qzUMLjBb7CtWocECQm4BsTfLbzPdX8vX2uS/p7IUTdUM8saVTIac8G9AGbHR0/K
         FZNRh0AeUqfQe7fywTPVW9Slb7ZvgUR/1M0rIoWtcQzr9FlfwqttTizDZs3tlWIvlwu1
         VGHdNoyT6j25/mkQC03aVSqftW1kRLFQqyA8M=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] tosa-bt: drop setting LED trigger name, as it's unsupported now
Date: Mon, 14 Feb 2011 13:36:42 +0300
Message-Id: <1297679802-24669-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2e48928d8a0f38c1b5c81eb3f1294de8a6382c68 it's no longer possible to set
the name of the LED trigger for RFKILL events. Drop respective code from tosa-bt.c

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
 arch/arm/mach-pxa/tosa-bt.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/tosa-bt.c b/arch/arm/mach-pxa/tosa-bt.c
index c31e601..b9b1e5c 100644
--- a/arch/arm/mach-pxa/tosa-bt.c
+++ b/arch/arm/mach-pxa/tosa-bt.c
@@ -81,8 +81,6 @@ static int tosa_bt_probe(struct platform_device *dev)
 		goto err_rfk_alloc;
 	}
 
-	rfkill_set_led_trigger_name(rfk, "tosa-bt");
-
 	rc = rfkill_register(rfk);
 	if (rc)
 		goto err_rfkill;
-- 
1.7.2.3

