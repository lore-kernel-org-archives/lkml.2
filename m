Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2DZMtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:49:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57225 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2DZMtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:49:08 -0400
Message-ID: <1335444509.13683.13.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 5/6] rcu: Make __kfree_rcu() less
 dependent on compiler choices
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        Jan Engelhardt <jengelh@medozas.de>
Date: Thu, 26 Apr 2012 14:48:29 +0200
In-Reply-To: <1335199347-13926-5-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
	 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335199347-13926-5-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 09:42 -0700, Paul E. McKenney wrote:
> Currently, __kfree_rcu() is implemented as an inline function, and
> contains a BUILD_BUG_ON() that malfunctions if __kfree_rcu() is compiled
> as an out-of-line function.  Unfortunately, there are compiler settings
> (e.g., -O0) that can result in __kfree_rcu() being compiled out of line,
> resulting in annoying build breakage.  This commit therefore converts
> both __kfree_rcu() and __is_kfree_rcu_offset() from inline functions to
> macros to prevent such misbehavior on the part of the compiler.

The kernel very explicitly doesn't support being compiled with -O0, so
this is a non-issue, I think you can make it work if you add
-finline-functions.

I'd drop this, either make the entire kernel compile or don't bother.
