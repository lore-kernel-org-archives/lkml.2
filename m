Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0I2SoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:44:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:55744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0I2SoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:44:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,255,1283756400"; 
   d="scan'208";a="842090350"
From: "Tang, Feng" <feng.tang@intel.com>
To: David Miller <davem@davemloft.net>, "gregkh@suse.de" <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 30 Sep 2010 02:44:00 +0800
Subject: RE: [PATCH] mrst_max3110: Missing linux/irq.h include.
Thread-Topic: [PATCH] mrst_max3110: Missing linux/irq.h include.
Thread-Index: Actfj9L2gjl3Pb1JTVK/dZ+9W5Fd0gAdlqEA
Message-ID: <625BA99ED14B2D499DC4E29D8138F1504CAA26EF73@shsmsx502.ccr.corp.intel.com>
References: <20100928.213620.193710221.davem@davemloft.net>
In-Reply-To: <20100928.213620.193710221.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me, thanks for fixing it.

- Feng
-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: Tuesday, September 28, 2010 11:36 PM
To: gregkh@suse.de
Cc: Tang, Feng; linux-kernel@vger.kernel.org
Subject: [PATCH] mrst_max3110: Missing linux/irq.h include.


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
