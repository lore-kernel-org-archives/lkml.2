Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1G1NXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:23:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:60193 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab1G1NXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:23:51 -0400
Subject: Re: [PATCH v2 0/6] Add tracepoints to trace all system IRQs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <20110728130925.GB11820@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
	 <1311793038-15155-1-git-send-email-vnagarnaik@google.com>
	 <1311855169.2617.168.camel@laptop>
	 <20110728123131.GA11820@somewhere.redhat.com>
	 <1311857632.2617.172.camel@laptop>
	 <20110728130925.GB11820@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 15:28:22 +0200
Message-ID: <1311859702.2617.174.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 15:09 +0200, Frederic Weisbecker wrote:
> On Thu, Jul 28, 2011 at 02:53:52PM +0200, Peter Zijlstra wrote:
> > On Thu, 2011-07-28 at 14:31 +0200, Frederic Weisbecker wrote:
> > > 
> > > Because that requires to put the tracepoints in every interrupt sources
> > > for every archs instead of putting one in the generic space. 
> > 
> > Yeah so, he needs to touch arch code anyway.
> 
> He needs to touch arch code for pure arch interrupts or some cases
> where we don't have the choice. But otherwise there are many
> cases where we can put that in the generic code.

Which I just pointed out you can't, some 'generic' handlers are in fact
multiplexed on a single arch interrupt. If you want all interrupts, use
pure arch hooks at the lowest level and stop mucking about.


