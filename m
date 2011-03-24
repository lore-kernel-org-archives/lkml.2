Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370Ab1CXXRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:17:32 -0400
Received: from xes-mad.com ([216.165.139.218]:16849 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934349Ab1CXXR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:17:29 -0400
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, tomoya-linux@dsn.okisemi.com,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] gpio: ml_ioh_gpio: Fix output value of ioh_gpio_direction_output()
Date: Thu, 24 Mar 2011 18:17:14 -0500
Message-Id: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioh_gpio_direction_output() function was missing a write to set the
desired output value.  The function would properly set the GPIO
direction, but not the output value.  The value would have to manually
be set with a follow up call to ioh_gpio_set().

Add the missing write so that ioh_gpio_direction_output() sets both the
GPIO direction and value.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Cc: tomoya-linux@dsn.okisemi.com
Cc: Grant Likely <grant.likely@secretlab.ca>
---
This is untested - just noticed it while working on an unrelated change.  An
ack or tested-by from someone with real hardware would be appreciated.

 drivers/gpio/ml_ioh_gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/ml_ioh_gpio.c b/drivers/gpio/ml_ioh_gpio.c
index cead8e6..7a0423c 100644
--- a/drivers/gpio/ml_ioh_gpio.c
+++ b/drivers/gpio/ml_ioh_gpio.c
@@ -116,6 +116,7 @@ static int ioh_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 		reg_val |= (1 << nr);
 	else
 		reg_val &= ~(1 << nr);
+	iowrite32(reg_val, &chip->reg->regs[chip->ch].po);
 
 	mutex_unlock(&chip->lock);
 
-- 
1.7.0.4

