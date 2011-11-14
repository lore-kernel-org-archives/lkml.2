Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1KNTAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:00:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11301 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1KNTAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:00:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 Nov 2011 11:00:49 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Inderpal Singh <inderpal.singh@linaro.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Nov 2011 11:00:45 -0800
Subject: RE: [PATCH] ARM: SAMSUNG: Save/restore GPIO drive strength across
 suspend/resume
Thread-Topic: [PATCH] ARM: SAMSUNG: Save/restore GPIO drive strength across
 suspend/resume
Thread-Index: Acyi1TiyTkW5Rm9cSg+KxymSKnj2ewAKhOrQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805B13@HQMAIL01.nvidia.com>
References: <1321074108-10025-1-git-send-email-inderpal.singh@linaro.org>
	<CACRpkdbC=w5vRvgLVpAcmcampt-baTydpLHBexak4RzxUcO32Q@mail.gmail.com>
 <CAJuYYwSvRYWdoccSN3nU7G4zXyTjt7vkjAd_vDx=QchG+yd5Cg@mail.gmail.com>
In-Reply-To: <CAJuYYwSvRYWdoccSN3nU7G4zXyTjt7vkjAd_vDx=QchG+yd5Cg@mail.gmail.com>
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

Thomas Abraham wrote at Monday, November 14, 2011 6:57 AM:
> On 12 November 2011 16:30, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Sat, Nov 12, 2011 at 6:01 AM, Inderpal Singh
> > <inderpal.singh@linaro.org> wrote:
> >
> >> GPIO driver strength settings are not preserved across suspend/resume
> >> for s5pc100, s5pv210 and Exynos platforms which has been the cause of
> >> mmc/sd card read/write failures after resume. Fix this by saving and
> >> restoring the GPIO driver strength register settings across suspend/resume.
> >>
> >> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> >
> > On a related theme: I am thinking about how to support preserving
> > drive strength (etc) across suspend/resume and deepsleep in the
> > pincontrol subsystem.
> >
> > Currently I am playing with the idea to let pin groups have states,
> > as the different configurations seem to be 90% or so about very
> > specific sleep modes, so say:
> >
> > pinconf_set_group_state("mmcgroup", PINCONF_STATE_ACTIVE);
> > pinconf_set_group_state("mmcgroup", PINCONF_STATE_SUSPENDED);
> > pinconf_set_group_state("mmcgroup", PINCONF_STATE_SLEEP);
> 
> 
> The API name suggests that power state is set based on a pin group.
> For a driver, the following could be convenient as the driver transits
> through various power management states.
> 
> struct pinmux pmx;
> pmx = pinmux_get(dev, "i2c0");
> 
> [...]
> 
> pinmux_set_state(pmx, PINCONF_STATE_SLEEP);
> [...]
> pinmux_set_state(pmx, PINCONF_STATE_ACTIVE);

That seems a more consistent driver-oriented API, yes.

I'd of course lean towards adding the pin config data into the mapping
table, and using the existing feature struct pinmux_map name field to
name those states, and allowing dynamic transitioning between states,
rather than adding a complete new API and namespace for these states.

-- 
nvpublic

