Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab1CCN6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:58:33 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54687 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1CCN6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qrvTSLHzkbjaYq9rlns0Z4vC0h0g9v7atJLQKBOBUtFtkbGQRJLbl48n9dflSuSsWx
         6met8HKIkBhr/BqlaJ0wHUmeZT56a1NSepK02YGy7xygtAAE7aDuXi78AsAj7gQHDP8q
         p+gbZ4lWdJE5YG51gQ0fEEagOYyRq90w94r1c=
Date: Thu, 3 Mar 2011 21:58:20 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/05] use proc_dointvec_minmax to check boundaries while
 needed
Message-ID: <20110303135819.GA2620@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_dointvec doesn't check extra minmax params, use proc_dointvec_minmax
instead of proc_dointvec for cases need boundaries check.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 kernel/sysctl.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.orig/kernel/sysctl.c	2011-03-03 10:44:53.000000000 +0800
+++ linux-2.6/kernel/sysctl.c	2011-03-03 11:02:43.736663258 +0800
@@ -374,7 +374,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_autogroup_enabled,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -1204,7 +1204,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 	{
@@ -1212,7 +1212,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
@@ -1221,7 +1221,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 #endif
@@ -1231,7 +1231,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &zone_reclaim_mode,
 		.maxlen		= sizeof(zone_reclaim_mode),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 	{
@@ -1287,7 +1287,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &vdso_enabled,
 		.maxlen		= sizeof(vdso_enabled),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 #endif
