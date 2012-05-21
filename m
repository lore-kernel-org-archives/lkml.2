Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2EUPqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:46:17 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:42919 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2EUPqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:46:15 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 0/2] RFC: readd fair sleepers for server systems
Date: Mon, 21 May 2012 17:45:35 +0200
Message-Id: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.10.2
x-cbid: 12052115-1948-0000-0000-000001DC50E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

our performance team found a performance degradation with a recent
distribution update in regard to fair sleepers (or the lack of fair
sleepers). On s390 we used to run with fair sleepers disabled.

We see the performance degradation with our network benchmark and fair
sleepers enabled, the largest hit is on virtual connections:

VM guest Hipersockets 
   Throughput degrades up to 18% 
   CPU load/cost increase up to 17%
VM stream 
   Throughput degrades up to 15% 
   CPU load/cost increase up to 22%
LPAR Hipersockets
   Throughput degrades up to 27% 
   CPU load/cost increase up to 20%

Real world workloads are also affected, e.g. we see degrations with oltp
database workloads. Christian has the numbers if needed.
The only workload on s390 with a performance benefit with fair sleepers
enabled are some J2EE workloads, but only in the <2% area.

In short, we want the fair sleepers tunable back. I understand that on
x86 we want to avoid the cost of a branch on the hot path in place_entity,
therefore add a compile time config option for the fair sleeper control.

blue skies,
  Martin

Martin Schwidefsky (2):
  sched: readd FAIR_SLEEPERS feature
  sched: enable FAIR_SLEEPERS for s390

 arch/s390/Kconfig       |    1 +
 init/Kconfig            |    3 +++
 kernel/sched/fair.c     |   14 +++++++++++++-
 kernel/sched/features.h |    9 +++++++++
 4 files changed, 26 insertions(+), 1 deletion(-)

-- 
1.7.10.2

