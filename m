Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab0LNNcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:32:02 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41632 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758023Ab0LNNcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:32:00 -0500
X-Sasl-enc: yJJpqhS8MUB6OiVjJE/ZufiDf4jw/A2eqBEMjGDKHPzA 1292333519
Message-ID: <4D0771CB.3020809@ladisch.de>
Date: Tue, 14 Dec 2010 14:31:55 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: alsa-devel@alsa-project.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities, pads and links
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <4CEF799E.7060508@ladisch.de> <4D06458B.6080808@ladisch.de> <201012141300.57118.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012141300.57118.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> On Monday 13 December 2010 17:10:51 Clemens Ladisch wrote:
>> TYPE_EXT describes entities that represent some interface to the
>> external world, TYPE_INT those that are internal to the entire device.
>> (I'm not sure if that distinction is very useful, but TYPE_SUBDEV seems
>> to be an even more meaningless name.)
> 
> SUBDEV comes from the V4L2 world, and I agree that it might not be a very good 
> name.
> 
> I'm not sure I would split entities in internal/external categories. I would
> create a category for connectors though.

I'm not disagreeing, but what is actually the distinction between types
and subtypes?  ;-)

>> * Entity properties
>> 
>> There needs to be a mechanism to associate meta-information (properties)
>> with entities.  This information should be optional and extensible, but,
>> when being handled inside the kernel, doesn't need to be more than
>> a read-only blob.  I think that something like ALSA's TLV format (used
>> for mixer controls) can be used here.  (I'm not mentioning the X-word
>> here, except to note that the "M" stands for "markup".)
> 
> I've been thinking of adding a new ioctl for that. It's something we need to
> draft. The UVC driver will need it, and I'm pretty sure other V4L2 drivers
> would find it useful as well.

I'm imagining a "read-the-properties" ioctl that just returns the
entity's blob.

>> EXT_SPEAKER also includes headphones; there might be made a case for
>> having those as a separate subtype.
> 
> Shouldn't headphones be represented by an EXT_JACK_ANALOG ?

Headphone jacks are jacks; there are also USB headphones.

>> EXT_BROADCAST represents devices like TV tuners, satellite receivers,
>> cable tuners, or radios.
> 
> There's clearly an overlap with V4L here.

These come from the USB audio spec.  Video devices are indeed likely to
be more detailed than just a single audio source. :)

>> INT_CONTROLS may have multiple independent controls (this is USB's
>> Feature Unit); INT_EFFECT may have multiple controls that affect one
>> single algorithm.
> 
> I'd describe this as a feature unit/processing unit then.

I was aiming for more descriptive names, but I agree that the original
names might be more useful.

> Should we have an AUDIO category ?

Probably not, because there are combined audio/video jacks, any maybe
other entities.

>> * Entity specifications
>> 
>> While TYPE_DEVICE entities can be identified by their device node, other
>> entities typcially have just a numeric ID.
> 
> In V4L2 sub-devices have (or rather will have once the media controller
> patches will be integrated) device nodes as well, so exposing that information
> is required.

USB and HDA entities already have numeric IDs.

>> For that, it would be useful to make do without separate identification and
>> let the driver choose the entity ID.
> 
> How would drivers do that ? What if you have two instances of the same chip
> (a video sensor, audio mixer, ...) on the same board ?

Then those would get different IDs; USB descriptors always describe the
entire device.


Regards,
Clemens
