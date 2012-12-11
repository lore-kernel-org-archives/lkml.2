Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2LKTuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:50:08 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34773 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753372Ab2LKTuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:50:06 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        johnstul@us.ibm.com, viro@zeniv.linux.org.uk, peterz@infradead.org,
        mingo@redhat.com, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH 0/4] /proc/schedstat and /proc/sched_debug fail at 4096
Date: Tue, 11 Dec 2012 13:50:01 -0600
Message-Id: <1355255405-32758-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running with 4096 cores attemping to read /proc/schedstat,
/proc/sched_debug, /proc/timer_list will fail with an ENOMEM condition.
On a sufficantly large systems the total amount of data is more then 4mb, so
it won't fit into a single buffer.  The failure can also occur on smaller
systems when memory fragmentation is high.

An solution considered but not tried for sched_stat and scheddebug would to be
create an alternative mechanism to single_open but rather then calling *_show
once it calls show once per possible cpu.  If someone feels strongly that is
the way to go I can give it a spin.

Nathan Zimmer (4):
  procfs: /proc/sched_stat fails on very very large machines.
  procfs: /proc/sched_debug fails on very very large machines.
  /proc/timer_list split timer_list_show_tickdevices
  Convert timer list to be a proper seq_file.

 kernel/sched/debug.c     |   84 +++++++++++++++++++++++++++++++++-----
 kernel/sched/stats.c     |   73 ++++++++++++++++++++++++---------
 kernel/time/timer_list.c |  102 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 209 insertions(+), 50 deletions(-)

