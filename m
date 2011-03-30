Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1C3MQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:16:45 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:47958 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634Ab1C3MQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:16:44 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Peter Tyser <ptyser@xes-inc.com>,
        toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_gpio: Fix output value of pch_gpio_direction_output()
Date: Wed, 30 Mar 2011 21:16:26 +0900
Message-Id: <1301487386-29101-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pch_gpio_direction_output() function was missing a write to set the
desired output value.  The function would properly set the GPIO
direction, but not the output value.  The value would have to manually
be set with a follow up call to pch_gpio_set().

Add the missing write so that pch_gpio_direction_output() sets both the
GPIO direction and value.

Reported-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/pch_gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index 0eba0a7..b4e9915 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -105,6 +105,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 		reg_val |= (1 << nr);
 	else
 		reg_val &= ~(1 << nr);
+	iowrite32(reg_val, &chip->reg->po);
 
 	mutex_unlock(&chip->lock);
 
-- 
1.7.4

