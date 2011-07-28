Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab1G1MIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:08:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:44684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab1G1MIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:08:13 -0400
Subject: Re: [PATCH v2 0/6] Add tracepoints to trace all system IRQs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <1311793038-15155-1-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
	 <1311793038-15155-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 14:12:49 +0200
Message-ID: <1311855169.2617.168.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 11:57 -0700, Vaibhav Nagarnaik wrote:
> This is a patch series aiming to trace all the system IRQs. The
> tracepoints make it easier to understand IRQ interaction with other
> system events and find out how much time is spent in kernel space versus
> user space.

That doesn't cover the actual rational, you can get that information by
using CONFIG_IRQ_TIME_ACCOUNTING.

> Patches 1-5 add tracepoints to the generic kernel IRQ handlers to
> benefit all the architectures, as suggested by Frederic. Patch#6 adds
> trace events to trace all platform specific interrupt vectors which do
> not have any generic handlers. This patch traces x86 IRQ vectors but can
> be used by other architectures to trace their vectors too.
> 
> Changelog v2-v1:
> * Fix patch#3 to trace IRQ work run vector even when the irq work list
>   is empty
> * Fix patch#5 to use updated trace event names,
>   call_function_ipi_(entry|exit) and
>   call_function_single_ipi_(entry|exit)
> * Rebase to 3.0
> * Update changelog

I still completely hate how you make new events for every interrupt
source. That's a massive pollution of the event space.

Also, since you do arch specific things anyway, why not from a single
tracepoint into the arch interrupt stubs and be done with it, no need to
puke all over the rest of the code.

