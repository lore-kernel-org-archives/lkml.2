Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab0LNXtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:49:51 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:49432 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab0LNXtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:49:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Wed, 15 Dec 2010 00:50:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: Hans Verkuil <hverkuil@xs4all.nl>, alsa-devel@alsa-project.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012141353.15749.laurent.pinchart@ideasonboard.com> <4D0775DB.2020902@ladisch.de>
In-Reply-To: <4D0775DB.2020902@ladisch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012150050.44885.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

On Tuesday 14 December 2010 14:49:15 Clemens Ladisch wrote:
> Laurent Pinchart wrote:
> > On Tuesday 14 December 2010 13:40:21 Hans Verkuil wrote:
> >> > On Monday 13 December 2010 17:10:51 Clemens Ladisch wrote:
> >> >> * Entity types
> >> >> 
> >> >> TYPE_NODE was renamed to TYPE_DEVICE because "node" sounds like a
> >> >> node in a graph, which does not distinguish it from other entity
> >> >> types because all entities are part of the topology graph.  I chose
> >> >> "device" as this type describes entities that are visible as some
> >> >> device node to other software.
> >> > 
> >> > What this type describes is a device node. Both NODE and DEVICE can be
> >> > confusing in my opinion, but DEVICE_NODE is a bit long.
> >> 
> >> What about DEVNODE? I think that would be a good alternative.
> > 
> > Fine with me. Clemens, any opinion on that ?
> 
> Fine with me too.

OK I'll use that name.

> > > >> TYPE_EXT describes entities that represent some interface to the
> > > >> external world, TYPE_INT those that are internal to the entire
> > > >> device. (I'm not sure if that distinction is very useful, but
> > > >> TYPE_SUBDEV seems to be an even more meaningless name.)
> > > > 
> > > > SUBDEV comes from the V4L2 world, and I agree that it might not be a
> > > > very good name.
> > > 
> > > SUBDEV refers to a specific type of driver. Within the v4l world it is
> > > well defined. So I prefer to keep this. Perhaps some additional
> > > comments or documentation can be added to clarify this.
> > 
> > Should this be clarified by using V4L2_SUBDEV instead then ?
> 
> If the "SUBDEV" concept doesn't exist outside V4L, that would indeed be
> better.
> 
> I don't want to rename things that come out of existing frameworks; this
> naming discussion makes sense only for those entity (sub)types that can
> be shared between them.  Are there any, besides jacks?

Some entities like TV tuners play a dual audio/video role. I'm not sure how to 
handle them, I lack experience in that field.

> > What about ALSA entities, should they use MEDIA_ENTITY_TYPE_ALSA_* ?
> 
> The entity types representing ALSA devices are already named "ALSA".

I was talking about the INT_* types. They're ALSA-specific, but have no ALSA 
in the type name.

-- 
Regards,

Laurent Pinchart
