Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2BFFo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 00:44:57 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12526 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2BFFo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 00:44:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 05 Feb 2012 21:44:52 -0800
Message-ID: <4F2F68CE.3030208@nvidia.com>
Date: Sun, 05 Feb 2012 21:44:46 -0800
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "ext Tony Lindgren (tony@atomide.com)" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: An extremely simplified pinctrl bindings proposal
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com> <CAJuYYwQ2yczBh+CBFWohZPM+9jHXYxyxYzL8CS4puE96v4fDXw@mail.gmail.com>
In-Reply-To: <CAJuYYwQ2yczBh+CBFWohZPM+9jHXYxyxYzL8CS4puE96v4fDXw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 07:07 PM, Thomas Abraham wrote:
> Hi Stephen,
> 
> On 4 February 2012 21:31, Stephen Warren <swarren@nvidia.com> wrote:
>> Sorry, I haven't had a chance to read any of the pincrl emails from
>> Friday onwards. However, I thought a bit more about this, and decided
>> to propose someting much simpler:
>>
>> Thoughts:
>>
>> * Defining all the pins, groups, functions, ... takes a lot of space,
>>  whether it's in static data in pinctrl drivers or in the device tree.
>>  The lists must also be stored in RAM at runtime.
>>
>> * It's been very difficult to come up with a generic description of all
>>  pin controller's capabilities. This is true even irrespective of device
>>  tree; think pin config where we've agonized over whether we can create
>>  a standardized list of pin config properties, or need to allow each
>>  pinctrl driver to define its own set of properties, etc.
>>
>> * The only real use of the lists is for debugfs. Drivers shouldn't expect
>>  to directly request specific pinctrl settings, since that would encode
>>  knowledge of an individual SoC's pin controller. This should be
>>  abstracted from drivers.
>>
>> * The data in debugfs could easily be replaced by a raw register dump
>>  coupled with a SoC-specific script to print out what each register
>>  means.
>>
>> My proposal below is to radically simplify the pinctrl subsystem, and
>> make it little more than a system to execute a list of arbitrary register
>> writes.
> 
> Thanks for your work on pinctrl bindings proposal.
> 
> With this new approach, how much of the pinctrl susbystem is used in
> device tree mode.

Probably not a lot of the actual implementation. I'd assume that the
APIs called by device drivers would remain constant, or roughly so, in
order to still provide a simple interface for drivers.

> Last time I had proposed something similar to this
> (http://marc.info/?l=linux-kernel&m=132697880016289&w=2), you were not
> happy about that approach since the pinctrl subsystem is largely
> under-utilized (http://marc.info/?l=linux-kernel&m=132735884622374&w=2),
> expect for providing a interface which individual
> pinctrl/pinmux/pinconfig drivers will use to implement a function that
> programs the hardware.

That's true.

AS LinusW says in his later reply, losing the semantic representation in
the pinctrl system is a pity, which is the main reasoning behind my
previous response. However, I'm beginning to lean towards the simplicity
of something like a list of register writes trumping the lack of semantics.

> There need not be pinmux/pinctrl/pinconfig bindings that are designed
> for the linux pinctrl subsystem. DT allows specifying the
> pinconfig/pinmux properties in a simple way, which was not possible in
> non-dt case and hence the pinctrl subsystem. Other OS'es which might
> not have a pinctrl subsystem, similar to what linux has, should also
> find the pinctrl bindings useful.

True.

I think that pinctrl in a non-DT system probably could do something like
this DT binding proposal though, so we need not have DT/non-DT work
differently.

-- 
nvpublic
