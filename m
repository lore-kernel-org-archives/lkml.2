Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab2BPDv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 22:51:59 -0500
Received: from ozlabs.org ([203.10.76.45]:47643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab2BPDv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 22:51:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Message-ID: <1329364286.15810.rusty@rustcorp.com.au>
Date: Thu, 16 Feb 2012 14:21:26 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] cpumask: remove old cpu_*_map.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

These are obsolete: cpu_*_mask provides (const) pointers.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/cpumask.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -763,12 +763,6 @@ static inline const struct cpumask *get_
  *
  */
 #ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
-/* These strip const, as traditionally they weren't const. */
-#define cpu_possible_map	(*(cpumask_t *)cpu_possible_mask)
-#define cpu_online_map		(*(cpumask_t *)cpu_online_mask)
-#define cpu_present_map		(*(cpumask_t *)cpu_present_mask)
-#define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
-
 #define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)

