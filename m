Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab1EZQ2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:28:08 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42090 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1EZQ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:28:06 -0400
Date: Thu, 26 May 2011 09:28:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110526162802.GC2386@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110524013523.GO7428@linux.vnet.ibm.com>
 <4DDC21E1.1070502@kernel.org>
 <4DDC48E3.1060108@kernel.org>
 <20110525045253.GB2262@linux.vnet.ibm.com>
 <4DDD7F96.3090408@kernel.org>
 <20110525223437.GO2341@linux.vnet.ibm.com>
 <4DDD8775.1000501@kernel.org>
 <20110526011310.GP2341@linux.vnet.ibm.com>
 <20110526013029.GA28103@linux.vnet.ibm.com>
 <BANLkTinC2q6Fjf7=2GZoJ=+c+fzpdwAvuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinC2q6Fjf7=2GZoJ=+c+fzpdwAvuQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:08:26AM -0700, Yinghai Lu wrote:
> On Wed, May 25, 2011 at 6:30 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, May 25, 2011 at 06:13:10PM -0700, Paul E. McKenney wrote:
> >> On Wed, May 25, 2011 at 03:49:25PM -0700, Yinghai Lu wrote:
> >> > On 05/25/2011 03:34 PM, Paul E. McKenney wrote:
> >> > > On Wed, May 25, 2011 at 03:15:50PM -0700, Yinghai Lu wrote:
> >> > >>> There is a new branch yinghai.2011.05.24a on:
> >> > >>>
> >> > >>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> >> > >>>
> >> > >>> Or will be as soon as kernel.org updates its mirrors.
> >> > >>>
> >> > >>> I am not sure I could call this "clean", but it does revert that commit
> >> > >>> and 11 of the subsequent commits that depend on it.  It does build,
> >> > >>> and I will test it once my currently running tests complete.
> >> > >>
> >> > >> yes, with those revert, there is no delay in 10 times booting.
> >> > >
> >> > > Unfortunately, there are rcutorture test failures with the revert...
> >> >
> >> > confused.
> >>
> >> Given what I had to do to generate the revert, not exactly a surprise,
> >> I am afraid.  Just means that the resulting RCU sometimes fails to
> >> wait for all pre-existing readers, and rcutorture catches it.
> >>
> >> > what is the next?
> >>
> >> 1.    I send you a patch that I hope will fix the softlockup
> >>       you saw.  I am testing this.
> >>
> >> 2.    I am working on more detailed instrumentation, and will
> >>       send a patch on that.
> >>
> >> 3.    If time allows, break down the operations RCU is doing
> >>       and test them in isolation.
> >>
> >> Other thoughts?
> >
> > And here is patch #1.  Could you please try applying this on top of
> > Peter Zijlstra's patch to see if it gets rid of the softlockups you saw?
> >
> >                                                        Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> > rcu: Start RCU kthreads in TASK_INTERRUPTIBLE state
> >
> > Upon creation, kthreads are in TASK_UNINTERRUPTIBLE state, which can
> > result in softlockup warnings.  Because some of RCU's kthreads can
> > legitimately be idle indefinitely, start them in TASK_INTERRUPTIBLE
> > state in order to avoid those warnings.
> 
> Yes, it fixes the lock up warning.

Very good, I have added your Tested-by.

							Thanx, Paul
