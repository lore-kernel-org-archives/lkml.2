Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1LKKch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 05:32:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1LKKce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 05:32:34 -0500
Date: Sun, 11 Dec 2011 11:30:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111211103047.GA19299@elte.hu>
References: <20111210132220.083204833@linutronix.de>
 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
 <alpine.LFD.2.02.1112102144370.3020@ionos>
 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> On Sat, 10 Dec 2011, Thomas Gleixner wrote:
>
> > There is a slight problem with them. I only tested them with 
> > the rt-guest kernels, but non rt kernels are slightly 
> > unhappy. Sorry for not thinking about that.
> >
> > Fix below.
> 
> Applied, thanks!
> 
> Ingo, how does serial console work for you with latest master? 
> It's likely that Thomas' patches fix top slowness for you.

It didnt get worse - but i can still easily tell apart a 'top' 
running under kvm than native. Try something like this:

 run top and type 's0.1<enter>' to change the refresh interval 
 to 100 msecs.

Run the same thing under kvm and on the native host. The two are 
visibly different: the kvm one refreshes with the cursor showing 
up mid-refresh a number of times.

In theory a kvm driven serial console should be extremely fast, 
much faster than a real serial console, basically as fast as a 
local console. Yet this still does not seem to be the case.

In fact even ssh-ing in to a box over Wifi and running the above 
top session is undistinguishable from top running in a local 
console. So IMO it cannot be virtualization overhead - there 
must still be some delay or serious lack of buffering somewhere.

Here's a way to measure the slowdown directly:

  time top -d 0.01 -n 10 -b

         native: 0.9 secs
  ssh over wifi: 1.4 secs
     kvm serial: 5.0 secs

Thanks,

	Ingo
