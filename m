Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab1LLJmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:42:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:52701 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1LLJmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:42:36 -0500
Date: Mon, 12 Dec 2011 10:42:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
In-Reply-To: <20111211155347.GA1297@elte.hu>
Message-ID: <alpine.LFD.2.02.1112121038580.3020@ionos>
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Dec 2011, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Sun, 11 Dec 2011, Ingo Molnar wrote:
> 
> > > In theory a kvm driven serial console should be extremely 
> > > fast, much faster than a real serial console, basically as 
> > > fast as a local console. Yet this still does not seem to be 
> > > the case.
> > > 
> > > In fact even ssh-ing in to a box over Wifi and running the 
> > > above top session is undistinguishable from top running in a 
> > > local console. So IMO it cannot be virtualization overhead - 
> > > there must still be some delay or serious lack of buffering 
> > > somewhere.
> > 
> > Well, the difference between ssh and serial is, that ssh can 
> > pack 1.5k worth of data into one frame, while serial has to 
> > send it piecewise. And the emulation has to trap into kvm tool 
> > for each tx byte, which doesnt help either. We cannot do much 
> > with buffering on the kvm tool side as we have no clue how 
> > much consecutive data will come in. That's why there is a 
> > virtual console, which has the disadvantage that you cant see 
> > the early boot messages.
> 
> Okay, but look at it from another angle: the top output i 
> generate is about 300k characters. 5000 msecs to execute it 
> means 16 usecs overhead per character - or about 50k cycles - on 
> a top of the class x86 CPU.
> 
> 50k cycles for every single byte. And as a user i notice that 
> first hand.

Well, you can't do anything about it simply because it's doing full
hardware emulation which goes all the way to user space and back for
each inb/outb.

virtio_console was written to avoid that overhead.

Thanks,

	tglx
