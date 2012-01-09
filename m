Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab2AIQuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:50:50 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:48357 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2AIQus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:50:48 -0500
From: =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <jeff.dagenais@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: michael.hennerich@analog.com, grant.likely@secretlab.ca,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <jeff.dagenais@gmail.com>
Subject: [PATCH 1/2] input: adp5588 - add support for gpio names
Date: Mon,  9 Jan 2012 11:50:19 -0500
Message-Id: <1326127820-29682-1-git-send-email-jeff.dagenais@gmail.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <1326121523-28634-2-git-send-email-jeff.dagenais@gmail.com>
References: <1326121523-28634-2-git-send-email-jeff.dagenais@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jean-François Dagenais <jeff.dagenais@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
---
 drivers/input/keyboard/adp5588-keys.c |    1 +
 include/linux/i2c/adp5588.h           |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index e34eeb8..6412ced 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -197,6 +197,7 @@ static int __devinit adp5588_gpio_add(struct adp5588_kpad *kpad)
 	kpad->gc.base = gpio_data->gpio_start;
 	kpad->gc.label = kpad->client->name;
 	kpad->gc.owner = THIS_MODULE;
+	kpad->gc.names = gpio_data->names;
 
 	mutex_init(&kpad->gpio_lock);
 
diff --git a/include/linux/i2c/adp5588.h b/include/linux/i2c/adp5588.h
index cec17cf..d8341cb 100644
--- a/include/linux/i2c/adp5588.h
+++ b/include/linux/i2c/adp5588.h
@@ -157,6 +157,7 @@ struct i2c_client; /* forward declaration */
 
 struct adp5588_gpio_platform_data {
 	int gpio_start;		/* GPIO Chip base # */
+	const char *const *names;
 	unsigned irq_base;	/* interrupt base # */
 	unsigned pullup_dis_mask; /* Pull-Up Disable Mask */
 	int	(*setup)(struct i2c_client *client,
-- 
1.7.8.2

