Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1HVNUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:20:10 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60906 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1HVNUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:20:06 -0400
From: bookjovi@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Jovi Zhang <bookjovi@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] coredump: fix wrong comments on core limits of pipe coredump case
Date: Mon, 22 Aug 2011 17:20:11 -0400
Message-Id: <1314048011-2824-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

In commit 898b374a, core limits recursive check vaule changed from 0 to 1,
but the corresponding comments was not changed correctly.

Only core limit 1 can skip dump in ispipe case, not 0.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
---
 fs/exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..da60703 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2163,7 +2163,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			 * we're not writing to the file system, but we use
 			 * cprm.limit of 1 here as a speacial value. Any
 			 * non-1 limit gets set to RLIM_INFINITY below, but
-			 * a limit of 0 skips the dump.  This is a consistent
+			 * a limit of 1 skips the dump.  This is a consistent
 			 * way to catch recursive crashes.  We can still crash
 			 * if the core_pattern binary sets RLIM_CORE =  !1
 			 * but it runs as root, and can do lots of stupid things
-- 
1.7.2.3

