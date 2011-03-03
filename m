Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab1CCOCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:02:02 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62598 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462Ab1CCOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hg/AM3k5JeVjSpYvlQl4Zzg6A2R9mpcMtn6yAL7B2LCFVPyOhjLvfC+xvHfmUHtWsO
         Ld4A9ZBf0yOueinVJzvMoEwxUloLEzSPabQr8W9qo3iNJJFmYBMDrm1s1w26TnE6q/63
         iOUbvl2915hNdtvx32zjd97ArVGSmaSiR/pW4=
Date: Thu, 3 Mar 2011 22:01:50 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/05] sysctl: change to use proc_dointvec_unsigned while
 needed
Message-ID: <20110303140150.GE2620@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change positive value sysctl case to use proc_do_intvec_unsigned handler

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 kernel/sysctl.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- linux-2.6.orig/kernel/sysctl.c	2011-03-03 11:17:39.126661201 +0800
+++ linux-2.6/kernel/sysctl.c	2011-03-03 11:19:35.159994268 +0800
@@ -1169,8 +1169,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_max_map_count,
 		.maxlen		= sizeof(sysctl_max_map_count),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #else
 	{
@@ -1178,8 +1177,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_nr_trim_pages,
 		.maxlen		= sizeof(sysctl_nr_trim_pages),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #endif
 	{
@@ -1194,16 +1192,14 @@ static struct ctl_table vm_table[] = {
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 	{
 		.procname	= "vfs_cache_pressure",
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 	{
@@ -1211,8 +1207,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #endif
 #ifdef CONFIG_NUMA
@@ -1221,8 +1216,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &zone_reclaim_mode,
 		.maxlen		= sizeof(zone_reclaim_mode),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 	{
 		.procname	= "min_unmapped_ratio",
@@ -1277,8 +1271,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &vdso_enabled,
 		.maxlen		= sizeof(vdso_enabled),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #endif
 #ifdef CONFIG_HIGHMEM
