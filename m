Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1G1OFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:05:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:37164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1G1OFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:05:33 -0400
Subject: Re: [PATCH v2 0/6] Add tracepoints to trace all system IRQs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <20110728123131.GA11820@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
	 <1311793038-15155-1-git-send-email-vnagarnaik@google.com>
	 <1311855169.2617.168.camel@laptop>
	 <20110728123131.GA11820@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 16:10:04 +0200
Message-ID: <1311862204.2617.179.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 14:31 +0200, Frederic Weisbecker wrote:
> 
> Because that requires to put the tracepoints in every interrupt sources
> for every archs instead of putting one in the generic space. 

To sum up from IRC, yes that's exactly what you need to do, because this
patch set assumes two things:

 1) that there is a 1:1 mapping between interrupt sources and generic
handlers, and

 2) that there is a neglectable amount of arch specific code for each
generic handler.

Both are false in generic. Therefore there is no option but to
instrument each and every arch specific interrupt handler.

Also, please use a single tracepoint for all that instead of this horrid
forest of random crap. Use something like arch_interrupt_enter(line_nr),
arch_interrupt_exit(line_nr).



