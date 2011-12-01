Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1LABtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:49:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55852 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1LABtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:49:14 -0500
Message-ID: <1322704147.11560.4.camel@phoenix>
Subject: [PATCH 2/4] mfd: dm355evm_msp: Use gpio_request_one
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 01 Dec 2011 09:49:07 +0800
In-Reply-To: <1322704074.11560.3.camel@phoenix>
References: <1322704074.11560.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_request_one() instead of multiple gpiolib calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/dm355evm_msp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
index 8ad88da..7710227 100644
--- a/drivers/mfd/dm355evm_msp.c
+++ b/drivers/mfd/dm355evm_msp.c
@@ -308,8 +308,7 @@ static int add_children(struct i2c_client *client)
 	for (i = 0; i < ARRAY_SIZE(config_inputs); i++) {
 		int gpio = dm355evm_msp_gpio.base + config_inputs[i].offset;
 
-		gpio_request(gpio, config_inputs[i].label);
-		gpio_direction_input(gpio);
+		gpio_request_one(gpio, GPIOF_IN, config_inputs[i].label);
 
 		/* make it easy for userspace to see these */
 		gpio_export(gpio, false);
-- 
1.7.5.4



