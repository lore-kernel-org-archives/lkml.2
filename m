Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1GHVPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:15:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:52422 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1GHVPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:15:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Bernecky <bernecky@snakeisland.com>
Subject: PAPI vs. perf stat
Date: Fri, 8 Jul 2011 21:13:49 +0000 (UTC)
Message-ID: <loom.20110708T224248-262@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 173.33.227.187 (Mozilla/5.0 (X11; U; Linux x86_64; en-CA; rv:1.9.2.13) Gecko/20101206 Ubuntu/10.10 (maverick) Firefox/3.6.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is actually three questions about perf stat:

1. I have been using PAPI and PAPIEX with excellent results, in the sense
that I obtained extremely reproducible instruction counts, varying by only
a few hundred instructions over billions of instructions executed.
This was on an Opteron 165.

I have been forced to move to a new platform and a newer version of
Ubuntu, and decided to try out "perf stat" and friends, rather than
going through the tedious task of kernel mods for PAPI. 

What I now observe (albeit on a new CPU/MB -- AMD Phenom 1075T)
with perf stat is disturbing: Instruction counts vary by several
percent. E.g., repeated execution of the same binary, foo, gives me:

perf stat foo

    71156657  instructions
    71628306  instructions 
    71613890  instructions    
    71638216  instructions
    71731479  instructions
    71564788  instructions

This is on a lightly loaded system with web browser, email, and
other tasks running, which is the same environment that I was
using with PAPI.

I am curious as to why it is that "perf" does not have the same
degree of precision as PAPI.

[From looking at the PAPI kernel mods, it seems that HMI counters
are saved at task dispatch, then sampled again at interrupt time,
and the differences added to task(process?)-specific fields.
Hence, the only variance in instruction counts (aside from
page faults, etc.) arise from interrupts happening during
task execution. Several kernel instructions are executed between the
time of interrupt and counter sampling, and similarly at task
dispatch time. ]

Is there a way to improve the precision of "perf" measurements?

2. The Opteron 165 under PAPI shows PAPI_VEC_INS (vector instruction
counts) as well as PAPI_TOT_INT (total instruction count). 
"perf list" (on the Phenom 1075T) does show 
"instructions" but I do not see an entry for vector instruction
counts. Any ideas what may be going on here?

3. I have an on-going process running, and would like to make
   automated measurements of HMI data at desired 
   (not periodic) intervals,
   from another shell. is there a way to do this with perf?
   I see that "perf stat  -p PIDNUMBER" almost works, but
   it requires that I manually hit CTRL-C to terminate the
   sample. 

Thanks.
Robert











