Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab1ERSeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:34:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:44789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459Ab1ERSeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:34:16 -0400
Date: Wed, 18 May 2011 18:34:09 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-f0201738b61b1adcf6b2c4719c5c415745014c1c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20110421023738.953028219@goodmis.org>
References: <20110421023738.953028219@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Avoid recording mcount on .init sections directly
Git-Commit-ID: f0201738b61b1adcf6b2c4719c5c415745014c1c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 18:34:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0201738b61b1adcf6b2c4719c5c415745014c1c
Gitweb:     http://git.kernel.org/tip/f0201738b61b1adcf6b2c4719c5c415745014c1c
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 12 Apr 2011 19:06:39 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 16 May 2011 14:46:30 -0400

ftrace: Avoid recording mcount on .init sections directly

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
 
