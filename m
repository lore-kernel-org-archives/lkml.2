Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2DTDsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:48:13 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:47089 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2DTDsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:48:12 -0400
Message-ID: <1334893688.3051.5.camel@lorien2>
Subject: [PATCH] leds: add new field to led_classdev struct to save
 activation state
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuahkhan@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Date: Thu, 19 Apr 2012 21:48:08 -0600
In-Reply-To: <20120417161239.57c41966.akpm@linux-foundation.org>
References: <1334703911.2655.9.camel@lorien2>
	 <20120417161239.57c41966.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new field to led_classdev to save activattion state
after activate routine is successful. This saved state is used in 
deactivate routine to do cleanup such as removing device files, and
free memory allocated during activation. Currently trigger_data not being
null is used for this purpose.

Existing triggers will need changes to use this new field.

>From 3765101a5ffe32edd68a71bafca2d6d262cf2399 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Thu, 19 Apr 2012 20:44:15 -0600
Subject: [PATCH] leds: add new field to led_classdev struct to save
 activation state


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 include/linux/leds.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5884def..39eee41 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -73,6 +73,8 @@ struct led_classdev {
 	struct led_trigger	*trigger;
 	struct list_head	 trig_list;
 	void			*trigger_data;
+	/* true if activated - deactivate routine uses it to do cleanup */
+	bool			activated;
 #endif
 };
 
-- 
1.7.5.4



