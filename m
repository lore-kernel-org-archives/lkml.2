Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1I1GK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:10:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46444 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1I1GK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:10:57 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Ravi, Deepthy" <deepthy.ravi@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Date: Wed, 28 Sep 2011 11:40:19 +0530
Subject: RE: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
Thread-Topic: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
Thread-Index: Acx9QDK7jnWdYEf8TJGLYmcRC1pAMwAY/l3w
Message-ID: <19F8576C6E063C45BE387C64729E739404ECA54C58@dbde02.ent.ti.com>
References: <1315488922-16152-1-git-send-email-deepthy.ravi@ti.com>
 <201109161506.16505.laurent.pinchart@ideasonboard.com>
 <19F8576C6E063C45BE387C64729E739404EC8113E2@dbde02.ent.ti.com>
 <201109272006.30130.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109272006.30130.laurent.pinchart@ideasonboard.com>
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
> Sent: Tuesday, September 27, 2011 11:36 PM
> To: Hiremath, Vaibhav
> Cc: Ravi, Deepthy; linux-media@vger.kernel.org; tony@atomide.com;
> linux@arm.linux.org.uk; linux-omap@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> mchehab@infradead.org; g.liakhovetski@gmx.de
> Subject: Re: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
> 
> Hi Vaibhav,
> 
> On Monday 19 September 2011 17:31:02 Hiremath, Vaibhav wrote:
> > On Friday, September 16, 2011 6:36 PM Laurent Pinchart wrote:
> > > On Friday 16 September 2011 15:00:53 Ravi, Deepthy wrote:
> > > > On Thursday, September 08, 2011 10:51 PM Laurent Pinchart wrote:
> > > > > On Thursday 08 September 2011 15:35:22 Deepthy Ravi wrote:
> > > > >> From: Vaibhav Hiremath <hvaibhav@ti.com>
> > > > >>
> > > > >> In order to support TVP5146 (for that matter any video decoder),
> > > > >> it is important to support G/S/ENUM_STD ioctl on /dev/videoX
> > > > >> device node.
> > > > >
> > > > > Why so ? Shouldn't it be queried on the subdev output pad
> directly ?
> > > >
> > > > Because standard v4l2 application for analog devices will call these
> > > > std ioctls on the streaming device node. So it's done on /dev/video
> to
> > > > make the existing apllication work.
> > >
> > > Existing applications can't work with the OMAP3 ISP (and similar
> complex
> > > embedded devices) without userspace support anyway, either in the form
> of
> > > a GStreamer element or a libv4l plugin. I still believe that analog
> video
> > > standard operations should be added to the subdev pad operations and
> > > exposed through subdev device nodes, exactly as done with formats.
> >
> > I completely agree with your point that, existing application will not
> work
> > without setting links properly. But I believe the assumption here is,
> > media-controller should set the links (along with pad formants) and all
> > existing application should work as is. Isn't it?
> 
> The media controller is an API used (among other things) to set the links.
> You
> still need to call it from userspace. That won't happen magically. The
> userspace component that sets up the links and configures the formats, be
> it a
> GStreamer element, a libv4l plugin, or something else, can as well setup
> the
> standard on the TVP5146 subdev.
> 
Please look at from analog device point of view which is interfaced to ISP.

OMAP3 ISP => TVP5146 (video decoder)

As a user I would want to expect the standard to be supported on streaming device node, since all standard streaming applications (for analog devices/interfaces) does this.

Setting up the links and format is still something got added with MC framework, and I would consider it as a separate plug-in along with existing applications.

Why do I need to write/use two different streaming application one for MC compatible device and another for non-MC?

> > The way it is being done currently is, set the format at the pad level
> > which is same as analog standard resolution and use existing application
> > for streaming...
> 
> At then end of the OMAP3 ISP pipeline video data has long lost its analog
> roots. I don't think standards make sense there.
> 
I don't agree with you here, I think we made it clear when we started with MC development activity, we will not break existing standard applications. Media-controller will play a roll to setup the links, connecting the pads and stuff.


Thanks,
Vaibhav

> > I am ok, if we add s/g/enum_std api support at sub-dev level but this
> > should also be supported on streaming device node.
> 
> --
> Regards,
> 
> Laurent Pinchart
