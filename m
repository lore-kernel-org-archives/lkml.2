Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab1EKU7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:59:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45531 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab1EKU73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:59:29 -0400
Date: Wed, 11 May 2011 13:59:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/3] Fixes for lockdep and out-of-tree-module
 build problem
Message-ID: <20110511205915.GA1731@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

These patches fix some bugs found in -tip testing:

1.	Avoid a build error for some compiler arguments for out-of-tree
	modules.
2.	Add a generic atomic_or().
3.	Use atomic_or() to avoid a lockdep splat.

Following this will be specific atomic_or() implementations for a couple
of architectures.

							Thanx, Paul

------------------------------------------------------------------------

 include/linux/atomic.h   |   13 +++++++++++++
 include/linux/rcupdate.h |    5 +++--
 kernel/rcutree.c         |   13 +++++--------
 kernel/rcutree.h         |    4 +++-
 4 files changed, 24 insertions(+), 11 deletions(-)
