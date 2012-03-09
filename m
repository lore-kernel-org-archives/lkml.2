Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab2CITcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:32:00 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:39689 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752537Ab2CITb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:31:58 -0500
Message-ID: <4F5A5AAD.1000105@xenotime.net>
Date: Fri, 09 Mar 2012 11:31:57 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] regmap: add structs to fix build warnings when REGMAP
 is not enabled
References: <20120309191101.8634973f7d9988c602143f7c@canb.auug.org.au>
In-Reply-To: <20120309191101.8634973f7d9988c602143f7c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build warnings when CONFIG_REGMAP is not enabled by providing
struct forward references.

  CC [M]  sound/soc/soc-core.o
In file included from include/sound/soc.h:22:0,
                 from sound/soc/soc-core.c:41:
include/linux/regmap.h:230:11: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:230:11: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/regmap.h:237:8: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:244:9: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:251:10: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:258:7: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:265:8: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:272:10: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:281:9: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:287:47: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:293:40: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:300:12: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:306:47: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:311:49: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:316:47: warning: 'struct regmap' declared inside parameter list
include/linux/regmap.h:323:6: warning: 'struct reg_default' declared inside parameter list
include/linux/regmap.h:323:6: warning: 'struct regmap' declared inside parameter list

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regmap.h |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20120308.orig/include/linux/regmap.h
+++ linux-next-20120308/include/linux/regmap.h
@@ -226,6 +226,9 @@ int regmap_irq_chip_get_base(struct regm
  * REGMAP.
  */
 
+struct regmap;
+struct reg_default;
+
 static inline int regmap_write(struct regmap *map, unsigned int reg,
 			       unsigned int val)
 {
