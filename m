Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750921Ab2KOWBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:01:50 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51713 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2KOWBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:01:46 -0500
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 15 Nov 2012 23:01:22 +0100
Message-ID: <CAH9NwWfPFnNxss0Ne4JRH4DQLZCPE3MAGGK7xfCvfz0+6_aO9w@mail.gmail.com>
Subject: [PATCH RESEND] leds-ot200: Fix error caused by shifted mask
To: linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the development of this driver an in-house register
documentation was used. The last weeks some integration tests
were done and this problem was found. It turned out that
the released register documentation is wrong.

The fix is very simple: shift all mask by one.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/leds/leds-ot200.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
index c464682..676e729 100644
--- a/drivers/leds/leds-ot200.c
+++ b/drivers/leds/leds-ot200.c
@@ -47,37 +47,37 @@ static struct ot200_led leds[] = {
        {
                .name = "led_1",
                .port = 0x49,
-               .mask = BIT(7),
+               .mask = BIT(6),
        },
        {
                .name = "led_2",
                .port = 0x49,
-               .mask = BIT(6),
+               .mask = BIT(5),
        },
        {
                .name = "led_3",
                .port = 0x49,
-               .mask = BIT(5),
+               .mask = BIT(4),
        },
        {
                .name = "led_4",
                .port = 0x49,
-               .mask = BIT(4),
+               .mask = BIT(3),
        },
        {
                .name = "led_5",
                .port = 0x49,
-               .mask = BIT(3),
+               .mask = BIT(2),
        },
        {
                .name = "led_6",
                .port = 0x49,
-               .mask = BIT(2),
+               .mask = BIT(1),
        },
        {
                .name = "led_7",
                .port = 0x49,
-               .mask = BIT(1),
+               .mask = BIT(0),
        }
 };


--
1.7.12.2.421.g261b511
