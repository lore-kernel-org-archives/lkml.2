Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0IWHW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 03:22:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:47632 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0IWHWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 03:22:25 -0400
Date: Thu, 23 Sep 2010 07:22:03 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4C9A9A3F.4040201@goop.org>
References: <4C9A9A3F.4040201@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing/x86: Don't use mcount in pvclock.c
Message-ID: <tip-9ecd4e1689208afe9b059a5ce1333acb2f42c4d2@git.kernel.org>
Git-Commit-ID: 9ecd4e1689208afe9b059a5ce1333acb2f42c4d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Sep 2010 07:22:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ecd4e1689208afe9b059a5ce1333acb2f42c4d2
Gitweb:     http://git.kernel.org/tip/9ecd4e1689208afe9b059a5ce1333acb2f42c4d2
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Wed, 22 Sep 2010 17:07:27 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 22 Sep 2010 23:00:50 -0400

tracing/x86: Don't use mcount in pvclock.c

When using a paravirt clock, pvclock.c can be used by sched_clock(),
which in turn is used by the tracing mechanism for timestamps,
which leads to infinite recursion.

Disable mcount/tracing for pvclock.o.

Cc: stable@kernel.org
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
LKML-Reference: <4C9A9A3F.4040201@goop.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..882bbff 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -11,6 +11,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
