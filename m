Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0IUJL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab0IUJL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:11:26 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: nhorman@tuxdriver.com, eugene@redhat.com
Cc: linux-kernel@vger.kernel.org, oleg@tv-sign.ru
Subject: [RFC PATCH] proc: making "limits" world readable
Date: Tue, 21 Sep 2010 11:10:55 +0200
Message-Id: <1285060255-15784-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'd like to have the /proc/<pid>/limits file world readable,
but I'm not sure this could cause some security issue.. thoughts?

The "limit" file was as a debug feature by following commit:
- proc: export a processes resource limits via /proc/pid
  commit d85f50d5e1aa99ab082035f94265847521819e58
  Author: Neil Horman <nhorman@tuxdriver.com>


thanks for any ideas,
jirka
---
 fs/proc/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index a1c43e7..8e4adda 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2675,7 +2675,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUSR, proc_pid_limits),
+	INF("limits",	  S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -3011,7 +3011,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUSR, proc_pid_limits),
+	INF("limits",	 S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
-- 
1.7.1

