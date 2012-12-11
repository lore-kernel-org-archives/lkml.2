Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2LKWHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:07:05 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47808 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754155Ab2LKWHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:07:03 -0500
Date: Wed, 12 Dec 2012 00:06:56 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, LDOC <linux-doc@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Chris MacGregor <chris@cybermato.com>, Rob Landley <rob@landley.net>,
        Jeongtae Park <jtp.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v2] media: v4l2-ctrl: Add gain controls
Message-ID: <20121211220656.GD3747@valkosipuli.retiisi.org.uk>
References: <1354708169-1139-1-git-send-email-prabhakar.csengg@gmail.com>
 <CA+V-a8t+KxCYunkrT715zQks=5HOrFk2PSM2Ss_kTj4iXg=PJg@mail.gmail.com>
 <20121206095431.GA2887@valkosipuli.retiisi.org.uk>
 <201212110956.43081.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201212110956.43081.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tue, Dec 11, 2012 at 09:56:42AM +0100, Hans Verkuil wrote:
...
> > > > If I set both V4L2_CID_GAIN_RED and V4L2_CID_RED_OFFSET, how are they supposed
> > > > to interact? Or are they mutually exclusive?
> > > >
> > > > And if I set both V4L2_CID_GAIN_OFFSET and V4L2_CID_RED_OFFSET, how are they supposed
> > > > to interact?
> > > >
> > > > This questions should be answered in the documentation...
> > > >
> > > I haven’t worked on the hardware which supports both, What is the general
> > > behaviour when the hardware supports both per color component and global
> > > and both of them are set ? That could be helpful for me to document.
> > 
> > I'd guess most of the time only either one is supported,
> 
> Are you talking about GAIN_RED vs GAIN_RED_OFFSET or GAIN_OFFSET vs RED_OFFSET?
> Or both?

Per-component vs. global controls.

Few devices support both; AFAIR on SMIA the user can choose which one to
use, but the driver implements neither currently.

> > and when someone
> > thinks of supporting both on the same device, we can start thinking of the
> > interaction of per-component and global ones. That may be hardware specific
> > as well, so standardising it might not be possible.
> > 
> > I think it'd be far more important to know which unit is it. Many such
> > controls are indeed fixed point values but the location of the point varies.
> > For unstance, u16,u16 and u8,u8 aren't uncommon. We currently have no way to
> > tell this to the user space. This isn't in any way specific to gain or
> > offset controls, though.
> 
> There are no standardized units for gain at the moment, and I don't really see
> that happening any time soon. Fixed point isn't supported at all as a control
> type, so that will have to be converted to an integer anyway.

Do you think it'd require a new control type? There might be many; some
devices use funny fixed point values, such as u8.u5. I guess you could use
step for those, sure.

For instance, some sensors natively use lines to tell the exposure value
(and in low level sensors control the granularity really matters, so lines
it should be) whereas some SoC ones could use µs instead.

This is about units and prefixes IMO. Fixed point is just a prefix, such as
milli or micro, but instead of being a power of ten it's a power of two.

This would also allow telling the user about a gain control that e.g. the
value 0x100 means "no gain".

I think someone should write an RFC about this. :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
