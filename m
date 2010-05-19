Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0ESPvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:51:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0ESPvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:51:45 -0400
Date: Thu, 20 May 2010 01:51:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/17] mtd: update gfp/slab.h includes
Message-Id: <20100520015143.a7593612.sfr@canb.auug.org.au>
In-Reply-To: <1269885165-18617-12-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-12-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 30 Mar 2010 02:52:39 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.

Please apply to the mtd tree (patch reposted below).

From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 11/17] mtd: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:39 +0900

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/mtdcore.c          |    1 +
 drivers/mtd/nand/mpc5121_nfc.c |    1 +
 drivers/mtd/nand/r852.c        |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index e8573c9..3c48193 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -18,6 +18,7 @@
 #include <linux/proc_fs.h>
 #include <linux/idr.h>
 #include <linux/backing-dev.h>
+#include <linux/gfp.h>
 
 #include <linux/mtd/mtd.h>

diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index d7333f4..1a06f78 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -27,6 +27,7 @@
 
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/gfp.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index 96bfbd8..dd5158c 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -15,6 +15,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <asm/byteorder.h>
 #include <linux/sched.h>
 #include "sm_common.h"
-- 
1.6.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
