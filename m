Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1JJWR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:17:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34654 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1JJWR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:17:57 -0400
Message-ID: <4E936F0E.9050203@ti.com>
Date: Tue, 11 Oct 2011 00:17:50 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: "Kristo, Tero" <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com> <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com> <4E934D79.4080000@ti.com> <alpine.DEB.2.00.1110101416530.5205@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1110101416530.5205@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 10:42 PM, Paul Walmsley wrote:
> Hi Benoît
>
> On Mon, 10 Oct 2011, Cousson, Benoit wrote:
>
>> On 10/10/2011 9:24 PM, Paul Walmsley wrote:
>>> On Fri, 23 Sep 2011, Tero Kristo wrote:
>>>
>>>> This patch is temporary until Paul can provide a final version.
>>>>
>>>> Signed-off-by: Tero Kristo<t-kristo@ti.com>
>>>
>>> Here's an updated version of this one.  The one change is that the hwmod's
>>> name is now "prm3xxx" to reflect that the register layout of this IP block
>>> is quite different from its OMAP2 predecessors and OMAP4 successors.
>>> This should avoid some of the special-purpose driver probing code.
>>
>> This is not really aligned with the naming convention we've been using so far.
>> In both cases, the hwmod should just be named "prm". If a version information
>> is needed, then it should be added in the revision class field.
>>
>> It will make the device creation even simpler and not dependent of the SoC
>> version.
>
> The problem in this case is that we should be using a completely different
> device driver for the PRM that's in the OMAP3 chips, from the driver used
> for OMAP2 or OMAP4 PRM blocks, due to the completely different register
> layout.  As far as I know, we haven't yet used the hwmod IP version to
> probe a different device driver when the version number changes.  There's
> no support for that in the current Linux platform* code, so we'd need
> special-purpose code for that.
>
> In an ideal world, we'd have an omap_bus, etc., which would include an
> additional interface version number as part of its driver matching
> criteria.  Device drivers would then specify which interface version
> numbers they supported.  The device data would specify that interface
> version number should be matched.
>
> But as it is right now in the current platform_device/platform_driver
> based system, we have only the name to match.  We could implement
> something where we concatenate the existing IP version number onto the
> hwmod name, and modify the device drivers to use that name.  But that
> seems like a lot of potential churn in light of a future DT and/or
> omap_bus migration.
>
> So I'm proposing to use the IP version number field that's in the hwmod
> data to indicate evolutionary revisions of an IP block -- rather than
> revolutionary revisions that would require a new driver.  Then, since we
> use the hwmod name for driver matching, we'd use a different name for
> radically different IPs.
>
> If it's the "3xxx" that you're objecting to in the name, we could call it
> "prm2" or "prmxyz" - the '3xxx' just seemed like the most logical
> approach.  The name of the hwmod class in the patch is still "prm", of
> course.

Yes, but that's different, the number is supposed to represent the 
instance number in the IP naming convention. So prm2 != prmv2.

> Thoughts?

In fact the device name does not have to match the hwmod name. So we can 
just create an "omap2_prm" omap_device for OMAP2, "omap3_prm" 
omap_device for OMAP3...
That will allow the relevant PRM  driver to be bound to the proper device.

> N.B., it's true that by waiting, this problem will presumably go away,
> with DT, in which the driver matching data would go into the
> "compatible" string in the DT.

Yes, this will become indeed straightforward with DT.

We will just have something like:
prm {
	compatible = "prm-omap2";
	ti,hwmods = "prm";
}

> But I guess it would be good to figure out a clean approach in the
> meantime.

I guess the different device names should make that work in the meantime.

Regards,
Benoit


