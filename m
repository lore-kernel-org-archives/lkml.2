Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab2IKOcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:32:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2IKOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:32:12 -0400
Date: Tue, 11 Sep 2012 16:31:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 04/16] ARM: imx: move platform_data definitions
In-Reply-To: <201209111410.05698.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1209111624240.22084@axis700.grange>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-4-git-send-email-arnd@arndb.de>
 <Pine.LNX.4.64.1209111538000.22084@axis700.grange> <201209111410.05698.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:5mMwG/MiNlRs7LOv7P4QoqV/dm5GQoRr4K7HCUw03Aq
 WxQDq/rAVLUZidnBqnJhhxaB2ESdryv1J/WzFac79q6z1r8dAz
 kddWqkBkX6AebWm/aG0fnLhW1O0Z8eUZDJTHusBhS1oAxDWDJ4
 AmbeZF2dJFAdkFCQc3Naj2cPSkNq9g3imqjF7tD5qAWowpfOG4
 XFtUgYDdlhtI5Kck4SZxz3sGxL9xYvFWJqhuwSNodx6JhZSlEb
 CIa4wwmXSy9qZYEHxqxityuApfHbOjL5ojkyywlJk6VseIXgi8
 Y/GqU67cUBLBaJxYd31U/S71Nj7o+MPwhTbSTyEgtw1Oqg38Im
 EdvvGpu5ZLIHtim94diTxEcCKHdZJhQKSZVacj67BrsOf/C71y
 aAVwxTlIvISWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Arnd Bergmann wrote:

> On Tuesday 11 September 2012, Guennadi Liakhovetski wrote:
> > Hi Arnd
> > 
> > It probably wouldn't be very difficult to also include 
> > arch/arm/plat-mxc/include/mach/ipu.h in this your patch, but you can also 
> > leave it for later. Just to make sure it's not something that would make 
> > your future patching more complicated.
> > 
> 
> For now, I've done only the straight renames but left the ones that looked
> like they need more complex changes of any sort. Looking at ipu.h, it seems
> that this header file defines data that is used inside of the driver but not
> in the platform device definition, so we'd need to split it up and move
> the part that is only used inside of the driver into a different place.
> 
> Of course, I could alo be mistaken and not have realized that actually all
> of this file is platform data.

ipu.h is used by the dmaengine and IRQ driver under drivers/dma/ipu/, and 
by its users drivers/media/platform/soc_camera/mx3_camera.c and 
drivers/video/mx3fb.c. It has been placed under arch/arm/... because it's 
arch-specific, but in principle I don't see any reason why it cannot 
happily live anywhere under include/...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
