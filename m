Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab0J0Tmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:42:42 -0400
Received: from smtp-out-244.synserver.de ([212.40.180.244]:1182 "EHLO
	smtp-out-238.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752299Ab0J0Tmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:42:40 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 16763
Date: Wed, 27 Oct 2010 21:42:37 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        heiko.carstens@de.ibm.com, avi@redhat.com, mtosatti@redhat.com
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101027194237.GB1580@arch.trippelsdorf.de>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
 <20101027142622.GA1555@arch.trippelsdorf.de>
 <20101027182608.GA1580@arch.trippelsdorf.de>
 <1288208215.3673.16.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288208215.3673.16.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 09:36:55PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-27 at 20:26 +0200, markus@trippelsdorf.de wrote:
> > 
> > 34f971f6f7988be4d014eec3e3526bee6d007ffa is the first bad commit
> > commit 34f971f6f7988be4d014eec3e3526bee6d007ffa
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Wed Sep 22 13:53:15 2010 +0200
> > 
> >     sched: Create special class for stop/migrate work
> > 
> >     In order to separate the stop/migrate work thread from the SCHED_FIFO
> >     implementation, create a special class for it that is of higher priority than
> >     SCHED_FIFO itself.
> > 
> >     This currently solves a problem where cpu-hotplug consumes so much cpu-time
> >     that the SCHED_FIFO class gets throttled, but has the bandwidth replenishment
> >     timer pending on the now dead cpu.
> > 
> >     It is also required for when we add the planned deadline scheduling class above
> >     SCHED_FIFO, as the stop/migrate thread still needs to transcent those tasks.
> > 
> >     Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     LKML-Reference: <1285165776.2275.1022.camel@laptop>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > Reverting the commit solves the kvm hang issue.
> > (If this issue is related to my original tsc problem is of course open for
> > debate, but I have a strong hunch it is.) 
> 
> Too weird,.. what does the hang look like?
> 
> Can you generate a sysrq-t dump? The thing I'm looking for is the
> migration/# thread being runnable but not being current.
> 
> How can I reproduce this?

It's quite easy to reproduce on my setup. I simply run:

qemu-kvm -net nic,vlan=0,model=virtio -net user -drive file=ubuntu,if=virtio,boot=on -smp 2 -m 512

and then move the mousepointer in circles in the qemu window. It will stop and
freeze after a few seconds.
-- 
Markus
