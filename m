Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1JLXHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 19:07:03 -0400
Received: from loki.mindstab.net ([69.164.214.81]:55516 "EHLO loki.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752443Ab1JLXHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 19:07:00 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Oct 2011 19:07:00 EDT
From: Dan Ballard <dan@mindstab.net>
To: Dan Ballard <dan@mindstab.net>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Dan Ballard <dan@mindstab.net>
Subject: [PATCH 1/1] added code to export CAP_LAST_CAP in /proc/sys/kernel modeled after ngroups_max
Date: Wed, 12 Oct 2011 15:56:34 -0700
Message-Id: <1318460194-31983-1-git-send-email-dan@mindstab.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In response to a request by the Linux Plumbers about getting CAP_LAST_CAP exposed somehow, I talked to Lennart Poettering briefly and went ahead and added cap_last_cap to /proc/sys/kernel in a similar fashion as ngroups_max is exported.  The patch is simple and just adds another struct to the array of exported values in sysctl.c.

Signed-off-by: Dan Ballard <dan@mindstab.net>
---
 kernel/sysctl.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 11d65b5..0cef3c2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -57,6 +57,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/kmod.h>
+#include <linux/capability.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -134,6 +135,7 @@ static int minolduid;
 static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
+static int cap_last_cap = CAP_LAST_CAP;
 
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
@@ -730,6 +732,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "cap_last_cap",
+		.data		= &cap_last_cap,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #if defined(CONFIG_LOCKUP_DETECTOR)
 	{
 		.procname       = "watchdog",
-- 
1.7.4.1

