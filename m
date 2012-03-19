Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab2CSIHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:07:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab2CSIHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:07:16 -0400
X-IronPort-AV: E=Sophos;i="4.73,611,1325433600"; 
   d="scan'208";a="4567341"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 0/4 V2] rcu: implement call_srcu()
Date: Mon, 19 Mar 2012 16:12:10 +0800
Message-Id: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-19 16:05:07,
	Serialize complete at 2012-03-19 16:05:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are the second version of the
"[RFC PATCH 5/5 single-thread-version] implement per-domain single-thread state machine call_srcu()"

These patches are on the top of paulmck/linux-rcu.git/rcu/srcu
(3c8975b51a7bed5dd993c5c4eab245a121bdc728)

I noticed this branch has patch "implement Peter's checking algorithm"
applied, so the pathes are rebased on 3c8975b51 and are tested based on
Peter's algorithm.

Except the rebasing, only 2 changes:
	Refactor the srcu_advance_batches() as Peter's suggestion.
	Impletement synchronize_srcu() with fast path awared.
	- old version just calls call_srcu() and waits.
	- Ftrace shows new synchronize_srcu() cost 6us when fast path.

Lai Jiangshan (4):
  fix for peter's algorithm
  use "int trycount" instead of "bool expedited"
  add call_srcu()
  add srcu torture

 include/linux/srcu.h |   25 ++++-
 kernel/rcutorture.c  |   44 ++++++-
 kernel/srcu.c        |  322 +++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 314 insertions(+), 77 deletions(-)

-- 
1.7.4.4

