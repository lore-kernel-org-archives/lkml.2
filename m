Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602Ab0KRVRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:17:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab0KRVRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:17:01 -0500
Date: Thu, 18 Nov 2010 16:16:38 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118211638.GA13139@redhat.com>
References: <4CE2E3C3.6060800@windriver.com>
 <20101118080516.GJ32621@elte.hu>
 <4CE52048.5080802@windriver.com>
 <1290086232.2109.1507.camel@laptop>
 <20101118193247.GF18100@redhat.com>
 <4CE583D0.8050407@windriver.com>
 <20101118200807.GC8131@redhat.com>
 <20101118201118.GC6028@lenovo>
 <20101118205203.GA11445@redhat.com>
 <20101118210159.GF6028@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118210159.GF6028@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 12:01:59AM +0300, Cyrill Gorcunov wrote:
> On Thu, Nov 18, 2010 at 03:52:03PM -0500, Don Zickus wrote:
> ...
> > > 
> > > ok, Don, but you mentioned there are false alarms on real P4 machine, right?
> > 
> > Yeah, there are two problems.  One is using kgdb tests on kvm guests.  The
> > other is using kgdb tests on a bare metal p4 machine.
> > 
> > Cheers,
> > Don
> >
> 
>  ok, thanks, Jason just confirmed it too. I thing if we run with kgdb armed
> it (kgdb) should obtain nmi handler first and perf only after.
> 
>  actually I'm not sure why p4 hangs here while core passes the test, most

because p4 reads the wrong high register which comes back zero.  This will
always set overflow=1, thus swallowing all NMI if something like the nmi
watchdog has perf active.

Cheers,
Don
