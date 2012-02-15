Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab2BOFAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:00:19 -0500
Received: from ozlabs.org ([203.10.76.45]:34710 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab2BOFAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:00:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Message-ID: <1329281884.18410.rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030
Subject: [PATCH 12/12] cpumask: remove old cpu_*_map.
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

