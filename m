Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0GIIlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:41:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0GIIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:39:59 -0400
Message-Id: <20100709082117.631541128@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 09 Jul 2010 10:21:17 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 00/13] perf pmu interface changes -v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 5 patches are fixes to the existing code and should probably
end up in .35, Dave has his sparc64 fix already queued I think, Paulus
could you take the FSL fixes?

The rest of these patches prepare the perf code for multiple pmus (no
user interface yet, Lin Ming is working on that). These patches remove
all weak functions and rework the struct pmu interface.

The patches are boot tested on x86_64 and compile tested on: powerpc, ppc-fsl,
sparc and arm and SH (by courtesy of Matt Fleming).

X86 -- appears to be fully functional.
FSL -- should, after the initial few fixes, at least compile again.
ARM -- is known to have grown some issues, Will was looking into that.
SH  -- has some pre-existing bugs, but hopefully Paulus' last observation about
       the missing -ENOENT in the pmu::event_init method cures the newly 
       introduced troubles.
PPC -- will be looked at by Paulus
SPARC -- Dave, when you have a moment.. ;-)

Once those are sorted, and I'm back from vacation I'll start on the previously
mentioned per pmu context support.

Patches also available in git format for easy testing (tip/master + patches):

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git perf-pmu

HEAD should be ac9fd39c1

