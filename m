Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1BCQ14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:27:56 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:33915 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1BCQ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:27:55 -0500
Date: Thu, 3 Feb 2011 17:25:53 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH R3 2/7] xen/balloon: Removal of driver_pages
Message-ID: <20110203162553.GE1364@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of driver_pages (I do not have seen any references to it).

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 arch/x86/xen/mmu.c    |    3 +--
 drivers/xen/balloon.c |    8 --------
 2 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5e92b61..e7c378e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -78,8 +78,7 @@
 
 /*
  * Protects atomic reservation decrease/increase against concurrent increases.
- * Also protects non-atomic updates of current_pages and driver_pages, and
- * balloon lists.
+ * Also protects non-atomic updates of current_pages and balloon lists.
  */
 DEFINE_SPINLOCK(xen_reservation_lock);
 
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 43f9f02..b4206fd 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -70,11 +70,6 @@ struct balloon_stats {
 	/* We aim for 'current allocation' == 'target allocation'. */
 	unsigned long current_pages;
 	unsigned long target_pages;
-	/*
-	 * Drivers may alter the memory reservation independently, but they
-	 * must inform the balloon driver so we avoid hitting the hard limit.
-	 */
-	unsigned long driver_pages;
 	/* Number of pages in high- and low-memory balloons. */
 	unsigned long balloon_low;
 	unsigned long balloon_high;
@@ -404,7 +399,6 @@ static int __init balloon_init(void)
 	balloon_stats.target_pages  = balloon_stats.current_pages;
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;
-	balloon_stats.driver_pages  = 0UL;
 
 	init_timer(&balloon_timer);
 	balloon_timer.data = 0;
@@ -462,7 +456,6 @@ module_exit(balloon_exit);
 BALLOON_SHOW(current_kb, "%lu\n", PAGES2KB(balloon_stats.current_pages));
 BALLOON_SHOW(low_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_low));
 BALLOON_SHOW(high_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_high));
-BALLOON_SHOW(driver_kb, "%lu\n", PAGES2KB(balloon_stats.driver_pages));
 
 static ssize_t show_target_kb(struct sys_device *dev, struct sysdev_attribute *attr,
 			      char *buf)
@@ -531,7 +524,6 @@ static struct attribute *balloon_info_attrs[] = {
 	&attr_current_kb.attr,
 	&attr_low_kb.attr,
 	&attr_high_kb.attr,
-	&attr_driver_kb.attr,
 	NULL
 };
 
-- 
1.5.6.5

