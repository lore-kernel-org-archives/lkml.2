Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1LIBjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:39:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49526 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1LIBjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:39:20 -0500
Message-ID: <1323394752.3740.3.camel@phoenix>
Subject: [PATCH 2/2] Input: keyboard: Staticise non-exported symbols
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Naveen Kumar G <naveen.gaddipati@stericsson.com>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Date: Fri, 09 Dec 2011 09:39:12 +0800
In-Reply-To: <1323394677.3740.2.camel@phoenix>
References: <1323394677.3740.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These symbols are not used outside it's driver so no need to
make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/bf54x-keys.c         |    2 +-
 drivers/input/keyboard/nomadik-ske-keypad.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index 683e314..8eb9116 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -384,7 +384,7 @@ static int bfin_kpad_resume(struct platform_device *pdev)
 # define bfin_kpad_resume  NULL
 #endif
 
-struct platform_driver bfin_kpad_device_driver = {
+static struct platform_driver bfin_kpad_device_driver = {
 	.driver		= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index 6c4828f..5a71e55 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -379,7 +379,7 @@ static const struct dev_pm_ops ske_keypad_dev_pm_ops = {
 };
 #endif
 
-struct platform_driver ske_keypad_driver = {
+static struct platform_driver ske_keypad_driver = {
 	.driver = {
 		.name = "nmk-ske-keypad",
 		.owner  = THIS_MODULE,
-- 
1.7.5.4



