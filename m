Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0HIOTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:19:37 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:55044 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab0HIOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:19:36 -0400
Date: Mon, 9 Aug 2010 16:21:21 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend
 on LOCKUP_DETECTOR
Message-ID: <20100809142121.GD2169@osiris.boeblingen.de.ibm.com>
References: <4C58C7FF.5060906@cn.fujitsu.com>
 <20100806005801.GB5436@nowhere>
 <20100807070135.GC23108@elte.hu>
 <20100808195839.GA5387@nowhere>
 <20100809080740.GA2169@osiris.boeblingen.de.ibm.com>
 <20100809134917.GD2604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809134917.GD2604@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 09:49:17AM -0400, Don Zickus wrote:
> > > Why s390 doesn't want the softlockup detector to begin with?
> > 
> > If I remember correctly then we disabled that back then because we got
> > false positives. The reason for those were that the softlockup detector
> > did not take steal time into account.
> > E.g. if a guest cpu runs for 10 seconds, but the hypervisor would steal
> > 9 seconds in order to run other guest cpus this specific cpu would still
> > think it ran for 10 seconds and therefore would generate invalid warnings.
> 
> I have learned recently that is applies to all virtual machines including
> KVM, Xen and VMWare(?).  However, you only see this when you overload the
> hypervisor with lots of guests.  Which is why you normally don't see this
> on those types of guests.

On s390 you always run virtualized and usually even as a 2nd level guest.
Overloading a machine is quite common here.
The problem we have is that you can't tell afterwards if a warning was valid
or invalid due to overloading. Imho it is just pointless without taking steal
time into account and that's why we disabled it.
