Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1JTR0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:26:52 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18363 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab1JTR0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:26:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 20 Oct 2011 10:26:44 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 20 Oct 2011 10:26:43 -0700
Subject: RE: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Topic: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Index: AcyOzukr7U8/KlUGRgqxpMELCSaxNwAfbvdQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173D51C1C4@HQMAIL01.nvidia.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
 <20111020023140.GC32007@S2100-06.ap.freescale.net>
In-Reply-To: <20111020023140.GC32007@S2100-06.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Guo wrote at Wednesday, October 19, 2011 8:32 PM:
> On Wed, Oct 19, 2011 at 06:21:14PM +0200, Linus Walleij wrote:
...
> > +int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
> > +		     enum pin_config_param param, unsigned long data)
...
> > +enum pin_config_param {
> > +	PIN_CONFIG_BIAS_UNKNOWN,
> > +	PIN_CONFIG_BIAS_FLOAT,
> > +	PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
> > +	PIN_CONFIG_BIAS_PULL_UP,
> > +	PIN_CONFIG_BIAS_PULL_DOWN,
> > +	PIN_CONFIG_BIAS_HIGH,
> > +	PIN_CONFIG_BIAS_GROUND,
> > +	PIN_CONFIG_DRIVE_UNKNOWN,
> > +	PIN_CONFIG_DRIVE_PUSH_PULL,
> > +	PIN_CONFIG_DRIVE_OPEN_DRAIN,
> > +	PIN_CONFIG_DRIVE_OPEN_SOURCE,
> > +	PIN_CONFIG_DRIVE_OFF,
> > +	PIN_CONFIG_INPUT_SCHMITT,
> > +	PIN_CONFIG_SLEW_RATE_RISING,
> > +	PIN_CONFIG_SLEW_RATE_FALLING,
> > +	PIN_CONFIG_LOAD_CAPACITANCE,
> > +	PIN_CONFIG_WAKEUP_ENABLE,
> > +	PIN_CONFIG_END,
> > +};
> 
> IMO, trying to enumerate all possible pin_config options is just to
> make everyone's life harder.  Firstly, this enumeration is far from
> completion, for imx6 iomuxc example, we have 3 options for pull-up,
> 22, 47 and 100 kOhm, and 7 options for driver-strength, 34, 40, 48,
> 60, 80, 120, and 240 Ohm.  It's just so hard to make this enumeration
> complete.  Secondly, defining this param as enum requires the API
> user to call the function multiple times to configure one pin.  For
> example, if I want to configure pin_foo as slow-slew, open-drain,
> 100 kOhm pull-up and 120 Ohm driver-strength, I will have to call
> pin_config(pctldev, pin_foo, ...) 4 times to achieve that.
> 
> I like Stephen's idea about having 'u32 param' and let pinctrl drivers
> to encode/decode this u32 for their pinctrl controller.  It makes
> people's life much easier.

That's not quite what I meant.

I meant that I thought the types for param and value should be simple
integers, with meanings of the values defined by the individual drivers,
rather than a system-defined enum.

However, I wasn't envisaging packing multiple fields into the "value"
parameter; that would essentially be packing a struct into a u32 for
transport. I still figured that "param" would logically be an enum,
and represent a single modifiable parameter, and "data"/"value" would
be the single value of that one parameter.

Still, perhaps packing stuff is an option that makes sense in some cases,
depending on what API we end up with to manipulate the parameters, and
where the source of "data"/"value" is (encoded into client driver, or
from some hidden table passed to pinmux core by board, with the values
being passed directly to the pinmux drivers without the client drivers
seeing them)

-- 
nvpublic

