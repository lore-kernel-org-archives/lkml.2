Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1I1HSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:18:39 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:57879 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1I1HSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:18:38 -0400
Date: Wed, 28 Sep 2011 17:18:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Pihet <j-pihet@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: build warning after merge of the moduleh tree
Message-Id: <20110928171835.ba767809909ac049fc53bd40@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (powerepc
ppc64_defconfig) produced this warning:

drivers/base/power/qos.c:256:1: warning: data definition has no type or storage class
drivers/base/power/qos.c:256:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/base/power/qos.c:256:1: warning: parameter names (without types) in function declaration
drivers/base/power/qos.c:301:1: warning: data definition has no type or storage class
drivers/base/power/qos.c:301:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/base/power/qos.c:301:1: warning: parameter names (without types) in function declaration
drivers/base/power/qos.c:342:1: warning: data definition has no type or storage class
drivers/base/power/qos.c:342:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/base/power/qos.c:342:1: warning: parameter names (without types) in function declaration
drivers/base/power/qos.c:369:1: warning: data definition has no type or storage class
drivers/base/power/qos.c:369:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/base/power/qos.c:369:1: warning: parameter names (without types) in function declaration
drivers/base/power/qos.c:397:1: warning: data definition has no type or storage class
drivers/base/power/qos.c:397:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/base/power/qos.c:397:1: warning: parameter names (without types) in function declaration
drivers/base/power/qos.c:412:1: warning: data definition has no type or storage class
drivers/base/power/qos.c:412:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/base/power/qos.c:412:1: warning: parameter names (without types) in function declaration
drivers/base/power/qos.c:427:1: warning: data definition has no type or storage class
drivers/base/power/qos.c:427:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
drivers/base/power/qos.c:427:1: warning: parameter names (without types) in function declaration

Caused by commits 91ff4cb803df ("PM QoS: Implement per-device PM QoS
constraints") and b66213cdb002 ("PM QoS: Add global notification
mechanism for device constraints") from the pm tree interacting with the
module.h split up.

I added the following merge fixup patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 17:15:52 +1000
Subject: [PATCH] PM QoS: include export.h in qos.c for EXPORT_SYMBOL

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/power/qos.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/qos.c b/drivers/base/power/qos.c
index f9215e8..7f78682 100644
--- a/drivers/base/power/qos.c
+++ b/drivers/base/power/qos.c
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/export.h>
 
 
 static DEFINE_MUTEX(dev_pm_qos_mtx);
-- 
1.7.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
