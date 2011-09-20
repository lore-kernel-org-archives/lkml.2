Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1ITCUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 22:20:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:45882 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab1ITCUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 22:20:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,408,1312182000"; 
   d="scan'208";a="53399851"
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for this_cpu_read/write()
References: <20110919212040.745370781@goodmis.org>
Date: Mon, 19 Sep 2011 19:20:17 -0700
In-Reply-To: <20110919212040.745370781@goodmis.org> (Steven Rostedt's message
	of "Mon, 19 Sep 2011 17:20:40 -0400")
Message-ID: <m2ehzcdkf2.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> I just found out that the this_cpu_*() functions do not perform the
> test to see if the usage is in atomic or not. Thus, the blind
> conversion of the per_cpu(*, smp_processor_id()) and the get_cpu_var()
> code to this_cpu_*() introduce the regression to detect the hard
> to find case where a per cpu variable is used in preempt code that
> migrates and causes bugs.


Didn't preempt-rt recently get changed to not migrate in kernel-preempt
regions. How about just fixing the normal preemption to not do this
either.

Then all these complications wouldn't be necessary and a whole lot 
of code related to this could be removed too, and you would still
have less bugs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
