Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2FRQaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:30:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2FRQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:30:33 -0400
Date: Mon, 18 Jun 2012 18:30:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2 v2] regulator: support multiple dummy fixed regulators
In-Reply-To: <20120618162058.GT3974@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1206181826210.23884@axis700.grange>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
 <20120618162058.GT3974@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:wdnScsuubNgTS8/TM6zxODuqXJl6rQgeQpvcJ/DEB5s
 yVWOp08ZDP1e2ErAPyobabpqmCuqbU6RvHNCWht52gk2F5ODyK
 r106RqSVhKjN2Ts/kTdvX6w17V71LWEjj+TnM+QwSxVvwF35Rr
 6Q5i4HTDhNM6msvO17Bv1KfSNAAo+PhxbN7MGCn/RPMvo2iNh2
 x6qS3TkMuq6anhLEqieGjiqXpeFbDPMoQoY5Wlz7AJRNfljJC4
 ssd8w7C0keqvBG0ouR/2JWy2bUYzpOTHv5v3AuEoJM1N1l0+u0
 v1sbQFlv5NddY28FmtaZcngJEVHB9GHAcDE+wS+3t0+I5L2wyj
 fL3BK18kD84Ntz3YMUy2OBcc0BlbwV03Tg5XtWEHVC498wygnK
 DhYgFh4metv9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Mark Brown wrote:

> On Mon, Jun 18, 2012 at 05:57:24PM +0200, Guennadi Liakhovetski wrote:
> > Currently regulator_register_fixed() uses a constant name to register a
> > fixed dummy regulator. This is sufficient in principle, since there is no
> > reason to register multiple such regulators. The user can simply supply all
> > consumers in one array and use it to initialise such a regulator. However,
> > in some cases it can be convenient to register multiple such regulators.
> > This is also easy to achieve by appending the device ID to the name. It is
> 
> None of this seems terribly obvious to me.  Once we're getting into
> allowing the user to specify a voltage (and possibly other parameters)
> for the regulator it's hopefully going to refer to an actual thing we
> can point at on the board rather than a virtual thing we've got to
> satisfy software so giving it a useful name seems more useful (like a
> name correspoding to the relevant supply on the schematic).  

Sorry, don't understand. What do you mean by a "virtual" supply? There is 
a device, it is functional, doesn't this mean, that something is supplying 
power to it? And if power is supplied, then it also hopefully has a 
certain voltage :) Why I need to know it - to set an MMC OCR mask.

> There's also the fact that there shouldn't be any need for unique
> regulator names internally so if it really doesn't matter we should be
> able to give everything the same name happily enough.

What about entries under /proc/sys/debug/regulator/? Don't they have to be 
unique?

Thanks
Guennadi


> > also consistent with the current behaviour of the code, that fixes a name
> > itself without giving the user a possibility to provide a custom one.
> 
> This is done on the basis that it's an entirely virtual regulator which
> doesn't have any meaningful mapping into the hardware.  If it's got a
> voltage then that's no longer true.
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
