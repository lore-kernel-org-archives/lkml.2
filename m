Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab0EMQEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:04:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab0EMQEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:04:39 -0400
Date: Thu, 13 May 2010 12:04:22 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       peterz@infradead.org, aris@redhat.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] [nmi watchdog] touch_softlockup cleanups and
 softlockup_tick removal
Message-ID: <20100513160422.GO15159@redhat.com>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
 <1273266711-18706-3-git-send-email-dzickus@redhat.com>
 <20100512200652.GF10028@nowhere>
 <20100512202628.GK15159@redhat.com>
 <20100512202832.GG10028@nowhere>
 <20100512205616.GL15159@redhat.com>
 <20100512210034.GH10028@nowhere>
 <20100512213814.GB5190@lenovo>
 <20100512215015.GM15159@redhat.com>
 <20100513155313.GA5274@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513155313.GA5274@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 07:53:13PM +0400, Cyrill Gorcunov wrote:
> On Wed, May 12, 2010 at 05:50:15PM -0400, Don Zickus wrote:
> ...
> > > Guys, could you please spend a few minutes and enlighten me a bit?
> > > Does all this series mean that we eventually will drop nmi-watchdog
> > > via io-apic (read via pic) as only the transition to perf complete?
> > > 
> > > I recall someone said about to stop using io-apic, but just to be sure.
> > 
> > Right, this code sits on top of the perf subsystem which uses lapic.
> > Eventually, the old nmi watchdog code will disappear along with the
> > support for io-apic.
> > 
> > Cheers,
> > Don
> > 
> 
> Thanks for explanation, Don! So I assume (?) that io-apic
> nmi-watchdog is going to be dropped due to obsolescense of
> this mode, right?

Well partly.  The other part is you can't really confirm an NMI came from
the io-apic or not unlike the lapic (where you can see if it crossed
zero).  Therefore under io-apic, all unknown nmis were wrongly being
filtered as nmi watchdog interrupts.

Cheers,
Don
