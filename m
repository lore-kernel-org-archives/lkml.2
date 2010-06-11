Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214Ab0FKKSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:18:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37009 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0FKKRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:15 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] trivial: fix typos concerning "hierarchy"
Date: Fri, 11 Jun 2010 12:16:59 +0200
Message-Id: <1276251424-12806-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100611101624.GD10894@pengutronix.de>
References: <20100611101624.GD10894@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mach-omap2/dpll3xxx.c        |    2 +-
 arch/microblaze/Makefile              |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c |    4 ++--
 drivers/infiniband/hw/cxgb4/qp.c      |    4 ++--
 drivers/scsi/libfc/fc_lport.c         |    6 +++---
 drivers/scsi/libfc/fc_rport.c         |    2 +-
 drivers/scsi/scsi_transport_fc.c      |    2 +-
 kernel/cpuset.c                       |    2 +-
 8 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index b32ccd9..ed8d330 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -463,7 +463,7 @@ int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
 	}
 	if (!ret) {
 		/*
-		 * Switch the parent clock in the heirarchy, and make sure
+		 * Switch the parent clock in the hierarchy, and make sure
 		 * that the new parent's usecount is correct.  Note: we
 		 * enable the new parent before disabling the old to avoid
 		 * any unnecessary hardware disable->enable transitions.
diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index 72f6e85..592c707 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -25,7 +25,7 @@ ifeq (,$(findstring spartan2,$(CONFIG_XILINX_MICROBLAZE0_FAMILY)))
   ifeq ($(CPU_MAJOR),3)
     CPUFLAGS-1 += -mno-xl-soft-mul
   else
-    # USE_HW_MUL can be 0, 1, or 2, defining a heirarchy of HW Mul support.
+    # USE_HW_MUL can be 0, 1, or 2, defining a hierarchy of HW Mul support.
     CPUFLAGS-$(subst 1,,$(CONFIG_XILINX_MICROBLAZE0_USE_HW_MUL)) += -mxl-multiply-high
     CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_HW_MUL) += -mno-xl-soft-mul
   endif
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index ae47bfd..9bbb65b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -816,7 +816,7 @@ static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 	atomic_inc(&qhp->refcnt);
 	spin_unlock_irqrestore(&qhp->lock, *flag);
 
-	/* locking heirarchy: cq lock first, then qp lock. */
+	/* locking hierarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&rchp->lock, *flag);
 	spin_lock(&qhp->lock);
 	cxio_flush_hw_cq(&rchp->cq);
@@ -827,7 +827,7 @@ static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 	if (flushed)
 		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
 
-	/* locking heirarchy: cq lock first, then qp lock. */
+	/* locking hierarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&schp->lock, *flag);
 	spin_lock(&qhp->lock);
 	cxio_flush_hw_cq(&schp->cq);
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 0c28ed1..646a2a5 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -905,7 +905,7 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 	atomic_inc(&qhp->refcnt);
 	spin_unlock_irqrestore(&qhp->lock, *flag);
 
-	/* locking heirarchy: cq lock first, then qp lock. */
+	/* locking hierarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&rchp->lock, *flag);
 	spin_lock(&qhp->lock);
 	c4iw_flush_hw_cq(&rchp->cq);
@@ -916,7 +916,7 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 	if (flushed)
 		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
 
-	/* locking heirarchy: cq lock first, then qp lock. */
+	/* locking hierarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&schp->lock, *flag);
 	spin_lock(&qhp->lock);
 	c4iw_flush_hw_cq(&schp->cq);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 79c9e3c..ef32b06 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -32,11 +32,11 @@
  * invalid SID. We also need to ensure that states don't change unexpectedly
  * while processing another state.
  *
- * HEIRARCHY
+ * HIERARCHY
  *
- * The following heirarchy defines the locking rules. A greater lock
+ * The following hierarchy defines the locking rules. A greater lock
  * may be held before acquiring a lesser lock, but a lesser lock should never
- * be held while attempting to acquire a greater lock. Here is the heirarchy-
+ * be held while attempting to acquire a greater lock. Here is the hierarchy-
  *
  * lport > disc, lport > rport, disc > rport
  *
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 39e440f..2aa5993 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -34,7 +34,7 @@
  * The rport should never hold the rport mutex and then attempt to acquire
  * either the lport or disc mutexes. The rport's mutex is considered lesser
  * than both the lport's mutex and the disc mutex. Refer to fc_lport.c for
- * more comments on the heirarchy.
+ * more comments on the hierarchy.
  *
  * The locking strategy is similar to the lport's strategy. The lock protects
  * the rport's states and is held and released by the entry points to the rport
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0681378..edb6b36 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -965,7 +965,7 @@ static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
 
 /*
  * Note: in the target show function we recognize when the remote
- *  port is in the heirarchy and do not allow the driver to get
+ *  port is in the hierarchy and do not allow the driver to get
  *  involved in sysfs functions. The driver only gets involved if
  *  it's the "old" style that doesn't use rports.
  */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 02b9611..7cb37d8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -105,7 +105,7 @@ struct cpuset {
 	/* for custom sched domain */
 	int relax_domain_level;
 
-	/* used for walking a cpuset heirarchy */
+	/* used for walking a cpuset hierarchy */
 	struct list_head stack_list;
 };
 
-- 
1.7.1

