Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2BOQJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:09:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56529 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2BOQJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:09:30 -0500
Message-ID: <1329322147.2293.145.camel@twins>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Saravana Kannan <skannan@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
        linaro-kernel@lists.linaro.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Chan <mike@android.com>, Dave Jones <davej@redhat.com>,
        Todd Poynor <toddpoynor@google.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 15 Feb 2012 17:09:07 +0100
In-Reply-To: <20120215160028.GD27825@n2100.arm.linux.org.uk>
References: <1328670355.2482.68.camel@laptop>
	 <20120208202314.GA28290@redhat.com> <1328736834.2903.33.camel@pasglop>
	 <20120209075106.GB18387@elte.hu> <4F35DD3E.4020406@codeaurora.org>
	 <20120211144530.GA497@elte.hu> <4F3AEC4E.9000303@codeaurora.org>
	 <1329313085.2293.106.camel@twins>
	 <20120215140245.GB27825@n2100.arm.linux.org.uk>
	 <1329318063.2293.136.camel@twins>
	 <20120215160028.GD27825@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 16:00 +0000, Russell King - ARM Linux wrote:
> 
> > A third possibility is to self-IPI and take it from there.. assuming
> > these platforms can actually self-IPI.
> 
> Even if there was an IPI (not talking about SMP anyway) I'm not sure
> what good it would be.  We can (and do) get an IRQ from the LCD
> controller when its shutdown is complete, but that would have to be
> somehow propagated back up to the cpufreq code.  And the cpufreq code
> would have to know that the LCD controller was alive and therefore had
> to be waited for.  All sounds rather yucky to me. 

If can self-ipi from the scheduler context (which has IRQs disabled),
once you get to the ipi handler your scheduler locks are gone and you
can queue a worklet or wake some kthread to do all the sleeping stuff.


