Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab0J2Rfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:35:31 -0400
Received: from www.tglx.de ([62.245.132.106]:58664 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab0J2Rf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:35:28 -0400
Date: Fri, 29 Oct 2010 19:34:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@amd64.org>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@alien8.de>, john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
In-Reply-To: <20101029170040.GJ21125@aftab>
Message-ID: <alpine.LFD.2.00.1010291932090.2692@localhost6.localdomain6>
References: <20101026131843.GC17852@aftab> <20101026135808.GB1672@arch.trippelsdorf.de> <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6> <1288120736.2645.9.camel@localhost> <20101027142622.GA1555@arch.trippelsdorf.de> <20101027182608.GA1580@arch.trippelsdorf.de>
 <20101029081831.GA7149@liondog.tnic> <20101029083013.GA1553@arch.trippelsdorf.de> <20101029102713.GA21125@aftab> <alpine.LFD.2.00.1010291411150.2692@localhost6.localdomain6> <20101029170040.GJ21125@aftab>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

On Fri, 29 Oct 2010, Borislav Petkov wrote:
> So Markus, can you try with 995bd3bb5c78, but by increasing the value
> to, say 16 (I don't know what's a good value here, let's double the old
> one). Simply change the line
> 
> 	return res < 8 ? -ETIME : 0;
> 
> to
> 
> 	return res < 16 ? -ETIME : 0;
> 
> 
> in <arch/x86/kernel/hpet.c:hpet_next_event()>. I'll do that too on the
> machine here when I get around to it.

can you please check with your hardware folks? If we can't get some
affirmative info about that then we'd be forced to revert that commit
(if it turns out to be the culprit one). That'd be a pity as it would
bring back the full IO access penalty to everyone.

Thanks,

	tglx
