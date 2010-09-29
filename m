Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab0I2EgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 00:36:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49315
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab0I2EgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 00:36:00 -0400
Date: Tue, 28 Sep 2010 21:36:20 -0700 (PDT)
Message-Id: <20100928.213620.193710221.davem@davemloft.net>
To: gregkh@suse.de
CC: feng.tang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mrst_max3110: Missing linux/irq.h include.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This driver makes use of IRQ_TYPE_EDGE_FALLING, therefore it must
include linux/irq.h

drivers/serial/mrst_max3110.c: In function 'serial_m3110_startup':
drivers/serial/mrst_max3110.c:470:5: error: 'IRQ_TYPE_EDGE_FALLING' undeclared (first use in this function)
drivers/serial/mrst_max3110.c:470:5: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/serial/mrst_max3110.c b/drivers/serial/mrst_max3110.c
index f6ad1ec..915dedc 100644
--- a/drivers/serial/mrst_max3110.c
+++ b/drivers/serial/mrst_max3110.c
@@ -33,6 +33,7 @@
 #include <linux/console.h>
 #include <linux/sysrq.h>
 #include <linux/platform_device.h>
+#include <linux/irq.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
