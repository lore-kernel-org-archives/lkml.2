Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0HIIF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:05:57 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:46578 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab0HIIFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:05:55 -0400
Date: Mon, 9 Aug 2010 10:07:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend
	on LOCKUP_DETECTOR
Message-ID: <20100809080740.GA2169@osiris.boeblingen.de.ibm.com>
References: <4C58C7FF.5060906@cn.fujitsu.com>
 <20100806005801.GB5436@nowhere>
 <20100807070135.GC23108@elte.hu>
 <20100808195839.GA5387@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100808195839.GA5387@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 08, 2010 at 09:58:42PM +0200, Frederic Weisbecker wrote:
> > Maybe a better change would be to make it more generally available - right now 
> > it's:
> > 
> >  config LOCKUP_DETECTOR
> >          bool "Detect Hard and Soft Lockups"
> >          depends on DEBUG_KERNEL && !S390
> > 
> > which means that it cannot be enabled when DEBUG_KERNEL is off.
> > 
> > So i think we should:
> > 
> >  - Remove the s390 hack and add an ARCH_HAS_LOCKUP_DETECTOR flag
> 
> 
> 
> If we do this, we'll need to add this config on every archs but s390.
> We should better have ARCH_WANT_NO_LOCKUP_DETECTOR. I know that
> "negative" meaning configs suck, but otherwise we would lose this
> support on many archs.
> 
> Why s390 doesn't want the softlockup detector to begin with?

If I remember correctly then we disabled that back then because we got
false positives. The reason for those were that the softlockup detector
did not take steal time into account.
E.g. if a guest cpu runs for 10 seconds, but the hypervisor would steal
9 seconds in order to run other guest cpus this specific cpu would still
think it ran for 10 seconds and therefore would generate invalid warnings.
