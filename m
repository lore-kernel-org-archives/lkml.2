Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0C2GOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:14:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60444 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0C2GNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:13:43 -0400
Date: Mon, 29 Mar 2010 16:47:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: build failure after merge of the slabh tree
Message-Id: <20100329164748.e1e16358.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

After merging the slabh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/input/misc/pcf8574_keypad.c: In function 'pcf8574_kp_probe':
drivers/input/misc/pcf8574_keypad.c:95: error: implicit declaration of function 'kzalloc'
drivers/input/misc/pcf8574_keypad.c:95: warning: assignment makes pointer from integer without a cast
drivers/input/misc/pcf8574_keypad.c:156: error: implicit declaration of function 'kfree'

Caused by commit d103d3b3e8512312b5254950035366d4422a479a ("percpu: don't
implicitly include slab.h from percpu.h") from the slabh tree interacting
with commit 88643169de358b8e5af101151d913ad80e4c64df ("Input: add PCF8574
I2C keypad input device driver") from the input tree.

I applied the following merge fixup patch which should be applied to the
input tree (see Documentation/SubmitChecklist Rule #1 :-)).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Mar 2010 16:45:42 +1100
Subject: [PATCH] input: pcf8574_keypad: use of kzalloc/kfree requires the include of slab.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/input/misc/pcf8574_keypad.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/pcf8574_keypad.c b/drivers/input/misc/pcf8574_keypad.c
index cb135e5..5c3ac4e 100644
--- a/drivers/input/misc/pcf8574_keypad.c
+++ b/drivers/input/misc/pcf8574_keypad.c
@@ -11,6 +11,7 @@
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/workqueue.h>
 
 #define DRV_NAME "pcf8574_keypad"
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
