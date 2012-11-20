Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2KTHzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:55:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KTHzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:55:50 -0500
Date: Tue, 20 Nov 2012 08:55:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
In-Reply-To: <20121120004356.GC4483@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1211200840590.21420@axis700.grange>
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
 <Pine.LNX.4.64.1211190900110.11024@axis700.grange>
 <20121120004356.GC4483@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:0D69ejh9X+bc2dH2y4WNDiPDWOysaMrgIt1YAKjvd4O
 GeP0ZJnkxddolO8qN/Z+JJ5PGJj8Df1enA1Y27cs7+scCDvk5e
 0ivkNS5w50DafKfRBqGUFhpiqLNxAwutuwziJmt1RpbQ+xExli
 0TSxLao5Tu1W3YD+60lM5QbtdILsGFeJd5aVkHO9WCf7Wdzq1p
 fLhhMvLAUtu2jgTMI2aFoyZVCg5jn04AHP9R9OYhYyClvlbQ8F
 ES48Go1ieqJ6u2dgb7xxDUg5uvgPeYjwREfkg0TjfDDes8RAu4
 7I5rrUfqhYtesZgaGBCylTOBO9O7W93PKAitXOyUCjho72MsNx
 qd3KAvSCMHlOjmefkKf5c5BSLLLYjCHfRH+lTxTIhh9Fu0ZLUe
 qeCVvAiu1qlQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012, Mark Brown wrote:

> On Mon, Nov 19, 2012 at 11:52:42AM +0100, Guennadi Liakhovetski wrote:
> 
> > Thanks for submitting this driver! The notion of DVS regulators was new to 
> > me, so, I checked http://www.ti.com/lit/an/sbva020/sbva020.pdf for a short 
> > description. After that I had a look at a couple of existing DVS regulator 
> 
> Do you just mean regulators that have a quick voltage change ability/

Yes, regulators with an input pin, that can be used to switch output 
voltage on one of outputs.

> > drivers in the tree. Well, I came to two conclusions so far: (1) The 
> > current regulator API is not very well suitable for such regulators. I 
> > would imagine, one would need two methods: for setting the "normal" and 
> > the DVS voltage. Instead of this drivers are trying to be smart at 
> > guessing, which voltage the user is trying to set now... (2) Drivers do 
> > this in different ways and at least out of the 2 drivers I looked at both 
> > have bugs and different ones at that. I'll send a separate email, 
> > describing what I found suspicious in them.
> 
> The thing I'd like to see factored out here is the LRU mechanism,
> otherwise I think the situation is pretty good.  Some of the older
> devices should use a different scheme to modern ones as the hardware
> they have to interoperate is different.

So, do you consider the LRU algorithm to be the preferred way to configure 
such regulators? I realise that in practice it will work well in most 
cases, usually users do only want to preconfigure such a regulator to 2 
fixed voltages and switch between them at runtime, right? OTOH, do you 
think it is too unlikely, that someone will want to switch, say, between 3 
voltages: X-Y-Z-X-Y-Z-X...? In this case the LRU will just lead to 
constantly reprogramming the regulator. Whereas if the user had a way to 
say "configure context A to X," "B to Y," and then only reprogram B 
between voltages Y and Z, we'd save 1/3 of re-configuration accesses? 
Maybe even in some such case, quickly switching to voltage X is more 
important than to voltage Y or Z.

> > Of course, all the above was just my DVS-newbie impression, which can very 
> > well be absolutely wrong.
> > 
> > > 
> > > Add regulator driver for this device.
> 
> *ALWAYS* delete irrelevant text when replying.

Not sure what you mean, sorry. If you mean all the text, that followed the 
above line, then it wasn't all irrelevant, there were more comments down 
there. OTOH, if you just meant, that I could have deleted even more text, 
than what I've done, then right, sorry, there's always a balance between 
deleting too little and too much, and the decision is subjective. I 
usually tend to keep somewhat more, tnan most would consider required, I 
think, it is easier to hit "Page Down" a couple more times, than to have 
to guess what the missing context was. But I'll try to reduce unneeded 
context next time.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
