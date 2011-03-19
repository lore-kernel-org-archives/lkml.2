Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1CSPyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:54:32 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:11960 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab1CSPy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:54:29 -0400
Message-Id: <201103191554.p2JFsQ9N010993@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 19 Mar 2011 11:47:53 -0400
Subject: [PATCH] asm-generic: support clock_adjtime() in <asm-generic/unistd.h>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
X-OriginalArrivalTime: 19 Mar 2011 15:54:28.0433 (UTC) FILETIME=[EDA8E410:01CBE64D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A syscall was added without being added to asm-generic, which
makes tile (and presumably score and unicore32) break.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 include/asm-generic/unistd.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 57af033..d94f447 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -650,9 +650,11 @@ __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 __SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
 #define __NR_open_by_handle_at		265
 __SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
+#define __NR_clock_adjtime 266
+__SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
 
 #undef __NR_syscalls
-#define __NR_syscalls 266
+#define __NR_syscalls 267
 
 /*
  * All syscalls below here should go away really,
-- 
1.6.5.2

