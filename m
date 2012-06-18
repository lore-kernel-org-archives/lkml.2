Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab2FRRNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:13:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2FRRNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:13:08 -0400
Date: Mon, 18 Jun 2012 19:13:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2 v2] regulator: support multiple dummy fixed regulators
In-Reply-To: <20120618163758.GU3974@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1206181850280.23884@axis700.grange>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
 <20120618162058.GT3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181826210.23884@axis700.grange>
 <20120618163758.GU3974@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:F3J84up9q/LqiT9Cj2nS7338IgXanPupON+A/gvnF7F
 joie4O7zY5zqvILBcfXqrYWWpxdSaeeaa+P3b3xUBsd7w5CUiZ
 1T5qb2Wt6wDfkbvEG7CKApJU1buiUP5AaEqMOsENeWV7GoDzS1
 f8ssTwD5IphfC8AQ2SQriQ74N26juKx71iaAWxpTRwailmxUry
 T7LeD+/jcMYZlmogzdjooYV/n2H7fq19MkKVL9iUBfq+TSClPf
 tUM4V1QJlMSCH6HkNcjI34MpZlr5XL9tuM70iuztc1QdzuKezE
 zmIsRIMHuosmbzsks9KH+HPKE/iFkB9q2IwcuLUIW8eQUa/tKV
 T0xHLP4B7DhCf7NFLcWBkPib+zNRk+qyOr9i+Jt+d2+wp9gkqa
 8VdwvQczXz07w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Mark Brown wrote:

> On Mon, Jun 18, 2012 at 06:30:30PM +0200, Guennadi Liakhovetski wrote:
> > On Mon, 18 Jun 2012, Mark Brown wrote:
> 
> > > None of this seems terribly obvious to me.  Once we're getting into
> > > allowing the user to specify a voltage (and possibly other parameters)
> > > for the regulator it's hopefully going to refer to an actual thing we
> > > can point at on the board rather than a virtual thing we've got to
> > > satisfy software so giving it a useful name seems more useful (like a
> > > name correspoding to the relevant supply on the schematic).  
> 
> > Sorry, don't understand. What do you mean by a "virtual" supply? There is 
> > a device, it is functional, doesn't this mean, that something is supplying 
> > power to it? And if power is supplied, then it also hopefully has a 
> > certain voltage :) Why I need to know it - to set an MMC OCR mask.
> 
> It's for cases where people can't be bothered to specify the supply
> properly but want to just put something in there to satisfy the sofware
> without providing any useful information.  There will be one or more
> physical supplies but the software is being non-committal about them.

Ok, but for that purpose I thought we already have the dummy regulator... 
So, what's the proper way to describe board common voltage rails? 
Obviously you don't want to disable and enable them. Of course, there are 
real physical regulators, that provide that voltage, but what does it 
change, whether we specify the real name of that device or just say - yes, 
we have 3.3V on this board? So, it IS just a fixed regulator with a fixed 
voltage with no way to control it. The only action you can perform with it 
is query the voltage.

> > > There's also the fact that there shouldn't be any need for unique
> > > regulator names internally so if it really doesn't matter we should be
> > > able to give everything the same name happily enough.
> 
> > What about entries under /proc/sys/debug/regulator/? Don't they have to be 
> > unique?
> 
> Meh, yes.  I did try to make them readable.  But then making up the
> names in this fashion does rather defeat the point there...

Ok, what shall we do with this? You want the user to supply a name for 
these fixed voltage always-on regulators? Or you're against these changes 
altogether? Strictly speaking, these patches are not required for boards 
to implement such regulators. It is "just" a helper function. But I think 
the task is pretty common - provide a power supply with a fixed queryable 
voltage. This can easily be implemented as a helper function in regulator 
core, or platforms will have to re-invent it themselves.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
