Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1G3EPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 00:15:24 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33839 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751367Ab1G3EPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 00:15:20 -0400
Date: Fri, 29 Jul 2011 21:13:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH -next] regulator: aat2870-regulator.c needs module.h
Message-Id: <20110729211309.92e8b744.rdunlap@xenotime.net>
In-Reply-To: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

aat2870-regulator.c needs to include linux/module.h to fix multiple
build errors.

drivers/regulator/aat2870-regulator.c:145: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/regulator/aat2870-regulator.c:230: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/regulator/aat2870-regulator.c:231: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/regulator/aat2870-regulator.c:232: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/regulator/aat2870-regulator.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110729.orig/drivers/regulator/aat2870-regulator.c
+++ linux-next-20110729/drivers/regulator/aat2870-regulator.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
