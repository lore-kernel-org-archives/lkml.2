Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0DIGV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:21:29 -0400
Received: from ozlabs.org ([203.10.76.45]:46425 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab0DIGVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:21:23 -0400
To: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Michael Neuling <mikey@neuling.org>
Date: Fri, 09 Apr 2010 16:21:18 +1000
Subject: [PATCH 0/5] sched: asymmetrical packing for POWER7 SMT4
Message-Id: <1270794078.794237.347827867455.qpush@pale>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements asymmetric SMT packing which ensures
consistently good performance on POWER7.  

I'm no scheduler expert so these probably need some review.  It works
for my simple test case on a POWER7 with SMT4.  I can now run a number
of CPU bound processes and they are pulled down to lower threads
giving the best performance consistently. 

Suresh: some of this touches code you changed recently, so you may
want to test in your environment.

The 1st patch is a fix for SMT4 in general.
The 2nd adds actual the asymmetrical packing infrastructure.  
The 3rd adds the powerpc specific hooks for POWER7.
The 4th and 5th are fixes required for packing to work.
