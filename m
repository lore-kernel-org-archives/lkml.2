Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab1HXNUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:20:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54347 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab1HXNT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:19:58 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Ravi, Deepthy" <deepthy.ravi@ti.com>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 24 Aug 2011 18:49:46 +0530
Subject: RE: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Thread-Topic: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Thread-Index: AcxiXTpG8nltpraTRtWRLSWsO7YZlgAAy7jA
Message-ID: <19F8576C6E063C45BE387C64729E739404EC007C25@dbde02.ent.ti.com>
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com>
	 <201108241217.11430.laurent.pinchart@ideasonboard.com>
	 <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D0907F6@dbde03.ent.ti.com>
	 <201108241329.48147.laurent.pinchart@ideasonboard.com>
	 <19F8576C6E063C45BE387C64729E739404EC007BE3@dbde02.ent.ti.com>
 <1314190538.9124.29.camel@smile>
In-Reply-To: <1314190538.9124.29.camel@smile>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Andy Shevchenko [mailto:andriy.shevchenko@linux.intel.com]
> Sent: Wednesday, August 24, 2011 6:26 PM
> To: Hiremath, Vaibhav
> Cc: Laurent Pinchart; Ravi, Deepthy; mchehab@infradead.org; linux-
> media@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> omap@vger.kernel.org
> Subject: RE: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
> 
> > > > >> Fix the build break caused when CONFIG_MEDIA_CONTROLLER
> > > > >> option is disabled and if any sensor driver has to be used
> > > > >> between MC and non MC framework compatible devices.
> > > > >>
> > > > >> For example,if tvp514x video decoder driver migrated to
> > > > >> MC framework is being built without CONFIG_MEDIA_CONTROLLER
> > > > >> option enabled, the following error messages will result.
> > > > >> drivers/built-in.o: In function `tvp514x_remove':
> > > > >> drivers/media/video/tvp514x.c:1285: undefined reference to
> > > > >> `media_entity_cleanup'
> > > > >> drivers/built-in.o: In function `tvp514x_probe':
> > > > >> drivers/media/video/tvp514x.c:1237: undefined reference to
> > > > >> `media_entity_init'
> > > > >
> > > > > If the tvp514x is migrated to the MC framework, its Kconfig option
> > > should
> > > > > depend on MEDIA_CONTROLLER.
> > > >
> > > > The same TVP514x driver is being used for both MC and non MC
> compatible
> > > > devices, for example OMAP3 and AM35x. So if it is made dependent on
> > > MEDIA
> > > > CONTROLLER, we cannot enable the driver for MC independent devices.
> > >
> > > Then you should use conditional compilation in the tvp514x driver
> itself.
> > > Or
> > [Hiremath, Vaibhav] No. I am not in favor of conditional compilation in
> driver code.
> >
> > > better, port the AM35x driver to the MC API.
> > >
> > [Hiremath, Vaibhav]
> > Why should we use MC if I have very simple device (like AM35x) which
> only supports single path? I can very well use simple V4L2 sub-dev based
> approach (master - slave), isn't it?
> Why should you break the API in unappropriated way?
[Hiremath, Vaibhav] Can you explain? 

Thanks,
Vaibhav

> 
> The patch is NACK, obviously.
> 
> --
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy
