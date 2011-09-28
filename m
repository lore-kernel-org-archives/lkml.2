Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1I1HKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:10:41 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:59452 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab1I1HKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:10:40 -0400
Date: Wed, 28 Sep 2011 17:10:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110928171034.0b332cfb02006f88124fef5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/tty/hvc/hvc_opal.c:244:12: error: 'THIS_MODULE' undeclared here (not in a function)

Caused by commit daea1175a9f0 ("powerpc/powernv: Support for OPAL
console") from the powerpc tree interacting with the module.h split up.

I have applied the below patch for today (and will carry it as a merge
fix up as necessary).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 17:07:24 +1000
Subject: [PATCH] powerpc/powernv: include export.h in hvc_opal.h for
 THIS_MODULE

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/tty/hvc/hvc_opal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/hvc/hvc_opal.c b/drivers/tty/hvc/hvc_opal.c
index 7b38512..ced26c8 100644
--- a/drivers/tty/hvc/hvc_opal.c
+++ b/drivers/tty/hvc/hvc_opal.c
@@ -28,6 +28,7 @@
 #include <linux/console.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/export.h>
 
 #include <asm/hvconsole.h>
 #include <asm/prom.h>
-- 
1.7.6.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
