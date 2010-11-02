Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0KBP1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:27:55 -0400
Received: from www.tglx.de ([62.245.132.106]:58244 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab0KBP1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:27:52 -0400
Date: Tue, 2 Nov 2010 16:26:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
In-Reply-To: <20101101184512.GA1589@arch.trippelsdorf.de>
Message-ID: <alpine.LFD.2.00.1011021626160.9357@localhost6.localdomain6>
References: <1288120736.2645.9.camel@localhost> <20101027142622.GA1555@arch.trippelsdorf.de> <20101027182608.GA1580@arch.trippelsdorf.de> <20101029081831.GA7149@liondog.tnic> <20101029083013.GA1553@arch.trippelsdorf.de> <20101029102713.GA21125@aftab>
 <alpine.LFD.2.00.1010291411150.2692@localhost6.localdomain6> <20101029170040.GJ21125@aftab> <20101029172631.GA23546@arch.trippelsdorf.de> <alpine.LFD.2.00.1011011904280.2566@localhost6.localdomain6> <20101101184512.GA1589@arch.trippelsdorf.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Markus Trippelsdorf wrote:

> On Mon, Nov 01, 2010 at 07:05:17PM +0100, Thomas Gleixner wrote:
> > On Fri, 29 Oct 2010, Markus Trippelsdorf wrote:
> > > On Fri, Oct 29, 2010 at 07:00:40PM +0200, Borislav Petkov wrote:
> > > > So Markus, can you try with 995bd3bb5c78, but by increasing the value
> > > > to, say 16 (I don't know what's a good value here, let's double the old
> > > > one). Simply change the line
> > > > 
> > > > 	return res < 8 ? -ETIME : 0;
> > > > 
> > > > to
> > > > 
> > > > 	return res < 16 ? -ETIME : 0;
> > > > 
> > > > 
> > > > in <arch/x86/kernel/hpet.c:hpet_next_event()>. I'll do that too on the
> > > > machine here when I get around to it.
> > > 
> > > Yes, I already did this, although I'm running
> > > return res < 12 ? -ETIME : 0; 
> > > at the moment.
> > 
> > Any update on this ?
> 
> Yes, it runs stable thus far. No "slowdowns", no problems.

Ok, I'm waiting for Boris to get us the confirmation from HW folks.

Thanks,

	tglx
