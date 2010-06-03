Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0FCFso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:48:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53060 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab0FCFsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:48:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [mmotm 0521][PATCH 0/12] various OOM fixes for 2.6.35
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100603135106.7247.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 14:48:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch series is collection of various OOM bugfixes. I think
all of patches can send to 2.6.35.
Recently, David Rientjes and Luis Claudio R. Goncalves posted other
various imporovement. I'll collect such 2.6.36 items and I plan to 
push -mm at next week.

patch lists
-------------------------------------
oom: select_bad_process: check PF_KTHREAD instead of !mm to skip kthreads
oom: introduce find_lock_task_mm() to fix !mm false positives
oom: the points calculation of child processes must use find_lock_task_mm() too
oom: __oom_kill_task() must use find_lock_task_mm() too
oom: make oom_unkillable() helper function
oom: remove warning for in mm-less task __oom_kill_process()
oom: Fix child process iteration properly
oom: dump_tasks() use find_lock_task_mm() too
oom: remove PF_EXITING check completely
oom: sacrifice child with highest badness score for parent
oom: remove special handling for pagefault ooms
oom: give current access to memory reserves if it has been killed

diffstat
------------
 mm/oom_kill.c |  303 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 162 insertions(+), 141 deletions(-)



Changes since last post
-------------------------
  - Drop Luis's "give the dying task a higher priority" patch
  - Add "remove PF_EXITING check completely" patch
  - Drop Oleg's "oom: select_bad_process: PF_EXITING check should 
    take ->mm into account" because conflict against "remove 
    PF_EXITING check completely"
  - Add "oom: sacrifice child with highest badness score for parent"
  - Add "oom: remove special handling for pagefault ooms"
  - Add "oom: give current access to memory reserves if it has been killed"




