Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0KYP3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:29:42 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56906 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0KYP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:29:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH v6 03/12] [alsa-devel] media: Entities, pads and links
Date: Thu, 25 Nov 2010 16:29:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <4CEE2E7D.6060608@ladisch.de> <20101125134135.GB24208@opensource.wolfsonmicro.com>
In-Reply-To: <20101125134135.GB24208@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011251629.54575.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thursday 25 November 2010 14:41:35 Mark Brown wrote:
> On Thu, Nov 25, 2010 at 10:38:05AM +0100, Clemens Ladisch wrote:
> > In USB and HD audio devices, all links are immutable, and the routing
> > is controlled by 'selector' entities that activate exactly one of their
> > input pads.  In userspace, this entity shows up as a mixer control.
> > I guess it would be possible to map the ACTIVE flag onto these controls.
> 
> Ditto for ASoC, mostly.
> 
> > Alternatively, entities can have 'mute' mixer controls associated with
> > their pads.  In this case, multiple unmuted inputs would be mixed
> > together.
> > 
> > ALSA has PCM and MIDI devices, and several types of mixer controls.
> > (It also has hardware dependent and timer devices, but I don't think
> > 
> > these would need topology information.)  So we need at least these:
> >   MEDIA_ENTITY_TYPE_NODE_ALSA_PCM
> >   MEDIA_ENTITY_TYPE_NODE_ALSA_MIDI
> >   MEDIA_ENTITY_TYPE_SUBDEV_ALSA_CONTROL
> > 
> > Furthermore, topology information is also needed for entities not
> > associated with a mixer control, such as microphones, speakers, jacks/
> > connectors, and effect units.  These entities are defined in the USB and
> > HD audio specifications, but are not yet handled by ALSA.
> 
> All this and more in the embedded case - digital audio link nodes and DSP
> I/O nodes (could possibly do those as digital audio ones) spring to
> mind.  Also bear in mind that embedded devices can get *very* large - a
> mobile phone audio system can have of the order of 100 nodes in the
> graph.

It depends on how you define nodes. I can certainly imagine a graph with 100 
controls, but maybe several controls can be part of the same node ? On the 
video side we've decided to split entities depending on the possible data 
paths configurations. As I'm not a fluent ascii-art speaker, please have a 
look at pages 4 and 5 of http://www.ideasonboard.org/media/20101103-lpc-
media.pdf

Page 4 shows the internal topology of the OMAP3 ISP. The major blocks in that 
diagram are reported as entities. Page 5 shows the internal topology of one of 
the blocks, the OMAP3 ISP preview engine. As you can see the pipeline is made 
of sub-blocks that implement a single image processing function. As the 
pipeline is linear (don't worry about the non-linear part in the beginning, 
it's just there to take into account link configurability at the higher level) 
we don't export all the sub-blocks as entities, but we expose the controls on 
the preview engine entity instead.

> > ALSA devices are not addressed by their device node but with card/device/
> > 
> > subdevice numbers; mixer controls have numeric IDs, unique per card:
> > 		struct {
> > 		
> > 			int card;
> > 			int device;
> > 			int subdevice;
> > 		
> > 		} alsa_device;
> > 		struct {
> > 		
> > 			int card;
> > 			int numid;
> > 		
> > 		} alsa_control;
> 
> For the embedded stuff we also have a bunch of stuff in the graph which
> may not be visible to userspace at all at present and would just have a
> string based identifier.

That could be easily added (provided the string is not too long).

-- 
Regards,

Laurent Pinchart
