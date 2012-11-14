Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab2KNIuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:50:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58220 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2KNIuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:50:50 -0500
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
Subject: [PATCH 0/2] change_protection(): Count the number of pages affected
Date: Wed, 14 Nov 2012 09:50:27 +0100
Message-Id: <1352883029-7885-1-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What do you guys think about this mprotect() optimization?

Thanks,

	Ingo

--
Ingo Molnar (1):
  mm: Optimize the TLB flush of sys_mprotect() and change_protection()
    users

Peter Zijlstra (1):
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

