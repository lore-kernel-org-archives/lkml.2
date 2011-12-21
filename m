Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1LUTJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:09:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab1LUTJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:09:25 -0500
Date: Wed, 21 Dec 2011 14:09:01 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        mingo@elte.hu, davem@davemloft.net, ddaney.cavm@gmail.com,
        pjt@google.com, rth@redhat.com, linux-kernel@vger.kernel.org
Message-Id: <cover.1324493360.git.jbaron@redhat.com>
Subject: [PATCH 0/4][RFC] jump label: introduce default true branch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I've introduced a new static_branch_def_true() construct, such that the straight
line path is the true branch, and we patch a jump to get to the false branch.
In order to make jump_label_inc()/dec() work as 'make true'/'make false' with
counting, I've had to update some of the core jump label code. This patchset also
introduces: JUMP_LABEL_INIT_TRUE/FALSE, so that keys should be initialized as:

struct jump_label_key true_key = JUMP_LABEL_INIT_TRUE;

           or

struct jump_label_key false_key = JUMP_LABEL_INIT_FALSE;

I think this patch series should address the issues that came up with sched_feat()
implementation.

Thanks,

-Jason

Jason Baron (4):
  jump label: Introduce default true branch + API update
  perf: Make use of updated jump label API.
  tracepoints: update to use new jump label API.
  sched: Make use of new jump label API.

 include/linux/jump_label.h |   77 ++++++++++++++++++++++++++++++++++++-------
 include/linux/perf_event.h |    6 ++--
 include/linux/tracepoint.h |    4 +-
 kernel/jump_label.c        |   66 +++++++++++++++++++++++++------------
 kernel/sched/core.c        |   12 +++---
 kernel/sched/fair.c        |    2 +-
 kernel/sched/sched.h       |   11 +------
 kernel/tracepoint.c        |   12 +++---
 8 files changed, 128 insertions(+), 62 deletions(-)

-- 
1.7.7.3

