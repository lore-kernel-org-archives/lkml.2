Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2DEQLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab2DEQLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:11:40 -0400
Message-ID: <4F7DC40F.5000805@redhat.com>
Date: Thu, 05 Apr 2012 19:10:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: kvm: RCU warning in async pf
References: <1333414472.11455.7.camel@lappy> <20120403105226.GF14939@redhat.com> <20120404123033.GD11918@redhat.com>
In-Reply-To: <20120404123033.GD11918@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 03:30 PM, Gleb Natapov wrote:
> On Tue, Apr 03, 2012 at 01:52:26PM +0300, Gleb Natapov wrote:
> > On Mon, Apr 02, 2012 at 08:54:32PM -0400, Sasha Levin wrote:
> > > Hi all,
> > > 
> > > I got the spew at the bottom of the mail in a KVM guest using the KVM tools and running trinity.
> > > 
> > > I'm not quite sure how default_idle managed to trigger a pagefault, so that part looks odd to me.
> > > 
> > This is not regular page fault. This is async page fault that tells the
> > guest that a page, previously swapped out by hypervisor, is now swapped
> > back in and it can happen while vcpu is idle. The code does not leave
> > idle state properly though. We probably need to call rcu_irq_enter()
> > there. Will look into it.
> > 
>
> The patch below solves it for me:
>
> "Page ready" async PF can kick vcpu out of idle state much like IRQ.
> We need to tell RCU about this.
>
>

Applied it, thanks.

-- 
error compiling committee.c: too many arguments to function

