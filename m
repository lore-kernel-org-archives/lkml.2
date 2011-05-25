Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1EYHYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:24:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51841 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab1EYHYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:24:21 -0400
Date: Wed, 25 May 2011 09:24:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
Message-ID: <20110525072406.GH429@elte.hu>
References: <4DDAD934.9010603@kernel.org>
 <4DDAE5FA.2030303@kernel.org>
 <4DDAE6A5.6060701@kernel.org>
 <20110524011824.GL7428@linux.vnet.ibm.com>
 <4DDB093F.2060601@kernel.org>
 <20110524013523.GO7428@linux.vnet.ibm.com>
 <4DDC21E1.1070502@kernel.org>
 <20110525000530.GK2266@linux.vnet.ibm.com>
 <4DDC4992.2020505@kernel.org>
 <20110525044650.GA2262@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525044650.GA2262@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, May 24, 2011 at 05:13:06PM -0700, Yinghai Lu wrote:
> > On 05/24/2011 05:05 PM, Paul E. McKenney wrote:
> > > On Tue, May 24, 2011 at 02:23:45PM -0700, Yinghai Lu wrote:
> > >> On 05/23/2011 06:35 PM, Paul E. McKenney wrote:
> > >>> On Mon, May 23, 2011 at 06:26:23PM -0700, Yinghai Lu wrote:
> > >>>> On 05/23/2011 06:18 PM, Paul E. McKenney wrote:
> > >>>>
> > >>>>> OK, so it looks like I need to get this out of the way in order to track
> > >>>>> down the delays.  Or does reverting PeterZ's patch get you a stable
> > >>>>> system, but with the longish delays in memory_dev_init()?  If the latter,
> > >>>>> it might be more productive to handle the two problems separately.
> > >>>>>
> > >>>>> For whatever it is worth, I do see about 5% increase in grace-period
> > >>>>> duration when switching to kthreads.  This is acceptable -- your
> > >>>>> 30x increase clearly is completely unacceptable and must be fixed.
> > >>>>> Other than that, the main thing that affects grace period duration is
> > >>>>> the setting of CONFIG_HZ -- the smaller the HZ value, the longer the
> > >>>>> grace-period duration.
> > >>>>
> > >>>> for my 1024g system when memory hotadd is enabled in kernel config:
> > >>>> 1. current linus tree + tip tree:  memory_dev_init will take about 100s.
> > >>>> 2. current linus tree + tip tree + your tree - Peterz patch: 
> > >>>>    a. on fedora 14 gcc: will cost about 4s: like old times
> > >>>>    b. on opensuse 11.3 gcc: will cost about 10s.
> > >>>
> > >>> So some patch in my tree that is not yet in tip makes things better?
> > >>>
> > >>> If so, could you please see which one?  Maybe that would give me a hint
> > >>> that could make things better on opensuse 11.3 as well.
> > >>
> > >> today's tip:
> > >>
> > >> [   31.795597] cpu_dev_init done
> > >> [   40.930202] memory_dev_init done
> > > 
> > > One other question...  What is memory_dev_init() doing to wait for so
> > > many RCU grace periods?  (Yes, I do need to fix the slowdowns in any
> > > case, but I am curious.)
> > 
> > looks like it register some in sysfs
> 
> Use of synchronize_rcu() for unregistering would make sense, but
> I don't understand why it is needed when registering.

I guess writing a patch to remove it would be welcome by the sysfs folks - or 
some subtle reason would be pointed out (which reason could thus be added to 
the code in a comment).

Understanding the nondeterminism of grace periods would be extremely nice 
though, there *are* workloads that use rcu syncs rather frequently, and we have 
probably regressed them.

Thanks,

	Ingo
