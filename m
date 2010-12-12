Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab0LLRmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 12:42:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:60520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab0LLRmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 12:42:20 -0500
Date: Sun, 12 Dec 2010 17:41:43 GMT
From: tip-bot for Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, eric.dumazet@gmail.com,
        penberg@cs.helsinki.fi, cl@linux.com, tj@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, mathieu.desnoyers@efficios.com,
        penberg@cs.helsinki.fi, cl@linux.com, tj@kernel.org,
        tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.00.1011301404490.4039@router.home>
References: <alpine.DEB.2.00.1011301404490.4039@router.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timers: Use this_cpu_read
Message-ID: <tip-7496351ad87e61e96b49dd7b43c6534e3401f566@git.kernel.org>
Git-Commit-ID: 7496351ad87e61e96b49dd7b43c6534e3401f566
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 17:41:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7496351ad87e61e96b49dd7b43c6534e3401f566
Gitweb:     http://git.kernel.org/tip/7496351ad87e61e96b49dd7b43c6534e3401f566
Author:     Christoph Lameter <cl@linux.com>
AuthorDate: Tue, 30 Nov 2010 14:05:53 -0600
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 12 Dec 2010 18:38:09 +0100

timers: Use this_cpu_read

Eric asked for this.

[tglx: Because it generates faster code according to Erics ]

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
LKML-Reference: <alpine.DEB.2.00.1011301404490.4039@router.home>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/timer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 483e54b..beb97fd 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1227,7 +1227,7 @@ static unsigned long cmp_next_hrtimer_event(unsigned long now,
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
-	struct tvec_base *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
 	unsigned long expires;
 
 	spin_lock(&base->lock);
@@ -1267,7 +1267,7 @@ void update_process_times(int user_tick)
  */
 static void run_timer_softirq(struct softirq_action *h)
 {
-	struct tvec_base *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
 
 	hrtimer_run_pending();
 
