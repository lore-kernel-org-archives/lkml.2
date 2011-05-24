Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1EXBfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:35:46 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42138 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1EXBfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:35:44 -0400
Date: Mon, 23 May 2011 18:35:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110524013523.GO7428@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DD70120.9090801@kernel.org>
 <20110521131844.GE2271@linux.vnet.ibm.com>
 <20110521140845.GA12157@linux.vnet.ibm.com>
 <4DDAC01E.7050602@kernel.org>
 <20110523212530.GF7428@linux.vnet.ibm.com>
 <4DDAD934.9010603@kernel.org>
 <4DDAE5FA.2030303@kernel.org>
 <4DDAE6A5.6060701@kernel.org>
 <20110524011824.GL7428@linux.vnet.ibm.com>
 <4DDB093F.2060601@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDB093F.2060601@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 06:26:23PM -0700, Yinghai Lu wrote:
> On 05/23/2011 06:18 PM, Paul E. McKenney wrote:
> 
> > OK, so it looks like I need to get this out of the way in order to track
> > down the delays.  Or does reverting PeterZ's patch get you a stable
> > system, but with the longish delays in memory_dev_init()?  If the latter,
> > it might be more productive to handle the two problems separately.
> > 
> > For whatever it is worth, I do see about 5% increase in grace-period
> > duration when switching to kthreads.  This is acceptable -- your
> > 30x increase clearly is completely unacceptable and must be fixed.
> > Other than that, the main thing that affects grace period duration is
> > the setting of CONFIG_HZ -- the smaller the HZ value, the longer the
> > grace-period duration.
> 
> for my 1024g system when memory hotadd is enabled in kernel config:
> 1. current linus tree + tip tree:  memory_dev_init will take about 100s.
> 2. current linus tree + tip tree + your tree - Peterz patch: 
>    a. on fedora 14 gcc: will cost about 4s: like old times
>    b. on opensuse 11.3 gcc: will cost about 10s.

So some patch in my tree that is not yet in tip makes things better?

If so, could you please see which one?  Maybe that would give me a hint
that could make things better on opensuse 11.3 as well.

							Thanx, Paul
