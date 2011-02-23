Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1BWChy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:37:54 -0500
Received: from relais.videotron.ca ([24.201.245.36]:16707 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab1BWChx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:37:53 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 22 Feb 2011 21:37:28 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Dima Zavin <dima@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        tsoni@codeaurora.org, linux-arm-msm@vger.kernel.org,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
In-reply-to: <8ya62sbli3z.fsf@huya.qualcomm.com>
Message-id: <alpine.LFD.2.00.1102222049410.22028@xanadu.home>
References: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
 <1297989432.9680.50.camel@c-dwalke-linux.qualcomm.com>
 <4D5DC289.1090004@codeaurora.org>
 <1298054771.17758.1.camel@c-dwalke-linux.qualcomm.com>
 <AANLkTi=0Pxg09x8DdVDVy9Ur7r1dgB+4LM3q0hM4_8Rg@mail.gmail.com>
 <1298419839.17118.5.camel@m0nster> <8ya62sbli3z.fsf@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, David Brown wrote:

> On Tue, Feb 22 2011, Daniel Walker wrote:
> 
> > On Tue, 2011-02-22 at 12:47 -0800, Dima Zavin wrote:
> >
> >> What is the problem leaving it under arch/arm/mach-msm?
> >
> > Because it's a driver.
> 
> There are a lot of other drivers currently under various arch
> subsystems.  

And they are wrong.  Probably because of some historical reasons.

> I'm not sure if a driver that is specific to only one arch
> has a strong reason to be elsewhere in the kernel.

You'll find plenty of examples for that, far more than drivers in arch 
specific directories.

> If there was a possibility of there being other devices that used 
> SSBI, it might make sense to put it elsewhere.  But, as far as I know, 
> this device is only found on MSM chips.

That doesn't matter.

The main reasoning is that Linux has no stable internal API by design. 
When large scale driver API changes happen, it is the responsibility of 
the person doing that change to also fix up all the in-tree users of 
that API.  And it is far more trouble for that person who probably has 
no knowledge about msm to go and hunt for all scattered drivers 
throughout the tree than it is for you to remember that all your drivers 
are under linux/drivers/.

And if someone else comes up with a SSBI interface, then it will be much 
easier to notice the already existing driver if it is in the driver 
directory rather than somewhere else in some unrelated (from that 
person's pov) obscure directory.

This was discussed in the past already.  I would have liked to provide a 
link to some archived discussions (they do exist) but I can't find them 
at the moment.

> It seems kind of unusual to create an entirely new directory under
> drivers to hold what will only ever be a single driver.

Well, a couple examples exist already: drivers/dca, drivers/nfc, 
drivers/sn, drivers/tc, drivers/vlynq, etc.  And if you expect to have 
more oddball msm drivers then you can create a drivers/msm directory, 
similar to the existing drivers/macintosh, drivers/parisc, drivers/s390, 
drivers/sh, drivers/video/omap, drivers/video/omap2, etc.


Nicolas
