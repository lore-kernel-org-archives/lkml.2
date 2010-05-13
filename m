Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0EMG6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:58:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:45678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab0EMG6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:58:32 -0400
Date: Thu, 13 May 2010 06:57:58 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, gorcunov@gmail.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, gorcunov@gmail.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
References: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] watchdog: Export touch_softlockup_watchdog
Message-ID: <tip-0167c781907fcdc3e1f144ef5ce31d402c91eb94@git.kernel.org>
Git-Commit-ID: 0167c781907fcdc3e1f144ef5ce31d402c91eb94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 06:57:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0167c781907fcdc3e1f144ef5ce31d402c91eb94
Gitweb:     http://git.kernel.org/tip/0167c781907fcdc3e1f144ef5ce31d402c91eb94
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 13 May 2010 08:53:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 May 2010 08:53:33 +0200

watchdog: Export touch_softlockup_watchdog

There are modules that rely on it:

  ERROR: "touch_softlockup_watchdog" [drivers/video/nvidia/nvidiafb.ko] undefined!

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 57b8e2c..be5e74e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -124,6 +124,7 @@ void touch_softlockup_watchdog(void)
 {
 	__get_cpu_var(watchdog_touch_ts) = 0;
 }
+EXPORT_SYMBOL(touch_softlockup_watchdog);
 
 void touch_all_softlockup_watchdogs(void)
 {
