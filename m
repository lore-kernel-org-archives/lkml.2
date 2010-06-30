Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0F3J0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:26:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50571 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0F3J0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:26:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [mmotm 0611][PATCH 00/11] various OOM bugfixes v3
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:25:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is updated series for various OOM fixes.
Almost fixes are trivial. 

One big improvement is Luis's dying task priority boost patch.
This is necessary for RT folks.


  oom: don't try to kill oom_unkillable child
  oom: oom_kill_process() doesn't select kthread child
  oom: make oom_unkillable_task() helper function
  oom: oom_kill_process() need to check p is unkillable
  oom: /proc/<pid>/oom_score treat kernel thread honestly
  oom: kill duplicate OOM_DISABLE check
  oom: move OOM_DISABLE check from oom_kill_task to out_of_memory()
  oom: cleanup has_intersects_mems_allowed()
  oom: remove child->mm check from oom_kill_process()
  oom: give the dying task a higher priority
  oom: multi threaded process coredump don't make deadlock

 fs/proc/base.c |    5 ++-
 mm/oom_kill.c  |  100 +++++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 73 insertions(+), 32 deletions(-)

