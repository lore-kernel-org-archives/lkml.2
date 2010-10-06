Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0JFE7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:59:12 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49541 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab0JFE7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:59:10 -0400
Date: Tue, 5 Oct 2010 21:59:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] core kernel fixes
Message-ID: <20101006045905.GE2553@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101005191223.GA31795@elte.hu>
 <AANLkTik9E0dr=Qah0d_+9YaAsA7WfeawA1c4oDbiJK-j@mail.gmail.com>
 <20101005210904.GQ2369@linux.vnet.ibm.com>
 <AANLkTi==ZE7+PTPdB1JjdSdqus0Ox+rjTAxMMMJk0fBi@mail.gmail.com>
 <20101005220546.GS2369@linux.vnet.ibm.com>
 <1286333814.4861.9.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286333814.4861.9.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 04:56:54AM +0200, Eric Dumazet wrote:
> Le mardi 05 octobre 2010 à 15:05 -0700, Paul E. McKenney a écrit :
> > On Tue, Oct 05, 2010 at 02:45:07PM -0700, Linus Torvalds wrote:
> > > On Tue, Oct 5, 2010 at 2:09 PM, Paul E. McKenney
> > > <paulmck@linux.vnet.ibm.com> wrote:
> > > >
> > > > Good point!!!  If the following diff looks good to you, I will get it
> > > > tested and pushed.
> > > 
> > > Looks good. Except since I pulled the thing despite my complaint,
> > > you'll also need to undo the extra irqs_disabled() test.
> > 
> > No problem, the diff I sent you combined two commits.  ;-)
> > 
> 
> Hi Paul & Linus
> 
> I originally considered adding the test in rcu_read_lock_bh_held() too,
> but thought (wrongly) :
> 
> 	"rcu_read_unlock_bh() doesnt block hard IRQ, thus
> 	 rcu_read_lock_bh_held() should not test hard irq."
> 
> I remember anyway my first patch was wrong, since I was not using
> irqs_disabled() but in_irq() 
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2010/9/22/4622784

Eric,

I believe that history shows that we were all groping around in the
dark on this one...  Me not least of all.  ;-)

Not sure we are completely there yet, but we are at least in a
feasible state.

Ingo, I have this queued up at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

It passes targeted testing.  If Eric is OK with it, it is ready to be
pulled.  At least as soon as kernel.org gets it out to the mirrors.
Commmit 773e3f9357.

							Thanx, Paul
