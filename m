Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1BDKVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:21:00 -0500
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3027 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab1BDKU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:20:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v8 03/12] media: Entities, pads and links
Date: Fri, 4 Feb 2011 11:20:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, clemens@ladisch.de
References: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131437-29954-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131437-29954-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102041120.37541.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 27, 2011 13:30:28 Laurent Pinchart wrote:

<snip>

> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> new file mode 100644
> index 0000000..7cf9135
> --- /dev/null
> +++ b/include/media/media-entity.h
> @@ -0,0 +1,122 @@
> +/*
> + * Media entity
> + *
> + * Copyright (C) 2010 Nokia Corporation
> + *
> + * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *	     Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#ifndef _MEDIA_ENTITY_H
> +#define _MEDIA_ENTITY_H
> +
> +#include <linux/list.h>
> +
> +#define MEDIA_ENT_TYPE_SHIFT		16
> +#define MEDIA_ENT_TYPE_MASK		0x00ff0000
> +#define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
> +
> +#define MEDIA_ENT_T_DEVNODE		(1 << MEDIA_ENTITY_TYPE_SHIFT)
> +#define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENTITY_T_DEVNODE + 1)
> +#define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENTITY_T_DEVNODE + 2)
> +#define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENTITY_T_DEVNODE + 3)
> +#define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENTITY_T_DEVNODE + 4)
> +
> +#define MEDIA_ENT_T_V4L2_SUBDEV		(2 << MEDIA_ENTITY_TYPE_SHIFT)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENTITY_T_V4L2_SUBDEV + 1)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENTITY_T_V4L2_SUBDEV + 2)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENTITY_T_V4L2_SUBDEV + 3)

MEDIA_ENTITY_? That should be MEDIA_ENT_. It looks like this was never compiled...

BTW, I like the new names :-)


> +
> +#define MEDIA_ENT_FL_DEFAULT		(1 << 0)
> +
> +#define MEDIA_LNK_FL_ENABLED		(1 << 0)
> +#define MEDIA_LNK_FL_IMMUTABLE		(1 << 1)
> +
> +#define MEDIA_PAD_FL_INPUT		(1 << 0)
> +#define MEDIA_PAD_FL_OUTPUT		(1 << 1)
> +
> +struct media_link {
> +	struct media_pad *source;	/* Source pad */
> +	struct media_pad *sink;		/* Sink pad  */
> +	struct media_link *reverse;	/* Link in the reverse direction */
> +	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
> +};
> +
> +struct media_pad {
> +	struct media_entity *entity;	/* Entity this pad belongs to */
> +	u16 index;			/* Pad index in the entity pads array */
> +	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
> +};
> +
> +struct media_entity {
> +	struct list_head list;
> +	struct media_device *parent;	/* Media device this entity belongs to*/
> +	u32 id;				/* Entity ID, unique in the parent media
> +					 * device context */
> +	const char *name;		/* Entity name */
> +	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
> +	u32 revision;			/* Entity revision, driver specific */
> +	unsigned long flags;		/* Entity flags (MEDIA_ENT_FL_*) */
> +	u32 group_id;			/* Entity group ID */
> +
> +	u16 num_pads;			/* Number of input and output pads */
> +	u16 num_links;			/* Number of existing links, both
> +					 * enabled and disabled */
> +	u16 num_backlinks;		/* Number of backlinks */
> +	u16 max_links;			/* Maximum number of links */
> +
> +	struct media_pad *pads;		/* Pads array (num_pads elements) */
> +	struct media_link *links;	/* Links array (max_links elements)*/
> +
> +	union {
> +		/* Node specifications */
> +		struct {
> +			u32 major;
> +			u32 minor;
> +		} v4l;
> +		struct {
> +			u32 major;
> +			u32 minor;
> +		} fb;
> +		struct {
> +			u32 card;
> +			u32 device;
> +			u32 subdevice;
> +		} alsa;
> +		int dvb;
> +
> +		/* Sub-device specifications */
> +		/* Nothing needed yet */
> +	};
> +};
> +
> +static inline u32 media_entity_type(struct media_entity *entity)
> +{
> +	return entity->type & MEDIA_ENT_TYPE_MASK;
> +}
> +
> +static inline u32 media_entity_subtype(struct media_entity *entity)
> +{
> +	return entity->type & MEDIA_ENT_SUBTYPE_MASK;
> +}
> +
> +int media_entity_init(struct media_entity *entity, u16 num_pads,
> +		struct media_pad *pads, u16 extra_links);
> +void media_entity_cleanup(struct media_entity *entity);
> +int media_entity_create_link(struct media_entity *source, u16 source_pad,
> +		struct media_entity *sink, u16 sink_pad, u32 flags);
> +
> +#endif
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
