Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2KNJTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:19:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48779 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2KNJTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:19:08 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 0/3, v2] mprotect() and working set sampling optimizations
Date: Wed, 14 Nov 2012 10:18:48 +0100
Message-Id: <1352884731-20024-1-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, people suggested to split out the change_protection() modification
into a third patch.

This series implements an mprotect() optimization that also
helps improve the quality of working set scanning:

  - working set scanning gets faster

  - we can scan with a touched-page rate, instead of with a
    virtual-memory proportional rate (within limits).

This is already part of numa/core, but wanted to send it out
separately as well, to get specific feedback for the mprotect()
bits.

Thanks,

	Ingo

---
Ingo Molnar (1):
  mm: Optimize the TLB flush of sys_mprotect() and change_protection()
    users

Peter Zijlstra (2):
  mm: Count the number of pages affected in change_protection()
  sched, numa, mm: Count WS scanning against present PTEs, not virtual
    memory ranges

 include/linux/hugetlb.h |  8 ++++++--
 include/linux/mm.h      |  6 +++---
 kernel/sched/fair.c     | 37 +++++++++++++++++++++----------------
 mm/hugetlb.c            | 10 ++++++++--
 mm/mprotect.c           | 46 ++++++++++++++++++++++++++++++++++------------
 5 files changed, 72 insertions(+), 35 deletions(-)

-- 
1.7.11.7

