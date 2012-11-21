Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab2KUPDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:03:12 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37971 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2KUPDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:03:08 -0500
MIME-Version: 1.0
In-Reply-To: <50ACD7DC.5060405@ti.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121120215429.B621F3E1821@localhost>
 <13540495.epaCf4JVn9@percival> <50ACB59B.4090404@iki.fi> <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de>
 <50ACC341.3090204@ti.com> <20121121130039.GA12191@avionic-0098.adnet.avionic-design.de>
 <50ACD7DC.5060405@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 22 Nov 2012 00:02:47 +0900
Message-ID: <CAAVeFuJofYwj926=3v0ApBCq_vNhCdC1PnzDc-B3d=LL_L40Uw@mail.gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Tomi Valkeinen <tomba@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mmmm so maybe I am misinterpreting things, but it looks like we
have just buried the power sequences here, haven't we?

Alex.

On Wed, Nov 21, 2012 at 10:32 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 2012-11-21 15:00, Thierry Reding wrote:
>> On Wed, Nov 21, 2012 at 02:04:17PM +0200, Tomi Valkeinen wrote:
>>> On 2012-11-21 13:40, Thierry Reding wrote:
>>>> On Wed, Nov 21, 2012 at 01:06:03PM +0200, Tomi Valkeinen wrote:
>>>
>>> (sorry for bouncing back and forth with my private and my @ti addresses.
>>> I can't find an option in thunderbird to only use one sender address,
>>> and I always forget to change it when responding...)
>>>
>>>>> My suggestion would be to go forward with an in-driver solution, and
>>>>> look at the DT based solution later if we are seeing an increasing bloat
>>>>> in the drivers.
>>>>
>>>> Assuming we go with your approach, what's the plan? We're actually
>>>> facing this problem right now for Tegra. Basically we have a DRM driver
>>>> that can drive the panel, but we're still missing a way to hook up the
>>>> backlight and panel enabling code. So we effectively can't support any
>>>> of the LVDS devices out there without this series.
>>>
>>> Could you describe the hardware setup you have related to the LCD and
>>> backlight? Is it a public board with public schematics?
>>
>> I don't think any of the schematics are public. The Tamonten Evaluation
>> Carrier is available publicly from our website and the schematics are
>> available on demand as well. If required I can probably arrange to send
>> you a copy.
>
> No need, I think your answer below is enough.
>
>>> I've understood that you don't have anything special in your board, just
>>> an LCD and a backlight, and the power sequences are related to powering
>>> up the LCD and the backlight, without anything board specific. If so,
>>> there's no need for board specific code, but just improving the panel
>>> and backlight drivers to support the models you use.
>>
>> Correct. Basically we have two GPIOs that each enable the panel or the
>> backlight respectively and one PWM to control the brightness. Are the
>
> The panel GPIO goes to the panel hardware device, and enables the panel?
> And similarly for the PWM GPIO, it goes to the PWM hardware device? Just
> making sure there are no other components involved.
>
>> panel drivers that you refer to those in drivers/video? I'm not sure if
>> adding more ad-hoc drivers there just to move them to a generic
>> framework in the next cycle is a good idea. I'd rather spend some time
>> on helping to get the framework right and have drivers for that instead.
>
> We have panel drivers for omap in drivers/video/omap2/displays/. I'm not
> sure if other platforms have their own versions of panel drivers, but
> probably adding a simple panel driver system for a platform would not be
> too difficult. It could even be quite hardcoded, i.e. embedded directly
> into the display subsystem driver, just to get something working until
> the common panel framework is available.
>
> Yes, I agree it's not good idea to add more platform specific panel
> drivers. But it's unclear when CPF will be merged, so if you need to get
> the panel working now, I don't see a simple ad-hoc driver as too
> horrible. But, of course, I'm not the one making the decision whether to
> merge or not =).
>
>> From what I understand by looking at the OMAP display drivers, they also
>> provide the timings for the displays. Steffen's videomode helpers can be
>> used to represent these easily in DT, but I suppose if all of those per-
>
> Right. Note that I didn't present omap panel drivers as perfect
> examples, just examples =).
>
>> panel specifics are represented in the drivers then that won't be needed
>> anymore either.
>
> Yes, for most panels with just one native mode and nothing else, the
> panel driver can contain the timings.
>
> However, this subject has been discussed earlier a few times. If the
> panel in question doesn't need any special power-on/off sequences, just,
> perhaps, one gpio or such, we could still use DT video modes. This would
> simplify the cases where you have lots of different very simple panels.
>
> Obviously the same questions apply to DT video modes than to the power
> sequences, and while I do think it's better to handle the timings inside
> the driver, I'm not too much against video timings in DT. The reason
> being that the video modes are quite clear, simple and stable data,
> versus the much more complex and open-ended power sequences.
>
>>> I don't see any problem with adding small Tegra specific panel drivers
>>> for the time being, with the intention of converting to common panel
>>> framework when that's available.
>>
>> I can take a look at how such a driver could be implemented, but again,
>
> Don't look at the mainline omap panel drivers, at least not too closely
> =). They contain hackery that will be cleaned up with CPF.
>
> I think there are two methods to implements simple panel drivers:
>
> The hardcoded one, where the display subsystem driver manages a few
> different panel models. This is obviously not very expandable or
> "correct", but should probably work just fine for a few models, until
> CPF is usable.
>
> Something like CPF will have: have the panel device/driver as a platform
> device/driver, which will register itself to the display subsystem. And
> with "itself" I mean some kind of struct panel_entity, with a few ops
> implemented by the panel driver.
>
> Well, this goes a bit out of subject. If you want to discuss panel
> drivers more, please start a new thread. Laurent's upcoming CPF v2
> should give you good ideas what the model will be.
>
>  Tomi
>
>
