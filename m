Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2LSHCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:02:46 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53469 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2LSHCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:02:42 -0500
X-Greylist: delayed 159148 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 02:02:41 EST
X-AuditID: 85900ec0-d4a78b900000152f-40-50d1668fc0c4
Subject: [PATCH v3 -tip 0/4] tracing: make a snapshot feature available from
 userspace
To: rostedt@goodmis.org
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 19 Dec 2012 16:02:18 +0900
Message-ID: <20121219070218.31200.64647.stgit@liselsia>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven,

Thank you for your review.
I applied your review comments.

These patches depend on the next patch.

tracing: Add a resize function to make one buffer equivalent to another buffer
http://lkml.kernel.org/r/20121017025616.2627.91226.stgit@falsita

v2->v3:
 [1/4] tracing: add checks if tr->buffer is NULL in tracing_reset{_online_cpus}
        - (new patch)
 [2/4] tracing: replace static old_tracer with strcmp
        - (new patch)
 [3/4] tracing: make a snapshot feature available from userspace
        - changed snapshot file I/F (removed "snapshot_allocate")
        - changed CONFIG_TRACER_SNAPSHOT's location and description
        - changed an integer flag of __tracing_open() to bool
        - switched to use seq_read() directly for reading snapshot
 [4/4] tracing: add description of snapshot to Documentation/trace/ftrace.txt
        - updated documentation of the snapshot

ToDo:
 - adding "trace_snapshot" kernel parameter to allocate spare buffer on boot. 

(v1: https://lkml.org/lkml/2012/10/2/67)
(v2: https://lkml.org/lkml/2012/10/16/585)

---

Hiraku Toyooka (4):
      tracing: add checks if tr->buffer is NULL in tracing_reset{_online_cpus}
      tracing: replace static old_tracer with strcmp
      tracing: make a snapshot feature available from userspace
      tracing: add description of snapshot to Documentation/trace/ftrace.txt


 Documentation/trace/ftrace.txt |   83 +++++++++++++++++++++
 include/linux/ftrace_event.h   |    3 +
 kernel/trace/Kconfig           |   10 +++
 kernel/trace/trace.c           |  158 ++++++++++++++++++++++++++++++++++------
 kernel/trace/trace.h           |    1 
 5 files changed, 231 insertions(+), 24 deletions(-)

-- 
Hiraku TOYOOKA
Linux Technology Center
Yokohama Research Laboratory
Hitachi Ltd.
