Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0KZJI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:08:58 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:49312 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0KZJI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:08:56 -0500
Message-ID: <4CEF799E.7060508@ladisch.de>
Date: Fri, 26 Nov 2010 10:10:54 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
Subject: Re: [RFC/PATCH v6 03/12] [alsa-devel] media: Entities, pads and links
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290652099-15102-4-git-send-email-laurent.pinchart@ideasonboard.com> <4CEE2E7D.6060608@ladisch.de> <201011251621.38757.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011251621.38757.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> On Thursday 25 November 2010 10:38:05 Clemens Ladisch wrote:
> >   MEDIA_ENTITY_TYPE_NODE_ALSA_PCM
> >   MEDIA_ENTITY_TYPE_NODE_ALSA_MIDI
> >   MEDIA_ENTITY_TYPE_SUBDEV_ALSA_CONTROL
> 
> I agree about PCM and MIDI, but I'm not sure about controls. If controls are
> part of an entity, the entity will be reported through the media controller
> API. If information about that entity can be queried through existing APIs
> (ALSA, V4L, ...) those APIs should be used.

At the moment, ALSA has no API for topology information.

> I can certainly imagine a graph with 100 controls, but maybe several
> controls can be part of the same node ?

There is indeed no strict 1:1 relation; e.g., volume and mute are often
part of the same node.  So it looks we need some kind of separate ALSA
node, which can be associated with mixer controls and/or other
information.

ALSA already has is a method to query arbitrary (TLV) metadata for mixer
controls; the entity/control relationship can be stored in the control.

> I think we will need a new ioctl in the media controller API to report
> advanced information about an entity. This could be used to report controls
> implemented by an ALSA element if ALSA doesn't provide a way to do that
> directly.

This advanced information would always be specific to the entity type,
so maybe this should be part of that subsystem's API.  Otherwise, the
media_entity would need a callback, or store a pointer to some memory
block (which assumes that the information is always constant).

> > Furthermore, topology information is also needed for entities not
> > associated with a mixer control, such as microphones, speakers, jacks/
> > connectors, and effect units.  These entities are defined in the USB and
> > HD audio specifications, but are not yet handled by ALSA.
> 
> Agreed, we will need to add new entity types and subtypes for those. The
> reason they're not part of this submission is that I wanted real use cases
> instead of coming up with a made-up list of entities I think would be useful.

The reason that I'm always mentioning the USB and HD audio specs is that
those already define entities that should cover practically all of the
audio needs.  (And, of course, we want to be able to report those
entities without having to do too many conversions.)


I'll see if I can draw up the ALSA-specific media stuff over the weekend.


Regards,
Clemens
