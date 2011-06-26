Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1F0PjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:39:09 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40684 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751470Ab1F0PiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:38:12 -0400
Message-Id: <80b466304bc1fceee1abff1771bacdd2bdf9bd1b.1309182743.git.ralf@linux-mips.org>
In-Reply-To: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
References: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
From: Ralf Baechle <ralf@linux-mips.org>
To: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Date: Sun, 26 Jun 2011 12:31:50 +0100
Subject: [PATCH 09/12] LED: lp5523: Fix section mismatches.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/leds/leds-lp5523.o(.text+0x12f4): Section mismatch in reference from the function lp5523_probe() to the function .init.text:lp5523_init_led()
The function lp5523_probe() references
the function __init lp5523_init_led().
This is often because lp5523_probe lacks a __init
annotation or the annotation of lp5523_init_led is wrong.

Fixing this one triggers one more mismatch, fix that one as well.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
---
 drivers/leds/leds-lp5523.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index e19fed2..5971e309 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -826,7 +826,7 @@ static int __init lp5523_init_engine(struct lp5523_engine *engine, int id)
 	return 0;
 }
 
-static int __init lp5523_init_led(struct lp5523_led *led, struct device *dev,
+static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
 			   int chan, struct lp5523_platform_data *pdata)
 {
 	char name[32];
@@ -872,7 +872,7 @@ static int __init lp5523_init_led(struct lp5523_led *led, struct device *dev,
 
 static struct i2c_driver lp5523_driver;
 
-static int lp5523_probe(struct i2c_client *client,
+static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct lp5523_chip		*chip;
-- 
1.7.4.4

