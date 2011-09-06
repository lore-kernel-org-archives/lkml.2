Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1IFOMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:12:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50846 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab1IFOMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:12:49 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "Ravi, Deepthy" <deepthy.ravi@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 6 Sep 2011 19:42:35 +0530
Subject: RE: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Thread-Topic: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Thread-Index: AcxrylGG+5M5gKRuRBiJReCxdvlFKQAqONiw
Message-ID: <19F8576C6E063C45BE387C64729E739404EC6BEE0C@dbde02.ent.ti.com>
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com>
 <201109041101.05028.laurent.pinchart@ideasonboard.com>
 <4E637DEC.5080507@infradead.org>
 <201109051449.50744.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109051449.50744.laurent.pinchart@ideasonboard.com>
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
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Monday, September 05, 2011 6:20 PM
> To: Mauro Carvalho Chehab
> Cc: Hiremath, Vaibhav; Ravi, Deepthy; linux-media@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-omap@vger.kernel.org
> Subject: Re: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
> 
> Hi Mauro,
> 
> On Sunday 04 September 2011 15:32:28 Mauro Carvalho Chehab wrote:
> > Em 04-09-2011 06:01, Laurent Pinchart escreveu:
> > > On Sunday 04 September 2011 00:21:38 Mauro Carvalho Chehab wrote:
> > >> Em 24-08-2011 10:25, Laurent Pinchart escreveu:
> > >>> On Wednesday 24 August 2011 14:19:01 Hiremath, Vaibhav wrote:
> > >>>> On Wednesday, August 24, 2011 5:00 PM Laurent Pinchart wrote:
> > >>>>> On Wednesday 24 August 2011 13:21:27 Ravi, Deepthy wrote:
> > >>>>>> On Wed, Aug 24, 2011 at 4:47 PM, Laurent Pinchart wrote:
> > >>>>>>> On Friday 19 August 2011 15:48:45 Deepthy Ravi wrote:
> > >>>>>>>> From: Vaibhav Hiremath <hvaibhav@ti.com>
> > >>>>>>>>
> > >>>>>>>> Fix the build break caused when CONFIG_MEDIA_CONTROLLER
> > >>>>>>>> option is disabled and if any sensor driver has to be used
> > >>>>>>>> between MC and non MC framework compatible devices.
> > >>>>>>>>
> > >>>>>>>> For example,if tvp514x video decoder driver migrated to
> > >>>>>>>> MC framework is being built without CONFIG_MEDIA_CONTROLLER
> > >>>>>>>> option enabled, the following error messages will result.
> > >>>>>>>> drivers/built-in.o: In function `tvp514x_remove':
> > >>>>>>>> drivers/media/video/tvp514x.c:1285: undefined reference to
> > >>>>>>>> `media_entity_cleanup'
> > >>>>>>>> drivers/built-in.o: In function `tvp514x_probe':
> > >>>>>>>> drivers/media/video/tvp514x.c:1237: undefined reference to
> > >>>>>>>> `media_entity_init'
<snip>
> I don't mind splitting the config option. An alternative would be to
> compile
> media_entity_init() and media_entity_cleanup() based on
> CONFIG_MEDIA_SUPPORT
> instead of CONFIG_MEDIA_CONTROLLER, but that looks a bit hackish to me.
> 
> > Also, I don't like the idea of increasing drivers complexity for the
> > existing drivers that work properly without MC. All those core
> conversions
> > that were done in the last two years caused already too much instability
> > to them.
> >
> > We should really avoid touching on them again for something that won't
> be
> > adding any new feature nor fixing any known bug.
> 
> We don't have to convert them all in one go right now, we can implement
> pad-
> level operations support selectively when a subdev driver becomes used by
> an
> MC-enabled host/bridge driver.
> 
[Hiremath, Vaibhav] I completely agree that we should not be duplicating the code just for sake of it.

Isn't the wrapper approach seems feasible here? 

Thanks,
Vaibhav

> > > This will result in no modification to the userspace.
> 
> --
> Regards,
> 
> Laurent Pinchart
