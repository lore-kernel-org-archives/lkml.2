Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0FWKFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:05:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab0FWKEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:46 -0400
Message-ID: <4C21DC33.6070404@cn.fujitsu.com>
Date: Wed, 23 Jun 2010 18:04:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] percpu: add percpu_variable_ptr()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu variable and allocated percpu data are compatible
witch each other, This patch adds a API, thus we can use
per_cpu_ptr() for defined/declared percpu variable.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index ce2dc65..d5c8d7f 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -81,6 +81,12 @@
 #endif
 
 /*
+ * Ptr of the declared/defined per-CPU variable.
+ * It is totally compatible with the return from alloc_percpu().
+ */
+#define percpu_variable_ptr(name) (&(name))
+
+/*
  * Variant on the per-CPU variable declaration/definition theme used for
  * ordinary per-CPU variables.
  */
