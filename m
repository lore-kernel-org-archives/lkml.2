Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab1LLFbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:31:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38502 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1LLFbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:31:06 -0500
Message-ID: <1323667836.4190.4.camel@lappy>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
From: Sasha Levin <levinsasha928@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 12 Dec 2011 07:30:36 +0200
In-Reply-To: <20111211155347.GA1297@elte.hu>
References: <20111210132220.083204833@linutronix.de>
	 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	 <alpine.LFD.2.02.1112102144370.3020@ionos>
	 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	 <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos>
	 <20111211155347.GA1297@elte.hu>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 16:53 +0100, Ingo Molnar wrote:
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

50k cycles for every single byte is pretty much as good as it will get
with serial console. See slide #5 in Marcelo's KVM Forum 2010
presentation[1] where he timed a heavyweight exit to about 40k cycles.

And I'm not sure we're taking just one of those for each byte...

I'm currently working on a patch which will let you see early boot
prints from the serial console, but switch to the virtio one when it
reaches usermode. This way you can have the best of both worlds: see
early boot and get a fast console when you've reached userspace.

[1]
http://www.linux-kvm.org/wiki/images/e/ea/2010-forum-mtosatti_walkthrough_entry_exit.pdf

-- 

Sasha.

