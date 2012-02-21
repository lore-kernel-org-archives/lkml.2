Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2BUUDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:03:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab2BUUDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:03:01 -0500
Date: Tue, 21 Feb 2012 15:02:49 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1329851692.git.jbaron@redhat.com>
Subject: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups + docs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Renames 'static_branch()' -> very_unlikely(), hopefully, to be more intuitive
as to what jump labels is about. I'm also introducing 'very_likely()', as
the analogue to very_unlikely(). Patch is against the -tip perf branch.

Thanks,

-Jason

Jason Baron (10):
  jump label: Add a WARN() if jump label key count goes negative
  jump label: fix compiler warning
  jump label: introduce very_unlikely()
  jump label: introduce very_likely()
  perf: update to use very_unlikely()
  tracepoints: update to use very_unlikely()
  sched: update to use very_[un]likely()
  kvm: update to use very_unlikely()
  net: update to use very_unlikely()
  jump label: Add docs better explaining the whole jump label mechanism

 Documentation/jump-label.txt |  258 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu_audit.c     |    2 +-
 include/linux/jump_label.h   |   99 +++++++++++++---
 include/linux/netfilter.h    |    2 +-
 include/linux/perf_event.h   |    6 +-
 include/linux/tracepoint.h   |    4 +-
 include/net/sock.h           |    2 +-
 kernel/jump_label.c          |   79 ++++++++-----
 kernel/sched/core.c          |   12 +-
 kernel/sched/fair.c          |    2 +-
 kernel/sched/sched.h         |    4 +-
 kernel/tracepoint.c          |   12 +-
 net/core/dev.c               |    8 +-
 13 files changed, 416 insertions(+), 74 deletions(-)
 create mode 100644 Documentation/jump-label.txt

-- 
1.7.7.5

