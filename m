Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2AMDoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 22:44:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:43277 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505Ab2AMDoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 22:44:18 -0500
Date: Fri, 13 Jan 2012 11:55:08 +0800
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
Message-ID: <20120113035506.GB12184@S2101-09.ap.freescale.net>
References: <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A76A@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788508E7B0@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D1DD6@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D1DD6@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 12:56:52PM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Thursday, January 12, 2012 1:36 AM:
> > Stephen Warren wrote at Thursday, January 12, 2012 4:18 AM:
> > > Dong Aisheng wrote at Tuesday, January 10, 2012 1:21 AM:
> > > > Stephen Warren wrote at Saturday, January 07, 2012 2:03 AM:
> ...
> > > Personally, I think I'd be OK with the sysfs pinctrl map file only containing
> > > the map entries for devices that had used the pinctrl API, and hence only
> > > parsing the pinmux properties in pinmux_get().
> >
> > Actually I already did it like that in the patch I sent:
> > https://lkml.org/lkml/2012/1/5/153
> > 
> > Originally I'd like to do like that but I found an inconsistent issue that
> > the sysfs pinctrl map file will behave differently between dt and non-dt
> > Platform. For non-dt, it means showing all exist map entries. For dt, it means
> > Only used pinmux map entries.
> > 
> > And in current design when device calls pinmux_get, it will search a predefined
> > pinmux_maps array to find which function and group it is binded to.
> > If switch to the new way, we only dynamically create pinmux map and dynamically
> > register it when pinmux_get is called, first we need to change the code path in
> > pinmux_get in a totally different way, second for support that we may also better
> > to change pinmux_maps array to a list.
> > But after changing the pinmux_maps to a list, what about using in non-dt?
> > 
> > So without any strong reason i still think it would be better to keep consistency
> > With the non-dt pinctrl subsystem.
> > And the effort would be minimum since besides constructing the map by parsing
> > Device tree, everyting is the same as before in pinmux map and we could re-use
> > the current code.
> 
> OK. I think this can work out pretty easily with a bus notifier as I
> mentioned before.
> 
> But, one thought on doing this in pinmux_get(). I'd simply implement a
> Function that read a DT node's pinmux property/node, converted it to a
> pinmux mapping table, and registered it with the pinctrl core. Then,
> pinmux_get() could simply call this before doing anything else at all.
> I don't think you'd need to modify how pinmux_get() worked at all.
> 
This sounds like a pretty good idea to me.

-- 
Regards,
Shawn
