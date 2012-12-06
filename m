Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab2LFNVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 08:21:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56824 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2LFNVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 08:21:49 -0500
From: Christian Gmeiner <christian.gmeiner@gmail.com>
To: linux-next@vger.kernel.org, akpm@linux-foundation.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH] leds-ot200: Fix error caused by shifted mask
Date: Thu,  6 Dec 2012 14:21:38 +0100
Message-Id: <1354800098-4118-1-git-send-email-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the development of this driver an in-house register
documentation was used. The last weeks some integration tests
were done and this problem was found. It turned out that
the released register documentation is wrong.

The fix is very simple: shift all masks by one.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/leds/leds-ot200.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
index c464682..676e729 100644
--- a/drivers/leds/leds-ot200.c
+++ b/drivers/leds/leds-ot200.c
@@ -47,37 +47,37 @@ static struct ot200_led leds[] = {
 	{
 		.name = "led_1",
 		.port = 0x49,
-		.mask = BIT(7),
+		.mask = BIT(6),
 	},
 	{
 		.name = "led_2",
 		.port = 0x49,
-		.mask = BIT(6),
+		.mask = BIT(5),
 	},
 	{
 		.name = "led_3",
 		.port = 0x49,
-		.mask = BIT(5),
+		.mask = BIT(4),
 	},
 	{
 		.name = "led_4",
 		.port = 0x49,
-		.mask = BIT(4),
+		.mask = BIT(3),
 	},
 	{
 		.name = "led_5",
 		.port = 0x49,
-		.mask = BIT(3),
+		.mask = BIT(2),
 	},
 	{
 		.name = "led_6",
 		.port = 0x49,
-		.mask = BIT(2),
+		.mask = BIT(1),
 	},
 	{
 		.name = "led_7",
 		.port = 0x49,
-		.mask = BIT(1),
+		.mask = BIT(0),
 	}
 };
 
-- 
1.7.10.4

