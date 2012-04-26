Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2DZN3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:29:43 -0400
Received: from seven.medozas.de ([188.40.89.202]:56141 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab2DZN3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:29:42 -0400
Date: Thu, 26 Apr 2012 15:29:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 5/6] rcu: Make __kfree_rcu() less
 dependent on compiler choices
In-Reply-To: <1335444509.13683.13.camel@twins>
Message-ID: <alpine.LNX.2.01.1204261526080.31482@frira.zrqbmnf.qr>
References: <20120423164159.GA13819@linux.vnet.ibm.com>  <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>  <1335199347-13926-5-git-send-email-paulmck@linux.vnet.ibm.com> <1335444509.13683.13.camel@twins>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2012-04-26 14:48, Peter Zijlstra wrote:
>On Mon, 2012-04-23 at 09:42 -0700, Paul E. McKenney wrote:
>> Currently, __kfree_rcu() is implemented as an inline function, and
>> contains a BUILD_BUG_ON() that malfunctions if __kfree_rcu() is compiled
>> as an out-of-line function.  Unfortunately, there are compiler settings
>> (e.g., -O0) that can result in __kfree_rcu() being compiled out of line,
>> resulting in annoying build breakage.  This commit therefore converts
>> both __kfree_rcu() and __is_kfree_rcu_offset() from inline functions to
>> macros to prevent such misbehavior on the part of the compiler.
>
>The kernel very explicitly doesn't support being compiled with -O0, so
>this is a non-issue, I think you can make it work if you add
>-finline-functions.
>
>I'd drop this, either make the entire kernel compile or don't bother.

It was not originally meant to make the entire kernel compile with -O0,
but only select modules/.c files.
That, or __always_inline just does not always inline.

