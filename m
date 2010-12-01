Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0LALel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:34:41 -0500
Received: from fep18.mx.upcmail.net ([62.179.121.38]:39771 "EHLO
	fep18.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab0LALek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:34:40 -0500
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CF5C379.8030204@google.com>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>  <4CF5C379.8030204@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 12:34:32 +0100
Message-ID: <1291203272.4023.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=YkiHm+ATFBqfWDprzc7VyYVud6sOBg0JMTRaeRDeqNo= c=1 sm=0 a=gKIfv9-gHswA:10 a=IkcTkHD0fZMA:10 a=ubsNcGKNOhfYDG52H2gA:9 a=bBKDcWkm4dD2mDgLUuoqhj_aPFcA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 19:39 -0800, Paul Turner wrote:
> On 11/28/10 06:24, Mike Galbraith wrote:
> > On Thu, 2010-11-25 at 09:00 -0700, Mike Galbraith wrote:
> >
> >> My vacation is (sniff) over, so I won't get a fully tested patch out the
> >> door for review until I get back home.
> >
> > Either I forgot to pack my eyeballs, or laptop is just too dinky and
> > annoying.  Now back home on beloved box, this little bugger poked me
> > dead in the eye.
> >
> > Something else is seriously wrong though.  36.1 with attached (plus
> > sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> > 37.git and tip with fixlet below both suck rocks.  With a make -j40
> > running, wakeup-latency is showing latencies of>100ms, amarok skips,
> > mouse lurches badly.. generally horrid.  Something went south.
> >
> 
> I'm looking at this.
> 
> The share:share ratios looked good in static testing, but perhaps we 
> need a little more wake-up boost to improve interactivity.
> 
> Should have something tomorrow.

Right, the previous thing cheated quite enormous with wakeups simply
because it was way too expensive to compute proper shares on wakeups.

Maybe we should re-instate some of that cheating.

