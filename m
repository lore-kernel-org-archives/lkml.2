Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1LTBxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:53:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51044 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab1LTBxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:53:21 -0500
Date: Tue, 20 Dec 2011 01:53:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v4 3/4] regulator: simplify twl4030 config
Message-ID: <20111220015316.GW2860@opensource.wolfsonmicro.com>
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
 <1324343717-7292-4-git-send-email-felipe.contreras@gmail.com>
 <20111220011923.GS2860@opensource.wolfsonmicro.com>
 <CAMP44s1XFo0_O-pGMNO7m=weXuCpXzS8oH6m6PaPNzLGRQpDgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s1XFo0_O-pGMNO7m=weXuCpXzS8oH6m6PaPNzLGRQpDgA@mail.gmail.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 03:36:59AM +0200, Felipe Contreras wrote:
> On Tue, Dec 20, 2011 at 3:19 AM, Mark Brown

> > No, this is the wrong way to go about this - why are you making this
> > change for this one driver only?

> Because that's the only one I care about. I can try to do the same for
> all the others if you wish.

Yes, of course.  Half the point in having subsystems and standard ways
of doing things is so that when we look at things we've got a reasonable
idea as to what they're supposed to be doing and people looking at the
code can figure out what's going on.   We don't want people to have to
play guessing games about this stuff.

> > Exactly the same argument would apply
> > to all the other MFD regulators and to all the other MFD subdrivers in
> > the various subsystems.

> Yes, the ones that closely related to certain architectures or chips.

Obviously all MFDs are closely releated to chips...

> And this is already done:
> 
> REGULATOR_AB3100:
> 	depends on AB3100_CORE
> 	default y if AB3100_CORE

> (if AB3100_CORE is redundant BTW)

> REGULATOR_TPS6105X:
> 	depends on TPS6105X
> 	default y if TPS6105X

So it's done by a small proportion of drivers...
