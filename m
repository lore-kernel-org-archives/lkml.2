Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab1JDS3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:29:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39308 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1JDS3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:29:40 -0400
Date: Tue, 4 Oct 2011 12:27:11 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        "Taneja, Archit" <archit@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "R, Sricharan" <r.sricharan@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] OMAP2PLUS: DSS: Ensure DSS works correctly if display
 is enabled in bootloader
Message-ID: <20111004182711.GE2870@ponder.secretlab.ca>
References: <1315811306-11001-1-git-send-email-archit@ti.com>
 <alpine.DEB.2.00.1110022237171.4611@utopia.booyaka.com>
 <1317630070.2026.27.camel@deskari>
 <4E898468.2060508@ti.com>
 <alpine.DEB.2.00.1110031126090.4611@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110031126090.4611@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 11:34:34AM -0600, Paul Walmsley wrote:
> + devicetree-discuss, lkml
> 
> On Mon, 3 Oct 2011, Cousson, Benoit wrote:
> 
> > But at that time, device tree was not there...
> > Now, the whole dev_attr stuff will be replaced because device tree is able to
> > provide the driver any kind of custom information that can be retrieved
> > directly from the driver without having to use a pdata in between. So I'm not
> > sure it worth spending too much time on that feature stuff.
> > 
> > As an example here is the ongoing GPIO DT migration:
> > http://www.mail-archive.com/linux-omap@vger.kernel.org/msg56505.html
> > 
> > 3.2 will have the basic DT support using hwmod as a backend, but the idea is
> > that for 3.3, we start removing some information from hwmod to rely on device
> > tree only.
> 
> One comment here though -- and I will make this comment on the original 
> series too -- is that we should avoid adding direct DT dependencies into 
> the driver.
> 
> Specifically, these of_get_property() and of_property*() calls in the 
> driver aren't right.
> 
> We need some way of doing this that is completely independent from the 
> device data format.  Some way that does not care whether the input data is 
> coming from DT, platform_data, ACPI, or whatever the new flavor of the 
> year will be next year.  Or we need to declare that these of_*() calls are 
> not DT-specific, and define them as hooks that the device data format code 
> can handle as it pleases.

Generally, I agree.  For example, I've been thinking of either
modifying or creating bus_type-agnostic variants of the
platform_get_*() hooks so that the driver can get the data it needs
without knowing what the data source is.  (Actually, it already works
that way for platform_devices and DT, but that is only because the DT
code populates the resource table when the device is created).

This works best for well understood things like GPIOs, IRQs, memory
ranges, and the like.  It doesn't really work very well for data
specific to the device.

g.

