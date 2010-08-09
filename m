Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0HINu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab0HINu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:50:26 -0400
Date: Mon, 9 Aug 2010 09:49:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend on
 LOCKUP_DETECTOR
Message-ID: <20100809134917.GD2604@redhat.com>
References: <4C58C7FF.5060906@cn.fujitsu.com>
 <20100806005801.GB5436@nowhere>
 <20100807070135.GC23108@elte.hu>
 <20100808195839.GA5387@nowhere>
 <20100809080740.GA2169@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809080740.GA2169@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 10:07:40AM +0200, Heiko Carstens wrote:
> On Sun, Aug 08, 2010 at 09:58:42PM +0200, Frederic Weisbecker wrote:
> > > Maybe a better change would be to make it more generally available - right now 
> > > it's:
> > > 
> > >  config LOCKUP_DETECTOR
> > >          bool "Detect Hard and Soft Lockups"
> > >          depends on DEBUG_KERNEL && !S390
> > > 
> > > which means that it cannot be enabled when DEBUG_KERNEL is off.
> > > 
> > > So i think we should:
> > > 
> > >  - Remove the s390 hack and add an ARCH_HAS_LOCKUP_DETECTOR flag
> > 
> > 
> > 
> > If we do this, we'll need to add this config on every archs but s390.
> > We should better have ARCH_WANT_NO_LOCKUP_DETECTOR. I know that
> > "negative" meaning configs suck, but otherwise we would lose this
> > support on many archs.
> > 
> > Why s390 doesn't want the softlockup detector to begin with?
> 
> If I remember correctly then we disabled that back then because we got
> false positives. The reason for those were that the softlockup detector
> did not take steal time into account.
> E.g. if a guest cpu runs for 10 seconds, but the hypervisor would steal
> 9 seconds in order to run other guest cpus this specific cpu would still
> think it ran for 10 seconds and therefore would generate invalid warnings.

I have learned recently that is applies to all virtual machines including
KVM, Xen and VMWare(?).  However, you only see this when you overload the
hypervisor with lots of guests.  Which is why you normally don't see this
on those types of guests.

But any time based detection debug features (softlockup, hardlockup,
hung_task) could potentially run into this.

Cheers,
Don

