Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1AUUhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:37:05 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:54869 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1AUUhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:37:04 -0500
Message-Id: <20110121203630.725922272@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 21 Jan 2011 15:36:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Richard Mortimer <richm@oldelvet.org.uk>, ben@decadent.org.uk,
        sparclinux@vger.kernel.org
Subject: [patch 0/3] Fix alignment of custom sections made from structures (v3)
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Fri, 21 Jan 2011 20:36:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is a patchset that fixes the Ftrace-induced crash experienced on sparc64
discussed in the following thread: https://lkml.org/lkml/2011/1/16/2

The third patch changes the Tracepoints to use the more compact alignment scheme
proposed here, even though their alignment on 32-byte works fine. This third
patch is therefore not a fix per se.

The patchset is based on 2.6.37. Hopefully there are not too many things to
update for the current -git.

Changelog since v2: drop the "packed" attribute, because it caused unaligned 
acceses on sparc64 by dropping the padding between consecutive "int" and 
"pointer"/"long" fields.

Comments are welcome,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
