Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab1KILtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:49:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60219 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1KILtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:49:46 -0500
Date: Wed, 9 Nov 2011 12:49:36 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 6/8] of: add clock providers
Message-ID: <20111109114936.GL16886@pengutronix.de>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca>
 <20111109091328.GY16886@pengutronix.de>
 <4EBA62AD.3000407@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA62AD.3000407@ti.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:39:09 up 20 days, 18:14, 51 users,  load average: 3.16, 4.62,
 4.64
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 12:23:25PM +0100, Cousson, Benoit wrote:
> On 11/9/2011 10:13 AM, Sascha Hauer wrote:
> >On Tue, Nov 08, 2011 at 06:19:41PM -0700, Grant Likely wrote:
> 
> [...]
> 
> >>+Sources of clock signal can be represented by any node in the device
> >>+tree.  Those nodes are designated as clock providers.  Clock consumer
> >>+nodes use a phandle and clock specifier pair to connect clock provider
> >>+outputs to clock inputs.  Similar to the gpio specifiers, a clock
> >>+specifier is an array of one more more cells identifying the clock
> >>+output on a device.  The length of a clock specifier is defined by the
> >>+value of a #clock-cells property in the clock provider node.
> >>+
> >>+[1] http://patchwork.ozlabs.org/patch/31551/
> >>+
> >>+==Clock providers==
> >>+
> >>+Required properties:
> >>+#clock-cells:	   Number of cells in a clock specifier; typically will be
> >>+		   set to 1
> >>+
> >>+Optional properties:
> >>+clock-output-name: Recommended to be a list of strings of clock output signal
> >>+		   names indexed by the first cell in the clock specifier.
> >>+		   However, the meaning of clock-output-names is domain
> >>+		   specific to the clock provider, and is only provided to
> >>+		   encourage using the same meaning for the majority of clock
> >>+		   providers.  This format may not work for clock providers
> >>+		   using a complex clock specifier format.  In those cases it
> >>+		   is recommended to omit this property and create a binding
> >>+		   specific names property.
> >
> >If the clock-output-name property is omitted, does this mean a clock
> >provider only has a single output or does it mean that it's not known
> >how many clock outputs a provider actually has?
> 
> Allowing several outputs for a single clock node might lead to a lot
> of confusion. What will be the meaning of a clock rate if you have
> several outputs at different frequency?
> I think it will be better to define a clock node as a single source
> of clock. If several outputs are needed, then we should define
> several clock nodes.
> If we let a clock node be any kind of big clock blob, we will never
> be able to define some generic reusable clock node API. Everybody
> will define its own custom clock blobs.

Generally +1. I asked myself the same question whether it's a good thing
to allow a node to have multiple clocks. For i.MX I can say that I don't
need this and that I do not intend to use this feature. Grants concerns
about this are that the clock part of the device tree might explode when
we put each and every clock into the devicetree, so he wants to allow
bigger blobs of multiple clocks.

My impression gets more and more that we either put the clock tree in the
devicetree or we do not do it, but there's not much room in between.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
