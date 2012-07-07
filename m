Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2GGFso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 01:48:44 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56101 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2GGFsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 01:48:43 -0400
X-AuditID: 9c93016f-b7c7eae0000025c5-10-4ff7cdb9a94d
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [Question] sched/rt_mutex: re-enqueue_task on rt_mutex_setprio()
Date: Sat, 07 Jul 2012 14:44:09 +0900
Message-ID: <87zk7cgm6u.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question on the code below:

void rt_mutex_setprio(struct task_struct *p, int prio)
{
        ...
	if (on_rq)
		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);

When enqueueing @p with new @prio, it seems put @p at the head of a
rq if appropriate. I guess it's the case of boosting @p with higher
priority, right? So Should the conditional be a reverse form (provided
that less number means higher priority)? Please shed some light on me.

Thanks,
Namhyung

