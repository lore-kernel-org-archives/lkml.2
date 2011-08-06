Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab1HFBX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 21:23:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1HFBXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 21:23:55 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=1LKPEfZx0jAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=tcfT4IWkh8xXK83aTE8A:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110806011102.721109343@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Aug 2011 21:11:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 0/4 v2] [GIT PULL][v3.2] x86: Consolidate 32 and 64 bit thread_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Repost with removing the first patch:
   "x86: Do not differentiate between x86_64 and i386 with init_per_cpu"
  as requested by Brian Gerst
]

Thomas, Ingo, and Peter(s),

On IRC, Peter Zijlstra mentioned to me the difference between
32bit and 64bit x86 on how thread_info is handled with interrupts.
I mentioned that they should be more the same, and Peter agreed.

I decided to do so, and ended up with the following patches.
I marked this for v3.2 as it should be tested a bit before going into
mainline. I've ran several configs on it, but more testing should be done.

Some of the patches are clean ups, but the main ones are patch 3 and 4
that do the work to convert 32bit of thread_info to be more like
the 64bit.

-- Steve


Please pull the latest tip/x86/thread_info tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/x86/thread_info

Head SHA1: 326c03f828beaff087aa6bd9e741cb4d4915a685


Steven Rostedt (4):
      x86: Nuke the supervisor_stack field in i386 thread_info
      x86: Remove previous_esp from i386 thread_info structure
      x86: Keep thread_info on thread stack in x86_32
      x86: Clean up dumpstack_64.c code

----
 arch/x86/include/asm/processor.h   |    9 +++
 arch/x86/include/asm/thread_info.h |   56 +++--------------
 arch/x86/kernel/cpu/common.c       |    8 +-
 arch/x86/kernel/dumpstack_32.c     |   44 ++++++++++++-
 arch/x86/kernel/dumpstack_64.c     |  121 +++++++++++++++++++++++++-----------
 arch/x86/kernel/irq_32.c           |   86 +++++++++++---------------
 arch/x86/kernel/process_32.c       |    4 +
 arch/x86/kernel/smpboot.c          |    2 +-
 8 files changed, 189 insertions(+), 141 deletions(-)
