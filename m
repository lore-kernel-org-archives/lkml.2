Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab1ERQLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:11:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41494 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab1ERQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:10 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=5l_TWgCqJL4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ckL8SMZtzDBEFuW076kA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160908.436533403@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/15] ftrace: Avoid recording mcount on .init sections directly
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-Avoid-recording-mcount-on-.init-sections-dire.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The init and exit sections should not be traced and adding a call to
mcount to them is a waste of text and instruction cache. Have the
macro section attributes include notrace to ignore these functions
for tracing from the build.

Link: http://lkml.kernel.org/r/20110421023738.953028219@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/init.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 577671c..9146f39 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -79,29 +79,29 @@
 #define __exitused  __used
 #endif
 
-#define __exit          __section(.exit.text) __exitused __cold
+#define __exit          __section(.exit.text) __exitused __cold notrace
 
 /* Used for HOTPLUG */
-#define __devinit        __section(.devinit.text) __cold
+#define __devinit        __section(.devinit.text) __cold notrace
 #define __devinitdata    __section(.devinit.data)
 #define __devinitconst   __section(.devinit.rodata)
-#define __devexit        __section(.devexit.text) __exitused __cold
+#define __devexit        __section(.devexit.text) __exitused __cold notrace
 #define __devexitdata    __section(.devexit.data)
 #define __devexitconst   __section(.devexit.rodata)
 
 /* Used for HOTPLUG_CPU */
-#define __cpuinit        __section(.cpuinit.text) __cold
+#define __cpuinit        __section(.cpuinit.text) __cold notrace
 #define __cpuinitdata    __section(.cpuinit.data)
 #define __cpuinitconst   __section(.cpuinit.rodata)
-#define __cpuexit        __section(.cpuexit.text) __exitused __cold
+#define __cpuexit        __section(.cpuexit.text) __exitused __cold notrace
 #define __cpuexitdata    __section(.cpuexit.data)
 #define __cpuexitconst   __section(.cpuexit.rodata)
 
 /* Used for MEMORY_HOTPLUG */
-#define __meminit        __section(.meminit.text) __cold
+#define __meminit        __section(.meminit.text) __cold notrace
 #define __meminitdata    __section(.meminit.data)
 #define __meminitconst   __section(.meminit.rodata)
-#define __memexit        __section(.memexit.text) __exitused __cold
+#define __memexit        __section(.memexit.text) __exitused __cold notrace
 #define __memexitdata    __section(.memexit.data)
 #define __memexitconst   __section(.memexit.rodata)
 
-- 
1.7.4.4


