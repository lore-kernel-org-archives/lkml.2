Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab1JTSq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 14:46:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5445 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1JTSqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 14:46:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 20 Oct 2011 11:46:20 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Oct 2011 11:46:19 -0700
Subject: RE: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Topic: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Index: AcyPEoSX+YPo/KZERlGiMNQmaOpphAARZUKg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173D51C23C@HQMAIL01.nvidia.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173D51C039@HQMAIL01.nvidia.com>
 <CACRpkdastuCyqXcjm0PT44FnDY4HzxPMFT+M-VQuqXSGM6XjzQ@mail.gmail.com>
In-Reply-To: <CACRpkdastuCyqXcjm0PT44FnDY4HzxPMFT+M-VQuqXSGM6XjzQ@mail.gmail.com>
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

Linus Walleij wrote at Thursday, October 20, 2011 4:25 AM:
> On Thu, Oct 20, 2011 at 1:04 AM, Stephen Warren <swarren@nvidia.com> wrote:
...
> >> + * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
> >> + *   mode, also know as "third-state" (tristate) or "high-Z" or "floating".
> >> + *   On output pins this effectively disconnects the pin, which is useful
> >> + *   if for example some other pin is going to drive the signal connected
> >> + *   to it for a while. Pins used for input are usually always high
> >> + *   impedance.
> >> + * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
> >> + *   impedance to VDD), if the controller supports specifying a certain
> >> + *   pull-up resistance, this is given as an argument (in Ohms) when
> >> + *   setting this parameter
> >
> > What value should be used to disable a pull-up; 0?
> 
> A semantic question would also be if pull up is implicitly disabled
> if you issue PIN_CONFIG_BIAS_PULL_DOWN when you are
> in PULL_UP state.
> 
> I added PIN_CONFIG_BIAS_DISABLED  to
> set_pin_config(pin, PIN_CONFIG_BIAS_DISABLED);
> 
> So we can transition to a state of totally disabled pin bias.

I'm not too sure I like that; the core's definition of PIN_CONFIG_BIAS_*
is then imposing semantics that the HW might not have.

So, Tegra's pull configuration is up/down/none, as a register field with
3 values.

Another chip could easily have 1 bit to pull-up-enable and a separate
bit for pull-down-enable. It might be silly to set them both, but the HW
could quite easily be designed such that it'd work as one would exect
electrically.

I'm not convinced that the PIN_CONFIG_BIAS_* definitions should be defined
to force one model over the other. With SoC-defined param names, the
pinctrl driver can expose exactly what the HW supports without abstraction.

And how to hide the abstraction from drivers? Some kind of mapping table
or API; see my other email for details.

-- 
nvpublic

