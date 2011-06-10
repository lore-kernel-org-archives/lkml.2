Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1FJNYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:24:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:59382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab1FJNYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:24:14 -0400
Subject: Re: [PATCH 2/3] printk, lockdep: Remove lockdep_off() usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
In-Reply-To: <20110609131307.539373927@chello.nl>
References: <20110609130647.937204592@chello.nl>
	 <20110609131307.539373927@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Jun 2011 15:23:55 +0200
Message-ID: <1307712235.3941.154.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 15:06 +0200, Peter Zijlstra wrote:
> Remove the lockdep_off() usage from printk(). Also add a
> debug_locks_off() call to zap_locks() since that'll mess up the lock
> state in a royal way anyway. Further switch to local_irq_ ops so that
> the irq state is properly tracked (raw_local_irq_* isn't tracked by
> lockdep, causing confusion). Also drop superfluous preempt_disable(),
> disabling IRQs already avoids scheduling.
> 

OK, so while trying to decipher the irq status of printk() I found
commit 1efc5da3 which explains why we've got lockdep_off() in there,
there still is a recursion problem with trace_hardirqs_*.

/me goes poke at that..

