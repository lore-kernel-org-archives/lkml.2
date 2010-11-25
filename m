Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0KYPka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:40:30 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:50262 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0KYPk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:40:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Thu, 25 Nov 2010 16:40:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290652099-15102-4-git-send-email-laurent.pinchart@ideasonboard.com> <20101125133650.GA24208@opensource.wolfsonmicro.com>
In-Reply-To: <20101125133650.GA24208@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011251640.42206.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thursday 25 November 2010 14:36:50 Mark Brown wrote:
> On Thu, Nov 25, 2010 at 03:28:10AM +0100, Laurent Pinchart wrote:
> > +Links have flags that describe the link capabilities and state.
> > 
> > +	MEDIA_LINK_FLAG_ACTIVE indicates that the link is active and can be
> > +	used to transfer media data. When two or more links target a sink pad,
> > +	only one of them can be active at a time.
> 
> Is this supposed to reflect the current state (if the link is carrying
> data right now) or if it's possible for the link to carry data?

It's supposed to reflect whether the link can carry data. Think of the active 
flag as a valve on a pipe. If the valve is open, the link is active. If the 
valve is closed, the link is inactive. This is unrelated to whether water 
actually flows through the pipe.

Immutable links have no valve (in theory you could have an inactive immutable 
link, but that's not very useful, unless we define immutable as no user-
controllable valve, in which case it might be better to rename it as read-
only, or create separate immutable and read-only flags - just brainstorming 
here).

> > +struct media_entity {
> > +	struct list_head list;
> > +	struct media_device *parent;	/* Media device this entity belongs to*/
> > +	u32 id;				/* Entity ID, unique in the parent media
> > +					 * device context */
> > +	const char *name;		/* Entity name */
> > +	u32 type;			/* Entity type (MEDIA_ENTITY_TYPE_*) */
> > +	u32 revision;			/* Entity revision, driver specific */
> > +	unsigned long flags;		/* Entity flags (MEDIA_ENTITY_FLAG_*) */
> > +	u32 group_id;			/* Entity group ID */
> > +
> > +	u16 num_pads;			/* Number of input and output pads */
> > +	u16 num_links;			/* Number of existing links, both active
> > +					 * and inactive */
> > +	u16 num_backlinks;		/* Number of backlinks */
> > +	u16 max_links;			/* Maximum number of links */
> > +
> > +	struct media_pad *pads;		/* Pads array (num_pads elements) */
> > +	struct media_link *links;	/* Links array (max_links elements)*/
> 
> Hrm.  This is getting kind of large, especially considering the volume
> of data we're holding per node and link already in ASoC.  On the other
> hand we may over time be able to refactor some of the existing stuff
> (especially the link management) to use this structure.

That's the idea :-) In the long term (hopefully not that long) I would like to 
see both sources of information merged. That's why I'm interested in your 
requirements to make sure this will be possible.

-- 
Regards,

Laurent Pinchart
