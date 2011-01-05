Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1AEV1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:27:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:60435 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab1AEV1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:27:34 -0500
Date: Wed, 5 Jan 2011 21:24:45 GMT
From: tip-bot for Jean Pihet <j-pihet@ti.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, arjan@linux.intel.com,
        j-pihet@ti.com, pavel@ucw.cz, rostedt@goodmis.org, tglx@linutronix.de,
        trenn@suse.de, rjw@sisk.pl, mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        a.p.zijlstra@chello.nl, j-pihet@ti.com, pavel@ucw.cz,
        rostedt@goodmis.org, trenn@suse.de, tglx@linutronix.de, rjw@sisk.pl,
        len.brown@intel.com, mingo@elte.hu
In-Reply-To: <1294253342-29056-2-git-send-email-j-pihet@ti.com>
References: <1294253342-29056-2-git-send-email-j-pihet@ti.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add calls to suspend trace point
Message-ID: <tip-938cfed18bec2c7361f37efc954712a7cc42c353@git.kernel.org>
Git-Commit-ID: 938cfed18bec2c7361f37efc954712a7cc42c353
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 Jan 2011 21:24:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  938cfed18bec2c7361f37efc954712a7cc42c353
Gitweb:     http://git.kernel.org/tip/938cfed18bec2c7361f37efc954712a7cc42c353
Author:     Jean Pihet <j-pihet@ti.com>
AuthorDate: Wed, 5 Jan 2011 19:49:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Jan 2011 21:25:28 +0100

perf: Add calls to suspend trace point

Uses the machine_suspend trace point, called from the
generic kernel suspend_devices_and_enter function.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@linux.intel.com>
CC: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-pm@lists.linux-foundation.org
LKML-Reference: <1294253342-29056-2-git-send-email-j-pihet@ti.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/power/suspend.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index ecf7705..031d5e3 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <trace/events/power.h>
 
 #include "power.h"
 
@@ -201,6 +202,7 @@ int suspend_devices_and_enter(suspend_state_t state)
 	if (!suspend_ops)
 		return -ENOSYS;
 
+	trace_machine_suspend(state);
 	if (suspend_ops->begin) {
 		error = suspend_ops->begin(state);
 		if (error)
@@ -229,6 +231,7 @@ int suspend_devices_and_enter(suspend_state_t state)
  Close:
 	if (suspend_ops->end)
 		suspend_ops->end();
+	trace_machine_suspend(PWR_EVENT_EXIT);
 	return error;
 
  Recover_platform:
