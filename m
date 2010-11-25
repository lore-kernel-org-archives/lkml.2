Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0KYNgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:36:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37048 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752338Ab0KYNgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:36:43 -0500
Date: Thu, 25 Nov 2010 13:36:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
Message-ID: <20101125133650.GA24208@opensource.wolfsonmicro.com>
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1290652099-15102-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290652099-15102-4-git-send-email-laurent.pinchart@ideasonboard.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 03:28:10AM +0100, Laurent Pinchart wrote:

> +Links have flags that describe the link capabilities and state.

> +	MEDIA_LINK_FLAG_ACTIVE indicates that the link is active and can be
> +	used to transfer media data. When two or more links target a sink pad,
> +	only one of them can be active at a time.

Is this supposed to reflect the current state (if the link is carrying
data right now) or if it's possible for the link to carry data?

> +struct media_entity {
> +	struct list_head list;
> +	struct media_device *parent;	/* Media device this entity belongs to*/
> +	u32 id;				/* Entity ID, unique in the parent media
> +					 * device context */
> +	const char *name;		/* Entity name */
> +	u32 type;			/* Entity type (MEDIA_ENTITY_TYPE_*) */
> +	u32 revision;			/* Entity revision, driver specific */
> +	unsigned long flags;		/* Entity flags (MEDIA_ENTITY_FLAG_*) */
> +	u32 group_id;			/* Entity group ID */
> +
> +	u16 num_pads;			/* Number of input and output pads */
> +	u16 num_links;			/* Number of existing links, both active
> +					 * and inactive */
> +	u16 num_backlinks;		/* Number of backlinks */
> +	u16 max_links;			/* Maximum number of links */
> +
> +	struct media_pad *pads;		/* Pads array (num_pads elements) */
> +	struct media_link *links;	/* Links array (max_links elements)*/

Hrm.  This is getting kind of large, especially considering the volume
of data we're holding per node and link already in ASoC.  On the other
hand we may over time be able to refactor some of the existing stuff
(especially the link management) to use this structure.
