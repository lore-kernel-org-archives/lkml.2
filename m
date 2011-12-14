Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab1LNPom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:44:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10329 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab1LNPok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:44:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Dec 2011 07:44:29 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Date: Wed, 14 Dec 2011 07:44:26 -0800
Subject: RE: [PATCH v6] pinctrl: add a pin config interface
Thread-Topic: [PATCH v6] pinctrl: add a pin config interface
Thread-Index: Acy6P49Tecgq5cqyQLCVvpUhJaZ5UgANysUQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF176B446FFA@HQMAIL01.nvidia.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<010201ccba2e$9b4564e0$d1d02ea0$%park@samsung.com>
 <CACRpkdasJkhAdtBSRe4B3rWFdU67HqPKv=Nji3Xnxc2GE3misQ@mail.gmail.com>
In-Reply-To: <CACRpkdasJkhAdtBSRe4B3rWFdU67HqPKv=Nji3Xnxc2GE3misQ@mail.gmail.com>
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

Linus Walleij wrote at Wednesday, December 14, 2011 2:06 AM:
> On Wed, Dec 14, 2011 at 8:04 AM, Chanho Park <chanho61.park@samsung.com> wrote:
> 
> >> ChangeLog v5->v6:
> >> - Change to using a pin name as parameter for the
> >>   [get|set]_config() functions, as suggested by Stephen Warren.
> >>   This is more natural as names will be what a developer has
> >>   access to in written documentation etc.
> >
> > I don't agree with it.
> > Someone doesn't like to assign a pin name individually because a
> > pin number is sufficient to represent each pin.
...
> What turned me around to see things Stephen's way was the fact
> that if someone reads this code and finds:
> 
> pin_config_set(dev, 42, MY_FUNNY_PULLUP_MACRO);
> 
> It is harder to understand than:
> 
> pin_config_set(dev, "I2C0 SCL", MY_FUNNY_PULLUP_MACRO);

You could mitigate the opaqueness of the numbers by having the pinctrl
driver export a header of #defines for the pin numbers, so this could be:

pin_config_set(dev, FOO_PMX_PIN_I2C0_SCL, MY_FUNNY_PULLUP_MACRO);

Still, using strings avoids the need to do this.

Equally, I don't see the disadvantage of using strings here. In earlier
discussions, I thought we already discussed making pin names mandatory,
which seems to avoid most of Chanho's objections?

-- 
nvpublic

