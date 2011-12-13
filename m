Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1LMVtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 16:49:25 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16786 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1LMVtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 16:49:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Dec 2011 13:49:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Date: Tue, 13 Dec 2011 13:49:15 -0800
Subject: RE: [PATCH v6] pinctrl: add a pin config interface
Thread-Topic: [PATCH v6] pinctrl: add a pin config interface
Thread-Index: Acy5Z9z1ZgIdfj1bSUyk+VJpEpQSzAAeIsrA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1751860BDA@HQMAIL01.nvidia.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<CAN1soZztU+gC3tkzXK5m51-+djqqcC_JhiJyc4xys2K_ZxUnGA@mail.gmail.com>
	<CACRpkdYFvRDegS63EQzp8pjRMUj7Ru57bK7a+Qq81OkBXmrCBQ@mail.gmail.com>
 <CAN1soZw=51caZjEoxBx8ch0KiE-kgHQFA1amRcTOyDDKe5Ymzw@mail.gmail.com>
In-Reply-To: <CAN1soZw=51caZjEoxBx8ch0KiE-kgHQFA1amRcTOyDDKe5Ymzw@mail.gmail.com>
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

Haojian Zhuang wrote at Tuesday, December 13, 2011 12:22 AM:
> On Tue, Dec 13, 2011 at 8:22 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Mon, Dec 12, 2011 at 7:19 AM, Haojian Zhuang
> > <haojian.zhuang@gmail.com> wrote:
> >
> >> You mentioned that pin_config_set() is used in below.
> >> ret = pin_config_set(dev, "FOO_GPIO_PIN", PLATFORM_X_PULL_UP);
> >>
> >> struct pinctrl_dev is created while pinmux is registered. I think this
> >> structure is always internal structure. It can't be observed by
> >> platform driver or device driver.
> >
> > True. Was fixed today by a patch from Stephen Warren that
> > simply cuts out the middleman and use the original platform
> > device directly. Kudos to Stephen for fixing this!
> >
> > Linus Walleij
> 
> Excuse me that I didn't find that patch. Did you merge it into your
> git tree? The latest patch on pinconf.c is updating pdev->dev to
> &pdev->dev.

I just hit the same problem. This isn't what my patch addresses.

My patch prevents the pinctrl core from creating a struct device for the
pin controller, since it already has one.

The problem that Haojian mentions is regarding struct pinctrl_dev, not
plain device.

I'd suggest modifying all the pin_config_* APIs to take a device name
rather than a "struct pinctrl_dev *". I'll work on a patch to do this,
since I'm hitting the same problem.

An alternative may be to either:

* Add function pinctrl_get_dev_by_name(name)

Or:

* Use dev = bus_find_device_by_name(name) to get the plain device, and
add a pinctrl_find_dev_by_dev(dev).

Either of those sound more complex though, but I suppose do allow
direct operation if you somehow do already have the struct pinctrl_dev.

-- 
nvpublic

