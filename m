Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1LKPzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 10:55:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab1LKPzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 10:55:33 -0500
Date: Sun, 11 Dec 2011 16:53:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111211155347.GA1297@elte.hu>
References: <20111210132220.083204833@linutronix.de>
 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
 <alpine.LFD.2.02.1112102144370.3020@ionos>
 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
 <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112111459270.3020@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 11 Dec 2011, Ingo Molnar wrote:

> > In theory a kvm driven serial console should be extremely 
> > fast, much faster than a real serial console, basically as 
> > fast as a local console. Yet this still does not seem to be 
> > the case.
> > 
> > In fact even ssh-ing in to a box over Wifi and running the 
> > above top session is undistinguishable from top running in a 
> > local console. So IMO it cannot be virtualization overhead - 
> > there must still be some delay or serious lack of buffering 
> > somewhere.
> 
> Well, the difference between ssh and serial is, that ssh can 
> pack 1.5k worth of data into one frame, while serial has to 
> send it piecewise. And the emulation has to trap into kvm tool 
> for each tx byte, which doesnt help either. We cannot do much 
> with buffering on the kvm tool side as we have no clue how 
> much consecutive data will come in. That's why there is a 
> virtual console, which has the disadvantage that you cant see 
> the early boot messages.

Okay, but look at it from another angle: the top output i 
generate is about 300k characters. 5000 msecs to execute it 
means 16 usecs overhead per character - or about 50k cycles - on 
a top of the class x86 CPU.

50k cycles for every single byte. And as a user i notice that 
first hand.

Thanks,

	Ingo
