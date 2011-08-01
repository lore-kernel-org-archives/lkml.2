Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1HAAan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:30:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43076 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab1HAAag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:30:36 -0400
Date: Mon, 1 Aug 2011 10:30:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jin Park <jinyoungp@nvidia.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus <torvalds@linux-foundation.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110801103027.28dabe088d34567d74072dff@canb.auug.org.au>
In-Reply-To: <20110731074454.GI31842@windriver.com>
References: <20110729170659.91ad989caa407854c5e269a2@canb.auug.org.au>
	<20110731074454.GI31842@windriver.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sun, 31 Jul 2011 03:44:55 -0400 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>
> [linux-next: build failure after merge of the moduleh tree] On 29/07/2011 (Fri 17:06) Stephen Rothwell wrote:
> 
> > After merging the moduleh tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> > 
> > drivers/power/max8997_charger.c:205:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'

This driver is upstream today.  Randy wrote a patch for it (which I will
apply to my fixes tree today):

Date: Fri, 29 Jul 2011 21:11:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] power: max8998_charger.c needs module.h

power/max8998_charger.c uses interfaces from linux/module.h,
so it should include that file.  This fixes build errors.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/power/max8998_charger.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110729.orig/drivers/power/max8998_charger.c
+++ linux-next-20110729/drivers/power/max8998_charger.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>


> [...]
> > drivers/regulator/aat2870-regulator.c:231:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> [...]
> 
> The mmc ones I can fix; the power/regulator ones are not in master yet.
> But since they need module.h, the fix can be applied by their respective
> tree owner as well (vs. ones needing export.h -- which presents a minor
> chicken-and-egg problem).

OK, Randy wrote a fix patch for drivers/regulator/aat2870-regulator.c as
well (which he cc'd to the wrong people :-().  I have it reproduced below
and it should be applied to the mfd tree.   I will apply it myself for
today.

Date: Fri, 29 Jul 2011 12:43:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] regulator: aat2870 needs module.h

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


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
