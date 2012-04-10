Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab2DJXqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:46:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42938 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719Ab2DJXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:46:42 -0400
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: philipp@redfish-solutions.com,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Subject: [PATCH] NET5501: Change active_low to 0 for LED driver.
Date: Tue, 10 Apr 2012 23:45:38 +0000
Message-Id: <1334101538-19127-1-git-send-email-gurligebis@gentoo.org>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that there was an error with the active_low = 1 for the
LED, since it should be set to 0 (meaning that active is high,
since 0 is false, hence the confusion.

The wiki article about it confuses it, since it contradicts
itself, regarding what turns on the LED.

I have tested 3.4-rc2 on my net5501 with this patch, and it
makes the LED behave correctly, where "none" turns it off, and
"default-on" turns it on, when echoed onto the trigger "file"
in /sys/class/leds.

Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
---
 arch/x86/platform/geode/net5501.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
index 66d377e..646e3b5 100644
--- a/arch/x86/platform/geode/net5501.c
+++ b/arch/x86/platform/geode/net5501.c
@@ -63,7 +63,7 @@ static struct gpio_led net5501_leds[] = {
 		.name = "net5501:1",
 		.gpio = 6,
 		.default_trigger = "default-on",
-		.active_low = 1,
+		.active_low = 0,
 	},
 };
 
-- 
1.7.8.5

