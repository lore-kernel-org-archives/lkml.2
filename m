Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0KYNl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:41:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51245 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752328Ab0KYNl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:41:27 -0500
Date: Thu, 25 Nov 2010 13:41:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sakari.ailus@maxwell.research.nokia.com, lennart@poettering.net
Subject: Re: [RFC/PATCH v6 03/12] [alsa-devel] media: Entities, pads and
 links
Message-ID: <20101125134135.GB24208@opensource.wolfsonmicro.com>
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1290652099-15102-4-git-send-email-laurent.pinchart@ideasonboard.com>
 <4CEE2E7D.6060608@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEE2E7D.6060608@ladisch.de>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 10:38:05AM +0100, Clemens Ladisch wrote:

> In USB and HD audio devices, all links are immutable, and the routing
> is controlled by 'selector' entities that activate exactly one of their
> input pads.  In userspace, this entity shows up as a mixer control.
> I guess it would be possible to map the ACTIVE flag onto these controls.

Ditto for ASoC, mostly.

> Alternatively, entities can have 'mute' mixer controls associated with
> their pads.  In this case, multiple unmuted inputs would be mixed
> together.

> ALSA has PCM and MIDI devices, and several types of mixer controls.
> (It also has hardware dependent and timer devices, but I don't think
> these would need topology information.)  So we need at least these:
>   MEDIA_ENTITY_TYPE_NODE_ALSA_PCM
>   MEDIA_ENTITY_TYPE_NODE_ALSA_MIDI
>   MEDIA_ENTITY_TYPE_SUBDEV_ALSA_CONTROL

> Furthermore, topology information is also needed for entities not
> associated with a mixer control, such as microphones, speakers, jacks/
> connectors, and effect units.  These entities are defined in the USB and
> HD audio specifications, but are not yet handled by ALSA.

All this and more in the embedded case - digital audio link nodes and DSP
I/O nodes (could possibly do those as digital audio ones) spring to
mind.  Also bear in mind that embedded devices can get *very* large - a
mobile phone audio system can have of the order of 100 nodes in the
graph.

> ALSA devices are not addressed by their device node but with card/device/
> subdevice numbers; mixer controls have numeric IDs, unique per card:
> 
> 		struct {
> 			int card;
> 			int device;
> 			int subdevice;
> 		} alsa_device;
> 		struct {
> 			int card;
> 			int numid;
> 		} alsa_control;

For the embedded stuff we also have a bunch of stuff in the graph which
may not be visible to userspace at all at present and would just have a
string based identifier.
