Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab1IFCfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 22:35:18 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33123 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab1IFCfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 22:35:11 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] nitpick: enclose hotplug only variables in hotplug ifdef
Date: Mon,  5 Sep 2011 23:34:19 -0300
Message-Id: <1315276459-10775-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These variables are only used when CONFIG_HOTPLUG is enabled,
they are ifdef'ed everywhere else. So don't define them when
CONFIG_HOTPLUG is not enabled.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 lib/percpu_counter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 28f2c33..30cbe47 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -10,8 +10,10 @@
 #include <linux/module.h>
 #include <linux/debugobjects.h>
 
+#ifdef CONFIG_HOTPLUG_CPU
 static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
+#endif
 
 #ifdef CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
 
-- 
1.7.6

