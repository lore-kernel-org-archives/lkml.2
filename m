Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab1CCOAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:00:22 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45085 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab1CCOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:00:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QxoMq1II5/3oNQ/18nZj76sRsF+FXENfTKI/VQFJ1na9/gCIuojrDq3RmqTv7pUC0i
         UoX26at/pD67Jyobtc5QFD2Y2rhk0igaeBPC0I0Et5vKWqU7xG5Gn8Ns2GhRCgemMb10
         WLfRcs7IGcVDOfe6KW/1ogin+ImwU6fEXQfhM=
Date: Thu, 3 Mar 2011 22:00:10 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/05] change to use proc_dointvec_bool while needed
Message-ID: <20110303140010.GC2620@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change only 0 and 1 valid sysctl case to use proc_do_intvec_bool handler

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 kernel/sysctl.c |   32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

--- linux-2.6.orig/kernel/sysctl.c	2011-03-03 10:46:05.693332219 +0800
+++ linux-2.6/kernel/sysctl.c	2011-03-03 10:49:12.343331496 +0800
@@ -342,9 +342,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 #endif
 	{
@@ -374,9 +372,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_autogroup_enabled,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 #endif
 #ifdef CONFIG_PROVE_LOCKING
@@ -704,9 +700,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 	{
 		.procname	= "kptr_restrict",
@@ -747,9 +741,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 	{
 		.procname       = "nmi_watchdog",
@@ -861,9 +853,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 	{
 		.procname	= "hung_task_check_count",
@@ -1297,9 +1287,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &vm_highmem_is_dirtyable,
 		.maxlen		= sizeof(vm_highmem_is_dirtyable),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 #endif
 	{
@@ -1315,18 +1303,14 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_memory_failure_early_kill,
 		.maxlen		= sizeof(sysctl_memory_failure_early_kill),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 	{
 		.procname	= "memory_failure_recovery",
 		.data		= &sysctl_memory_failure_recovery,
 		.maxlen		= sizeof(sysctl_memory_failure_recovery),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_dointvec_bool,
 	},
 #endif
 	{ }
