Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0DQLNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 07:13:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56234 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757202Ab0DQLNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 07:13:54 -0400
Message-ID: <4BC997F1.4000801@cn.fujitsu.com>
Date: Sat, 17 Apr 2010 19:13:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] srcu: add missing header file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I was writing a module, I hit this compile error.
include/linux/srcu.h:39: error: field 'mutex' has incomplete type
include/linux/srcu.h:41: error: field 'dep_map' has incomplete type

mutex.h is missed in srcu.h, but srcu.h uses struct mutex,
so this patch adds this missing header file.

__percpu is defined in compiler.h which is included in mutex.h already.
But I also include percpu.h because it names "__percpu".

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 4d5ecb2..675a16f 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -27,6 +27,9 @@
 #ifndef _LINUX_SRCU_H
 #define _LINUX_SRCU_H
 
+#include <linux/percpu.h>
+#include <linux/mutex.h>
+
 struct srcu_struct_array {
 	int c[2];
 };

