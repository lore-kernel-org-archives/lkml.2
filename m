Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab2CFIiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:38:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38842 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab2CFIiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:38:23 -0500
X-IronPort-AV: E=Sophos;i="4.73,539,1325433600"; 
   d="scan'208";a="4463835"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        --@tang.cn.fujitsu.com, 1.7.4.4@tang.cn.fujitsu.com
Subject: [RFC PATCH 0/6 paul/rcu/srcu] srcu: implement call_srcu()
Date: Tue, 6 Mar 2012 16:42:33 +0800
Message-Id: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20120221172442.GG2375@linux.vnet.ibm.com>
References: <20120221172442.GG2375@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 16:36:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 16:36:25,
	Serialize complete at 2012-03-06 16:36:25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1~4 are for preparing.
Patch 1,2 can be merge now, maybe patch 3 can be merge now.

Patch 5 is the draft per-cpu state machine call_srcu() implementation
	it will be split before merge.

Patch 6 is for srcu torture test.

Lai Jiangshan (6):
  remove unused srcu_barrier()
  Don't touch the snap in srcu_readers_active()
  use "int trycount" instead of "bool expedited"
  remove flip_idx_and_wait()
  implement call_srcu()
  add srcu torture test

 include/linux/srcu.h |   49 +++++-
 kernel/rcutorture.c  |   68 ++++++++-
 kernel/srcu.c        |  421 +++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 454 insertions(+), 84 deletions(-)

-- 
1.7.4.4

