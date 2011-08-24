Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1HXArf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:47:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52214 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1HXAra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:47:30 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-54-4e544a20a920
Date: Wed, 24 Aug 2011 09:47:00 +0900
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: RE: [PATCH RESEND] leds: led-bd2802: bd2802_unregister_led_classdev
 should unregister all registered leds
In-reply-to: <1314142337.2198.1.camel@phoenix>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Message-id: <000701cc61f7$555fcd60$001f6820$%kim@samsung.com>
Organization: Samsung Electronics
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acxh7OzNsDjNJ6XWRH2Bkl2PvCzHAAACloPA
References: <1314142337.2198.1.camel@phoenix>
X-OriginalArrivalTime: 24 Aug 2011 00:48:07.0990 (UTC)
 FILETIME=[7DA84D60:01CC61F7]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kim Kyuwon <q1.kim@samsung.com>

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com] 
Sent: Wednesday, August 24, 2011 8:32 AM
To: linux-kernel@vger.kernel.org
Cc: Kim Kyuwon; Richard Purdie; Andrew Morton
Subject: [PATCH RESEND] leds: led-bd2802: bd2802_unregister_led_classdev should unregister all registered leds

bd2802_unregister_led_classdev() should unregister all registered instances of
led_classdev class that had registered by bd2802_register_led_classdev().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-bd2802.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 3ebe382..ea21855 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -662,6 +662,11 @@ failed_unregister_led1_R:
 static void bd2802_unregister_led_classdev(struct bd2802_led *led)
 {
 	cancel_work_sync(&led->work);
+	led_classdev_unregister(&led->cdev_led2b);
+	led_classdev_unregister(&led->cdev_led2g);
+	led_classdev_unregister(&led->cdev_led2r);
+	led_classdev_unregister(&led->cdev_led1b);
+	led_classdev_unregister(&led->cdev_led1g);
 	led_classdev_unregister(&led->cdev_led1r);
 }
 
-- 
1.7.4.1



