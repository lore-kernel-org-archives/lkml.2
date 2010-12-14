Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0LNOtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:49:24 -0500
Received: from smtp.nokia.com ([147.243.128.24]:39179 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab0LNOtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:49:22 -0500
Message-ID: <4D0783E4.7050708@maxwell.research.nokia.com>
Date: Tue, 14 Dec 2010 16:49:08 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101123 SeaMonkey/2.0.11
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lennart@poettering.net,
        linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities, pads and links
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>	<1290652099-15102-4-git-send-email-laurent.pinchart@ideasonboard.com>	<4CEE2E7D.6060608@ladisch.de>	<201011251621.38757.laurent.pinchart@ideasonboard.com> <4CEF799E.7060508@ladisch.de> <4D06458B.6080808@ladisch.de>
In-Reply-To: <4D06458B.6080808@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens, Laurent, Hans & others!

Clemens Ladisch wrote:
> I wrote:
>> I'll see if I can draw up the ALSA-specific media stuff over the weekend.
> 
> Sorry, wrong weekend.
> 
> Anyway, below are some remarks and a patch.
> 
> 
> * Entity types
> 
> TYPE_NODE was renamed to TYPE_DEVICE because "node" sounds like a node
> in a graph, which does not distinguish it from other entity types
> because all entities are part of the topology graph.  I chose "device"
> as this type describes entities that are visible as some device node to
> other software.
> 
> TYPE_EXT describes entities that represent some interface to the
> external world, TYPE_INT those that are internal to the entire device.
> (I'm not sure if that distinction is very useful, but TYPE_SUBDEV seems
> to be an even more meaningless name.)
> 
> 
> ALSA mixer controls are not directly represented; a better fit for the
> architecture of actual devices is that one or more mixer controls can be
> associated with an entity.  (This can be done with a field of the mixer
> control.)
> 
> 
> * Entity properties
> 
> There needs to be a mechanism to associate meta-information (properties)
> with entities.  This information should be optional and extensible, but,
> when being handled inside the kernel, doesn't need to be more than
> a read-only blob.  I think that something like ALSA's TLV format (used
> for mixer controls) can be used here.  (I'm not mentioning the X-word
> here, except to note that the "M" stands for "markup".)
> 
> 
> * Entity subtypes
> 
> EXT_JACK_ANALOG represents any analog audio and/or video connector.
> Properties for audio jacks would be jack type (TRS/RCA), color code,
> line level, position, etc.
> 
> EXT_JACK_DIGITAL represents a digital connector like S/PDIF (coax/
> TOSLINK), ADAT, TDIF, or MADI.
> 
> EXT_JACK_BUS represents a bus like FireWire and comes from the USB audio
> spec.  (I doubt that any devices with this entitiy will ever exist.)
> 
> EXT_INSTRUMENT represents something like an e-guitar, keyboard, or MIDI
> controller.  (Instrument entities are typically audio sources and MIDI
> sources and sinks, but can also be audio sinks.)
> 
> EXT_SPEAKER also includes headphones; there might be made a case for
> having those as a separate subtype.
> 
> EXT_PLAYER represents a device like a CD/DVD/tape player.  Recorders can
> also write to that device, so "player" might not be an ideal name.
> 
> EXT_BROADCAST represents devices like TV tuners, satellite receivers,
> cable tuners, or radios.
> 
> INT_SYNTHESIZER converts MIDI to audio.
> 
> INT_NOISE_SOURCE comes from the USB audio spec; this is not an attempt
> to describe the characteristics of consumer-grade devices :-) , but
> represents an internal noise source for level calibration or measurements.
> 
> INT_CONTROLS may have multiple independent controls (this is USB's
> Feature Unit); INT_EFFECT may have multiple controls that affect one
> single algorithm.
> 
> INT_CHANNEL_SPLIT/MERGE are needed for HDAudio devices, whose topology
> information has only stereo links.

This naming already has been commented, but what do you think: should
the type explicitly tell what kind of interface, if any, is exported to
user space?

Only MEDIA_ENTITY_NODE_* types do this currently, and
MEDIA_ENTITY_TYPE_SUBDEV_* to some extent, but the way is not consistent
at the moment. MEDIA_ENTITY_NODE_* range has lost of different
interfaces whereas MEDIA_ENTITY_TYPE_SUBDEV_* are basically offering
v4l2_subdev and beyond that, suggesting what kind of controls might be
found from the nodes.

I would expect that the interfaces offered by the character devices
would be somewhat standardised in the end like v4l2_subdev user space
interface.

The types above are mostly describing the role of an entity, which might
be interesting as well.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
