Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab2BAUes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:34:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2BAUer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:34:47 -0500
Date: Wed, 1 Feb 2012 12:34:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net,
        linux-geode@lists.infradead.org, rpurdie@rpsys.net
Subject: Re: [PATCH v2] backlight: Add backlight driver for Bachmann's ot200
Message-Id: <20120201123446.b8fadecc.akpm@linux-foundation.org>
In-Reply-To: <4F298919.6090009@gmail.com>
References: <4F298919.6090009@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Feb 2012 19:48:57 +0100
Christian Gmeiner <christian.gmeiner@gmail.com> wrote:

> Add backlight driver for Bachmann's ot200 visualisation device. The
> driver uses MFGPT 7 of CS5535 silicon to regulate the backlight.

Looks OK to me.  A couple of little tweaks:

+++ a/drivers/video/backlight/ot200_bl.c
@@ -19,15 +19,15 @@
 static struct cs5535_mfgpt_timer *pwm_timer;
 
 /* this array defines the mapping of brightness in % to pwm frequency */
-static const  u8 dim_table[101] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
-				   2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
-				   4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9,
-				   10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16,
-				   17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28,
-				   30, 31, 33, 35, 37, 39, 41, 43, 45, 47, 50,
-				   53, 55, 58, 61, 65, 68, 72, 75, 79, 84, 88,
-				   93, 97, 103, 108, 114, 120, 126, 133, 140,
-				   147, 155, 163};
+static const u8 dim_table[101] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
+				  2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
+				  4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9,
+				  10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16,
+				  17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28,
+				  30, 31, 33, 35, 37, 39, 41, 43, 45, 47, 50,
+				  53, 55, 58, 61, 65, 68, 72, 75, 79, 84, 88,
+				  93, 97, 103, 108, 114, 120, 126, 133, 140,
+				  147, 155, 163};
 
 struct ot200_backlight_data {
 	int current_brightness;
@@ -51,7 +51,7 @@ static int ot200_backlight_update_status
 	/* enable or disable PWM timer */
 	if (brightness == 0)
 		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP, 0);
-	else if (brightness != 0 && data->current_brightness == 0) {
+	else if (data->current_brightness == 0) {
 		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_COUNTER, 0);
 		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP,
 			MFGPT_SETUP_CNTEN);
_

