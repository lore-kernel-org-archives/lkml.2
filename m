Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1FHTrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:47:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:44737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1FHTrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:47:23 -0400
Subject: Re: [PATCH 2/4] sched: Isolate preempt counting in its own config
 option
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307555315-30989-3-git-send-email-fweisbec@gmail.com>
References: <1307555315-30989-1-git-send-email-fweisbec@gmail.com>
	 <1307555315-30989-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Jun 2011 21:47:14 +0200
Message-ID: <1307562434.3941.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 19:48 +0200, Frederic Weisbecker wrote:
> 
> Create a new CONFIG_PREEMPT_COUNT that handles the inc/dec
> of preempt count offset independently. So that the offset
> can be updated by preempt_disable() and preempt_enable()
> even without the need for CONFIG_PREEMPT beeing set.
> 
> This prepares to make CONFIG_DEBUG_SPINLOCK_SLEEP working
> with !CONFIG_PREEMPT where it currently doesn't detect
> code that sleeps inside explicit preemption disabled
> sections. 

The last time this got proposed it got shot down due to the extra
inc/dec stuff all over the place increasing overhead significantly.


