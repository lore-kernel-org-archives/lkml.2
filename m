Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1ITRJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:09:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33762 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1ITRJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:09:23 -0400
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@gentwo.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 20 Sep 2011 19:09:01 +0200
In-Reply-To: <1316537808.29966.98.camel@gandalf.stny.rr.com>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <27409.1316522696@turing-police.cc.vt.edu>
	 <alpine.DEB.2.00.1109200955190.8056@router.home>
	 <1316531987.29966.65.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201108080.8056@router.home>
	 <1316536260.29966.93.camel@gandalf.stny.rr.com>
	 <1316537808.29966.98.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316538541.13664.60.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 12:56 -0400, Steven Rostedt wrote:
> random_cpu_*()    // Thomas's idea

I like this one best..

But you forgot do deal with the irqsafe_cpu() crap, that's the same
brainfart as this_cpu() but more expensive because it frobs IRQ state.
