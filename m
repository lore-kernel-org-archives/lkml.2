Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1LLLXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:23:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46892 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab1LLLXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:23:23 -0500
Date: Mon, 12 Dec 2011 15:23:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111212112318.GG2199@moon>
References: <20111210132220.083204833@linutronix.de>
 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
 <alpine.LFD.2.02.1112102144370.3020@ionos>
 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
 <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos>
 <20111211155347.GA1297@elte.hu>
 <1323667836.4190.4.camel@lappy>
 <20111212111222.GA21121@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212111222.GA21121@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 12:12:22PM +0100, Ingo Molnar wrote:
> 
> * Sasha Levin <levinsasha928@gmail.com> wrote:
> 
> > 50k cycles for every single byte is pretty much as good as it 
> > will get with serial console. See slide #5 in Marcelo's KVM 
> > Forum 2010 presentation[1] where he timed a heavyweight exit 
> > to about 40k cycles.
> 
> > [1]
> > http://www.linux-kvm.org/wiki/images/e/ea/2010-forum-mtosatti_walkthrough_entry_exit.pdf
> 
> But what we do here is a PIO exit. That, according to Marcelo's 
> measurements, is about 10K cycles, back to back. [*]
> 
> So where does the extra overhead come from?
> 
> We shouldn't care that there's virtio-console - the goal of 
> tools/kvm it speed everything up as much as possible, so we 
> should not jump to the next IO abstraction unless we know where 
> every cycle was spent with simpler IO models ...
> 
> Thanks,
> 
> 	Ingo
> 
> [*] Also, those 10K cycles include some significant Qemu 
>     overhead - a couple of thousand cycles - that should be much 
>     lower in the tools/kvm case.
> 

FWIW, last time I was mcount'ing calltrace -- we spend a lot of time
due to timer signals, ie because of

#define TIMER_INTERVAL_NS 1000000	/* 1 msec */

so, do we really need it being that hight? This poll includes
enquiry if there some symbol a user typed in console. Maybe
we should reduce this rate?

	Cyrill
