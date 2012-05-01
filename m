Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2EAS2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:28:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:37665 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab2EAS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:28:38 -0400
Message-Id: <20120501181430.007891123@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 01 May 2012 20:14:30 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, vatsa@in.ibm.com,
        suresh.b.siddha@intel.com, efault@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/5] various sched and numa bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first two patches change how the load-balancer traverses the sched_domain
tree. Currently we go one level up on the first non-idle cpu, change that to
be the least loaded cpu. The second adds a little serialization to the
sched_domain traversal, so that no two cpus of the same group go up.

Paul, can you run these through linsched to see if they make anything worse?
They make conceptual sense, but that never says much these days :/

The following two patches extend NUMA emulation and were used to test the last
patch.

The last patch does a complete re-implementation of CONFIG_NUMA support for
the scheduler and should get us a topology that matches the NUMA interconnects
as opposed to the semi-random stuff we have now. The code assumes a number of
things which I hope are true, but lacking any interesting hardware what do I
know... Its tested by using the node_distance() table from an quad-socket AMD
Magny-Cours, which is a non-fully-connected system -- see 3/5.



