Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2KFVCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:02:23 -0500
Received: from relay1.sgi.com ([192.48.179.29]:39284 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab2KFVCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:02:22 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [RFC 0/2] /proc/sched_stat and /proc/sched_debug fail at 4096 
Date: Tue,  6 Nov 2012 15:02:19 -0600
Message-Id: <1352235741-26478-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running with 4096 cores attemping to read /proc/sched_stat and
/proc/sched_debug will fail with an ENOMEM condition.
On a sufficantly large systems the total amount of data is more then 4mb, so
it won't fit into a single buffer. 

Nathan Zimmer (2):
  procfs: /proc/sched_stat fails on very very large machines.
  procfs: /proc/sched_debug fails on very very large machines.

 kernel/sched/debug.c |  101 +++++++++++++++++++++++++-----------
 kernel/sched/stats.c |  139 +++++++++++++++++++++++++++++---------------------
 2 files changed, 152 insertions(+), 88 deletions(-)

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org

