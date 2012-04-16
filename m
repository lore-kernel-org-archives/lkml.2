Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2DPN1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:27:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47397 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2DPN1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:27:35 -0400
Message-ID: <1334582840.28150.43.camel@twins>
Subject: Re: kvm: RCU warning in async pf
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Mon, 16 Apr 2012 15:27:20 +0200
In-Reply-To: <1334582281.28150.41.camel@twins>
References: <1333414472.11455.7.camel@lappy>
	 <20120403105226.GF14939@redhat.com> <20120404123033.GD11918@redhat.com>
	 <1334396693.2528.45.camel@twins> <20120416102855.GP11918@redhat.com>
	 <20120416125848.GT11918@redhat.com> <1334581548.28150.40.camel@twins>
	 <20120416130806.GV11918@redhat.com> <1334582281.28150.41.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 15:18 +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-16 at 16:08 +0300, Gleb Natapov wrote:
> > On Mon, Apr 16, 2012 at 03:05:48PM +0200, Peter Zijlstra wrote:
> > > On Mon, 2012-04-16 at 15:58 +0300, Gleb Natapov wrote:
> > > > -               rcu_irq_enter();
> > > > +               irq_enter();
> > > >                 exit_idle(); 
> > > 
> > > Do we really need the exit_idle()? I can't remember other interrupt
> > > handlers doing that.
> > They do. That's where I got the idea.
> 
> Some do.. some don't.. /me goes have a look what this exit_idle nonsense
> is all about. Looks to be something broken.

Yeah, its broken and the whole implementation is crap anyway. There's
only one user (drivers/idle/i7300_idle.c) so it likely doesn't matter
(much) anyway.

Thomas, can we rip that stuff out? or do we have to like actually fix
it?
