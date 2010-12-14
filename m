Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab0LNO4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:56:49 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:41262 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab0LNO4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:56:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Tue, 14 Dec 2010 15:57:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: "Clemens Ladisch" <clemens@ladisch.de>, alsa-devel@alsa-project.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <4D0771CB.3020809@ladisch.de> <997f50534838eeb6a31a526e65045635.squirrel@webmail.xs4all.nl>
In-Reply-To: <997f50534838eeb6a31a526e65045635.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141557.40470.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tuesday 14 December 2010 15:51:08 Hans Verkuil wrote:
> > Laurent Pinchart wrote:
> >> On Monday 13 December 2010 17:10:51 Clemens Ladisch wrote:
> >>> TYPE_EXT describes entities that represent some interface to the
> >>> external world, TYPE_INT those that are internal to the entire device.
> >>> (I'm not sure if that distinction is very useful, but TYPE_SUBDEV seems
> >>> to be an even more meaningless name.)
> >> 
> >> SUBDEV comes from the V4L2 world, and I agree that it might not be a
> >> very good
> >> name.
> >> 
> >> I'm not sure I would split entities in internal/external categories. I
> >> would
> >> create a category for connectors though.
> > 
> > I'm not disagreeing, but what is actually the distinction between types
> > and subtypes?  ;-)
> 
> The type tells what the behavior is of an entity. E.g., type DEVNODE
> represents device node(s) in userspace, V4L2_SUBDEV represents a v4l2
> sub-device, etc. The subtype tells whether a V4L2_SUBDEV is a sensor or a
> receiver or whatever. Nice to know, but it doesn't change the way
> sub-devices work.
> 
> In the case of connectors you would create a CONNECTOR type and have a
> bunch of subtypes for all the variations of connectors.
> 
> That said, I'm not sure whether the distinction is useful for DEVNODEs.
> You do need to know the subtype in order to interpret the union correctly.
> 
> Laurent, does the MC code test against the DEVNODE type? I.e., does the MC
> code ignore the subtype of a DEVNODE, or does it always use it?

The MC code uses the DEVNODE type, ignoring the subtype, for power management. 
When a device node is opened all entities in the chain need to be powered up.

-- 
Regards,

Laurent Pinchart
