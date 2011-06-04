Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1FDLG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 07:06:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:47949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447Ab1FDLG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 07:06:27 -0400
Date: Sat, 4 Jun 2011 11:06:06 GMT
From: tip-bot for Vince Weaver <vweaver1@eecs.utk.edu>
Message-ID: <tip-aa4a221875873d2a1f9656cb7fd7e545e952b4fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, dsahern@gmail.com, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, dsahern@gmail.com, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1106031751170.29381@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106031751170.29381@cl320.eecs.utk.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Comment /proc/sys/kernel/perf_event_paranoid to be part of user ABI
Git-Commit-ID: aa4a221875873d2a1f9656cb7fd7e545e952b4fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 04 Jun 2011 11:06:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa4a221875873d2a1f9656cb7fd7e545e952b4fa
Gitweb:     http://git.kernel.org/tip/aa4a221875873d2a1f9656cb7fd7e545e952b4fa
Author:     Vince Weaver <vweaver1@eecs.utk.edu>
AuthorDate: Fri, 3 Jun 2011 17:54:40 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jun 2011 12:22:04 +0200

perf: Comment /proc/sys/kernel/perf_event_paranoid to be part of user ABI

Turns out that distro packages use this file as an indicator of
the perf event subsystem - this is easier to check for from scripts
than the existence of the system call.

This is easy enough to keep around for the kernel, so add a
comment to make sure it stays so.

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
Cc: acme@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1106031751170.29381@cl320.eecs.utk.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sysctl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4fc9244..f175d98 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -938,6 +938,12 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 #ifdef CONFIG_PERF_EVENTS
+	/*
+	 * User-space scripts rely on the existence of this file
+	 * as a feature check for perf_events being enabled.
+	 *
+	 * So it's an ABI, do not remove!
+	 */
 	{
 		.procname	= "perf_event_paranoid",
 		.data		= &sysctl_perf_event_paranoid,
