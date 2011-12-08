Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1LHANN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:13:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1723 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1LHANM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:13:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 Dec 2011 16:13:07 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Date: Wed, 7 Dec 2011 16:13:06 -0800
Subject: RE: [PATCH 2/2 v5] pinctrl: introduce generic pin config
Thread-Topic: [PATCH 2/2 v5] pinctrl: introduce generic pin config
Thread-Index: Acy0ae/UUwd+iDUzTMqDPM/OQRQskgA0+iug
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B77903@HQMAIL01.nvidia.com>
References: <1322736902-11297-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDB0312@HQMAIL01.nvidia.com>
	<CACRpkdaGaYdQagOkFxfRpV=oxyxab40X5zzpeCamTCksuHQAaw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1750B7703C@HQMAIL01.nvidia.com>
 <CACRpkdYXazmia5=U-JFKUdfTzST_+=uWz4Za4o1ngzGjHy86qw@mail.gmail.com>
In-Reply-To: <CACRpkdYXazmia5=U-JFKUdfTzST_+=uWz4Za4o1ngzGjHy86qw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Tuesday, December 06, 2011 3:54 PM:
> On Mon, Dec 5, 2011 at 6:36 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Monday, December 05, 2011 9:01 AM:
> >> But if I can control the resistance of the pull-up resistor
> >> that brings us to a triplet: {parameter, type, argument}
> >> like this to set the generic pull-up to 100 kOhm:
> >>
> >> set_generic_bias(PIN_CONFIG_BIAS, PIN_CONFIG_BIAS_PULL_UP, 100000);
> >>
> >> parameter = BIAS
> >> type = PULL_UP
> >> argument = 100 kOhm
> >
> > I think that selecting what the value of pull-up is and enabling/disabling
> > pull-up are separate things, so you'd have:
> >
> > set PIN_CONFIG_PULL_UP_RESISTANCE 100000
> > set PIN_CONFIG_BIAS PULL_UP
> 
> So two calls to set the pull up instead of one?
> That does not look good.

Worry about that seems a bit like a micro-optimization to me, but I
somewhat see your point.

> > Of course, this probably ties into which of the following options your chip
> > HW has:
> >
> > a) Pull-up 100K or pull-up 10K or pull-down or tri-state
> >
> > b) Pull-up or pull-down or tri-state, with a second register field to
> > set pull-up at 100k or 10k.
> 
> But what registers to write and in which order doesn't matter
> for this interface. That is up to the driver and that is the kind
> of stuff drivers are supposed to figure out.
> 
> If the driver gets a single call which says "pull up" and
> a parameter "100k" it can very well figure out what to do
> with that.

Yes, that's true.

> >> Don't you mean we would then have
> >>
> >> pin_config_param {
> >>    PIN_CONFIG_INPUT_MODE,
> >>    ...
> >> }
> >>
> >> enum pin_config_input_mode_value {
> >>     PIN_CONFIG_INPUT_MODE_SCHMITT,
> >>     PIN_CONFIG_INPUT_MODE_DEBOUNCE,
> >> };
> >
> > Schmitt and debounce seem like completely orthogonal HW features to me,
> > so I wouldn't make them mutually exclusive.
> 
> True. But the above enumerators does not make them
> mutually exclusive do they? You can very well set both
> with two calls.

I'd expect that each pin_config_param has exactly one single value
associated with it. Hence, having Schmitt and debounce as the values
rather than the parameters does make them mutually exclusive.

-- 
nvpublic

