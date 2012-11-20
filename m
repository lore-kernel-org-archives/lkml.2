Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2KTIXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:23:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52287 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KTIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:23:45 -0500
Date: Tue, 20 Nov 2012 09:23:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
In-Reply-To: <20121120080805.GU10560@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1211200921190.21420@axis700.grange>
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
 <Pine.LNX.4.64.1211190900110.11024@axis700.grange>
 <20121120004356.GC4483@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1211200840590.21420@axis700.grange>
 <20121120080805.GU10560@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ywdvRGXh0RqLO8jDjWKu6iXKFc7h4WOZHihtbsNKbxb
 BTDebpEzfRyXJaD6pf/eRxFWUtlKZsQdr0GVBs3nO334ZW438d
 ei6qeiybozjKjNXgI+LQN0bePVBUIXJSATzhj6FjzQZEwOKuU/
 Pe6FicJ/yvA5OXnFfHcNuXd3odat8lm31BimEIUmnAVq5FvE4T
 IZrkKvoaPRQ+VD6CXLF9xFL3tTB57AOFP85A+wxJgFhVU70umg
 383PdFfG4zreh0kpyG/5HskrG5LrDbw/PNEr2ib4t0NW/uAdUX
 pAbN0pyEVP+1B6objVsjXnGhLfyPEYGkEvrxyW8UReB2E+6vuj
 6PQ+e9zMMt186FeHj4MuTlLakptZpC6S1dMfMdrLGu/VR1vUGN
 dTg1qpC2mbqUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012, Mark Brown wrote:

> On Tue, Nov 20, 2012 at 08:55:47AM +0100, Guennadi Liakhovetski wrote:
> > On Tue, 20 Nov 2012, Mark Brown wrote:
> 
> > > The thing I'd like to see factored out here is the LRU mechanism,
> > > otherwise I think the situation is pretty good.  Some of the older
> > > devices should use a different scheme to modern ones as the hardware
> > > they have to interoperate is different.
> 
> > So, do you consider the LRU algorithm to be the preferred way to configure 
> > such regulators? I realise that in practice it will work well in most 
> 
> Well, there's not really many other options.
> 
> > cases, usually users do only want to preconfigure such a regulator to 2 
> > fixed voltages and switch between them at runtime, right? OTOH, do you 
> > think it is too unlikely, that someone will want to switch, say, between 3 
> > voltages: X-Y-Z-X-Y-Z-X...? In this case the LRU will just lead to 
> > constantly reprogramming the regulator. Whereas if the user had a way to 
> > say "configure context A to X," "B to Y," and then only reprogram B 
> > between voltages Y and Z, we'd save 1/3 of re-configuration accesses? 
> > Maybe even in some such case, quickly switching to voltage X is more 
> > important than to voltage Y or Z.
> 
> Modern devices tend to use multiple GPIOs for this control for a jolly
> good reason.  If you've only got two levels then the wm831x algorithm is
> probably the most sensible.

Ok, I see, but other my comments still hold.

> > > > > Add regulator driver for this device.
> 
> > > *ALWAYS* delete irrelevant text when replying.
> 
> > Not sure what you mean, sorry. If you mean all the text, that followed the 
> > above line, then it wasn't all irrelevant, there were more comments down 
> > there. OTOH, if you just meant, that I could have deleted even more text, 
> > than what I've done, then right, sorry, there's always a balance between 
> 
> I actually thought you'd just quoted the entire mail and just deleted
> the rest after a couple of screenfuls so a bit of both.  
> 
> > deleting too little and too much, and the decision is subjective. I 
> > usually tend to keep somewhat more, tnan most would consider required, I 
> > think, it is easier to hit "Page Down" a couple more times, than to have 
> > to guess what the missing context was. But I'll try to reduce unneeded 
> > context next time.
> 
> The extra content is profoundly unhelpful to people reading on phones,
> and to people on slow connections (I spend an awful lot of time in
> hotels with dodgy internet access for example).  It also (as happened to
> me) makes it hard to find new comments in the middle of reams of stuff
> you're paging down through.

Understand.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
