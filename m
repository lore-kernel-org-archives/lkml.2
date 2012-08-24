Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab2HXPkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:40:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:34036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303Ab2HXPkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:40:14 -0400
Date: Fri, 24 Aug 2012 17:40:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Mike Galbraith <efault@gmx.de>, sedat.dilek@gmail.com,
        Paul McKenney <paul.mckenney@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [next-20120823] NOHZ: local_softirq_pending 200 on s/r
In-Reply-To: <20120824145247.GB2472@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1208241738130.2856@ionos>
References: <CA+icZUW2aUP=vjBeoksFU=NAVFMJEiBQy6sNKZczzRPEP9kOfw@mail.gmail.com> <1345793168.4331.64.camel@marge.simpson.net> <20120824145247.GB2472@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Paul E. McKenney wrote:

> On Fri, Aug 24, 2012 at 09:26:08AM +0200, Mike Galbraith wrote:
> > On Thu, 2012-08-23 at 12:04 +0200, Sedat Dilek wrote:
> > 
> > > Jack Winter confirmed to see similiar NOHZ messages also on
> > > v3.4.9-rt17 kernel (CPU: Core2Duo when no suspend performed):
> > > 
> > > [15223.171585] NOHZ: local_softirq_pending 08
> > 
> > These can be caused by blocking while holding local_softirq_lock.

> > Even with per softirq threads, and then (yet more overhead) splitting
> > the lock to make sure one softirq type can't block another, _and_ only
> > griping if the lock for the pending softirq is _not_ held, seems the
> > little bugger can still be triggered very rarely by syn flood induced
> > handler bail/raise.  Annoying little gripe :)
> 
> Hmmm...  Now that you mention it, if I understand correctly, the
> conversion of spinlocks to sleeplocks in -rt would seem to invalidate
> this particular diagnostic completely.
> 
> So, what am I missing?

I wonder whether the softirq_check_pending_idle() check needs a few
tweaks for RT, but I have to see a proper context for the failure
scenario first.

Thanks,

	tglx
