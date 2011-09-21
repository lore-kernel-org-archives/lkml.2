Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1IUTjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:39:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16913 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1IUTjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:39:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 21 Sep 2011 12:39:49 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Date: Wed, 21 Sep 2011 12:39:46 -0700
Subject: RE: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
Thread-Topic: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
Thread-Index: Acx4N/r02VwNNlYfSwmp3Dxi3VmfBgAXb1zw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1738180164@HQMAIL01.nvidia.com>
References: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B7321777@HQMAIL01.nvidia.com>
 <CACRpkdY5ETbJxSpwJL-7KZhjOnhwrdT1=djwByek75ye=S9L9w@mail.gmail.com>
In-Reply-To: <CACRpkdY5ETbJxSpwJL-7KZhjOnhwrdT1=djwByek75ye=S9L9w@mail.gmail.com>
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

Linus Walleij wrote at Wednesday, September 21, 2011 2:25 AM:
> On Wed, Sep 21, 2011 at 12:15 AM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Friday, September 16, 2011 6:14 AM:
> >> +     for (i = 0; i < ARRAY_SIZE(u300_mux_hogs); i++) {
> >> +             struct pinmux *pmx;
> >> +             int ret;
> >> +
> >> +             pmx = pinmux_get(u300_mux_hogs[i].dev, NULL);
> >> +             if (IS_ERR(pmx)) {
> >> +                     pr_err("u300: could not get pinmux hog %s\n",
> >> +                            u300_mux_hogs[i].name);
> >> +                     continue;
> >> +             }
> >> +             ret = pinmux_enable(pmx);
> >> +             if (ret) {
> >> +                     pr_err("u300: could enable pinmux hog %s\n",
> >> +                            u300_mux_hogs[i].name);
> >> +                     continue;
> >> +             }
> >> +             u300_mux_hogs[i].pmx = pmx;
> >> +     }
> >> +     return 0;
> >> +}
> >> +subsys_initcall(u300_pinmux_fetch);
> >
> > Why not just have the pinmux core support hogging on non-"system" mapping
> > entries; then everything I quoted above except u300_pinmux_map[] could
> > be deleted, and the "hog" flag set on the last 3 u300_pinmux_map[] entries.
> 
> Very good question, luckily I have a good answer.
> 
> There is no way for the pinmux core to traverse the system and look
> up the apropriate struct device * pointers.

It's unclear to me why that would be needed.

For non-system mappings, either the device-driver in question will be
get'ing and enabling them (this case isn't relevant to this discussion),
or they'll be hogged. In the hog case, I doubt anything would ever want
to disable them and switch the device to a different mapping entry; if
that were the case, the entries shouldn't be hogged, but get/enabled by
the device anyway. Hence, I don't see the need for an activation of a
hog'd non-system mapping entry to care about the device fields that are
in the mapping table at all; they could just be ignored couldn't they?

> When/if we have device tree support, I think this will be possible, then I
> will be able to have the pinmux hog look up devices from device tree
> and hog their pinmux.
> 
> At that point we'll likely have the mapping in the device tree too and
> the core does not need to be involved at all.
> 
> What I could do right now is add some open-ended function like
> pinmux_hog_device_pinmuxes(struct device **devices);
> that can take an array of devices and hog their respective
> pinmuxes in the hog list. Do you think it's a good idea?

-- 
nvpublic

