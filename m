Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2KHPNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:13:25 -0500
Received: from relay2.sgi.com ([192.48.179.30]:38069 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751930Ab2KHPNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:13:22 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC v2 0/2] /proc/sched_stat and /proc/sched_debug fail at 4096
Date: Thu,  8 Nov 2012 09:13:18 -0600
Message-Id: <1352387600-19389-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running with 4096 cores attemping to read /proc/sched_stat and
/proc/sched_debug will fail with an ENOMEM condition.
On a sufficantly large systems the total amount of data is more then 4mb, so
it won't fit into a single buffer.

/proc/timer_list also fails in a similar way.  However timer_list has two 
seperate per online cpu loops which will require a bit more thought.

Nathan Zimmer (2):
  procfs: /proc/sched_stat fails on very very large machines.
  procfs: /proc/sched_debug fails on very very large machines.

 kernel/sched/debug.c |   73 +++++++++++++++++++++---
 kernel/sched/stats.c |  154 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 159 insertions(+), 68 deletions(-)

CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
CC: Al Viro <viro@zeniv.linux.org.uk>

