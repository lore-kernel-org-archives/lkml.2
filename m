Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1D2PGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:06:12 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:47002 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1D2PGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:06:11 -0400
Date: Fri, 29 Apr 2011 11:04:46 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: torvalds@linux-foundation.org
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>
Subject: re-enable Nehalem raw Offcore-Events support
Message-ID: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus

can you revert the commit b52c55c6a25e4515b5e075a989ff346fc251ed09

This removed functionality from perf_events that allowed raw event access 
for OFFCORE_EVENTS type events on Nehalem and Westmere cpus.

To be fair, this is not technically a regression as the feature was only 
(finally!) added in the 2.6.39 merge window.  However this is a useful 
feature and many tools (including the PAPI performance counter library 
that I work on) had added support for it in anticipation of the 2.6.39 
release.

Ingo's reasons for removing the feature seem to boil down to
  1.  "perf" doesn't use the functionality, and any other userspace
      program that uses the perf_events syscalls don't matter
  2.  Users are too stupid to use the raw functionality properly;
      we should only allow a kernel-developer-approved small subset
      of the features provided by the CPU as described in the intel
      developers manuals.

#2 seems like a gross misinterpretation of the whole "Linux gives you 
enough rope to shoot yourself in the foot" policy from days passed, but 
maybe things have moved on.

Thanks,

Vince
vweaver1@eecs.utk.edu
