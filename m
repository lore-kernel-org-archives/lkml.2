Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2AKXK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 18:10:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63100 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2AKXKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 18:10:55 -0500
Date: Thu, 12 Jan 2012 07:21:45 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Message-ID: <20120111232143.GF20968@S2101-09.ap.freescale.net>
References: <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A76A@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A76A@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:17:51PM -0800, Stephen Warren wrote:
> ...
> > To keep consistency as the currently design of pinctrl subsystem and also meet
> > the dt design philosophy, we still do not introduce a pinmux map in dt.
> > Instead, we choose to scan all the device node with a 'pinmux' phandle to construct
> > a pinmux map table before register the pin controller device(here we may also scan
> > the hog_on_boot node) and I guess it's easy to do that.
> ...
> > (Without scan the device node to construct the pinmux map table, we can only get the map
> > Information when we run the pinmux_get.
> > See: https://lkml.org/lkml/2012/1/5/153
> > So no pinmux map table exists and we surely do not want to see that the sysfs exporting
> > pinmux map information works in dt but unwork in non-dt)
> 
> Hmmm. I'm not sure that the pinctrl code should actively scan all nodes
> in the device tree for pin mux properties. That seems a little invasive;
> how does pinctrl know which nodes it really should be looking at, and
> which nodes are random internal parts of some device's custom binding?
> 
> Personally, I think I'd be OK with the sysfs pinctrl map file only
> containing the map entries for devices that had used the pinctrl API,
> and hence only parsing the pinmux properties in pinmux_get().
> 
During the discussion with Aisheng, I also inclined to go this way.
But it seems that he really cares about aligning dt support and
non-dt code path in pinctrl core level, which does not really matter
to me.  So if we vote, I'd vote this way.

If we go this way, all the hog_on_boot nodes need to be under particular
parent node, and get parsed and handled by pinctrl core at probe phase.

Regards,
Shawn

> However, we could perhaps do better by registering a bus notifier, and
> pro-actively parsing the top-level DT node (if there is one) for every
> device that is created. That way, the mapping would be parsed as soon
> as the device was created (or perhaps after probe?). The only case this
> might not cover is DT nodes for which the kernel doesn't actually have
> a driver, and hence no device is created.
> 
