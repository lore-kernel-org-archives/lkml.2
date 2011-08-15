Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1HOXgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:36:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48588 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1HOXgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:36:11 -0400
Date: Tue, 16 Aug 2011 09:36:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regmap: using module facilities requires module.h
Message-Id: <20110816093606.a764b904550c84f7db4c1b2d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b33f9cbd67ba ("regmap: Specify a module license") added a
MODULES_LICENSE to this file without adding an include of module.h.
module.h should ahve been included anyway, since this file has
EXPORT_SYMBOLs as well.   With the pending module.h spliit up, this would
probably caused build problems.

Cc: Stephen Warren <swarren@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/regmap/regmap-spi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

I am sorry that I have not even build tested this patch, but it is pretty
obvious.

diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index 2bbc659..f839694 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -13,6 +13,7 @@
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
 #include <linux/init.h>
+#include <linux/module.h>
 
 static int regmap_spi_write(struct device *dev, const void *data, size_t count)
 {
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
