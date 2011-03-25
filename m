Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1CYPEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:04:20 -0400
Received: from xes-mad.com ([216.165.139.218]:22856 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab1CYPET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:04:19 -0400
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] gpio: pch_gpio: Fix output value of pch_gpio_direction_output()
Date: Fri, 25 Mar 2011 10:04:00 -0500
Message-Id: <1301065440-2418-1-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com>
References: <1301008634-25429-1-git-send-email-ptyser@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pch_gpio_direction_output() function was missing a write to set the
desired output value.  The function would properly set the GPIO
direction, but not the output value.  The value would have to manually
be set with a follow up call to pch_gpio_set().

Add the missing write so that pch_gpio_direction_output() sets both the
GPIO direction and value.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
Just noticed this driver has the same bug.  This file looks nearly identical
to ml_ioh_gpio.c.  They could likely be combined with minimal effort.

 drivers/gpio/pch_gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index c59d953..fa52862 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -105,6 +105,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 		reg_val |= (1 << nr);
 	else
 		reg_val &= ~(1 << nr);
+	iowrite32(reg_val, &chip->reg->po);
 
 	mutex_unlock(&chip->lock);
 
-- 
1.7.0.4

