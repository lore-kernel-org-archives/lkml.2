Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab0J2ISo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:18:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46734 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab0J2ISf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:18:35 -0400
Date: Fri, 29 Oct 2010 10:18:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: markus@trippelsdorf.de
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, avi@redhat.com,
        mtosatti@redhat.com
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101029081831.GA7149@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, markus@trippelsdorf.de,
	john stultz <johnstul@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@amd64.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"hpa@linux.intel.com" <hpa@linux.intel.com>,
	Ingo Molnar <mingo@elte.hu>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, avi@redhat.com,
	mtosatti@redhat.com
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
 <20101027142622.GA1555@arch.trippelsdorf.de>
 <20101027182608.GA1580@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101027182608.GA1580@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 08:26:08PM +0200, markus@trippelsdorf.de wrote:
> During my search for a reliable testcase I found out that kvm guests also
> showed random hangs (that didn't happen in v2.6.36) here. These hangs last a
> few seconds each, during which the mouse is not movable at all.
> 
> So I ran git-bisect with this testcase and the result of the bisection is:
> 
> 34f971f6f7988be4d014eec3e3526bee6d007ffa is the first bad commit
> commit 34f971f6f7988be4d014eec3e3526bee6d007ffa
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Wed Sep 22 13:53:15 2010 +0200
>

...

>
> Reverting the commit solves the kvm hang issue. (If this issue is
> related to my original tsc problem is of course open for debate, but I
> have a strong hunch it is.)

Well, what do you know, the temporary "slowdown" triggered on my setup
too. After waiting a minute maybe, the machine recovered and guess what
appeared in dmesg:

[44729.650859] Clocksource tsc unstable (delta = -8615263009 ns)
[44729.656229] Switching to clocksource hpet

I've reverted the changeset above and will run without it to check
whether it makes any difference.

-- 
Regards/Gruss,
    Boris.
