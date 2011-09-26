Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1IZPzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:55:22 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:28926 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1IZPzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:55:21 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org
Subject: [PATCH 0/4] trace: add ability to collect call chains of non-current task.
Date: Mon, 26 Sep 2011 19:55:31 +0400
Message-Id: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without these patches, an event may only save call chain of a current
task, but some events may require call chains of non-current task.

E.g. You may want to know where and how long a task is sleeping. A time
slice is known when the task wakes up.  We send event in this moment,
but a target task isn't "current".

Usually when the system begin stuttering, it often waits a lock or an
operation for a long time. For investigation such situation you probaly
send sysrq-t and analyze backtraces, but perf may do it more effectively.

A macto __perf_task() is set task for wich a call chain will be collected.

Now this functionality is suitable for sched_stat_sleep and sched_stat_iowait.
