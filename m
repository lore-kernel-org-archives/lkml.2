Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1HEI40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:56:26 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:39796 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1HEI4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:56:24 -0400
Subject: [RFC][PATCH] of: add a dummy implementation of of_get_property()
 in of.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, John Bonesio <bones@secretlab.ca>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, "Sam Ravnborg sam"@ravnborg.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Aug 2011 16:56:14 +0800
Message-ID: <1312534574.18064.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then we can avoid having #ifdef CONFIG_OF splattered around the place
calling of_get_property(), it leads to errors.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch fixes below build error with "make tegra_defconfig;make".

  CC      drivers/i2c/busses/i2c-tegra.o
drivers/i2c/busses/i2c-tegra.c: In function 'tegra_i2c_probe':
drivers/i2c/busses/i2c-tegra.c:615: error: implicit declaration of function 'of_get_property'
drivers/i2c/busses/i2c-tegra.c:616: warning: assignment makes pointer from integer without a cast
make[3]: *** [drivers/i2c/busses/i2c-tegra.o] Error 1
make[2]: *** [drivers/i2c/busses] Error 2
make[1]: *** [drivers/i2c] Error 2
make: *** [drivers] Error 2

Regards,
Axel
 include/linux/of.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 0085bb0..320cbad 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -256,6 +256,12 @@ static inline int of_property_read_string(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline const void *of_get_property(const struct device_node *np,
+					  const char *name, int *lenp)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_OF */
 
 static inline int of_property_read_u32(const struct device_node *np,
-- 
1.7.4.1



