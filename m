Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab1INNjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:39:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:53136 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1INNjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:39:53 -0400
Message-Id: <20110914133034.687048806@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 14 Sep 2011 15:30:34 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/3] delayed wakeup list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set provides the infrastructure to delay/batch task wakeups.

This is useful for locking primitives that can effect multiple wakeups
per operation and want to avoid lock internal lock contention by
delaying the wakeups until we've released the lock internal locks.

Patch 2 converts futexes
Patch 3 converts sysv sems, and is broken

[ I've been staring at patch 3 way too long, so I thought I'd post it just
  to get a few more eyes on it.. ]

Alternatively it can be used to avoid issuing multiple wakeups, and
thus save a few cycles, in packet processing. Queue all target tasks
and wakeup once you've processed all packets. That way you avoid
waking the target task multiple times if there were multiple packets
for the same task.

No actual such usage yet, but ISTR talking to some net folks a long while back
about this, is there still interest, Dave, Eric?

