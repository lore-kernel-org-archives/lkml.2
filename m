Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2BURY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:24:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18962 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2BURY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:24:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 21 Feb 2012 09:23:58 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 09:23:54 -0800
Subject: RE: [PATCH 04/20] pinctrl: Record a pin owner, not mux function,
 when requesting pins
Thread-Topic: [PATCH 04/20] pinctrl: Record a pin owner, not mux function,
 when requesting pins
Thread-Index: AczwFMHwm3BfBnsOThGBX22MbT2tvgAqGBJA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC309@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-5-git-send-email-swarren@nvidia.com>
 <CACRpkdYCkRrvt+2B2nzAR+4XTeZo=N+OVA49TuExHCwsLAExwg@mail.gmail.com>
In-Reply-To: <CACRpkdYCkRrvt+2B2nzAR+4XTeZo=N+OVA49TuExHCwsLAExwg@mail.gmail.com>
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

Linus Walleij wrote at Monday, February 20, 2012 2:15 PM:
> On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > When pins are requested/acquired/got, some device becomes the owner of
> > their mux setting. At this point, it isn't certain which mux function
> > will be selected for the pin, since this may vary between each of the
> > device's states in the pinctrl mapping table. As such, we should record
> > the owning device, not what we think the initial mux setting will be,
> > when requesting pins.
> >
> > This doesn't make a lot of difference right now since pinctrl_get gets
> > only one single device/state combination, but this will make a difference
> > when pinctrl_get gets all states, and pinctrl_select_state can switch
> > between states.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Mostly a rename then, OK...
> 
> > @@ -66,19 +65,14 @@ static int pin_request(struct pinctrl_dev *pctldev,
> >                goto out;
> >        }
> >
> > -       if (!function) {
> > -               dev_err(pctldev->dev, "no function name given\n");
> > -               return -EINVAL;
> > -       }
> > -
> 
> Why should it be allowed to have a NULL owner? There is a
> debug print involving it above but ... maybe this is over-cautious?

My reasoning was that this is an internal function, so this isn't a user-
supplied parameter we need to be paranoid about checking, and the places
that call this function internally "obviously" don't pass NULL owner.
Well, I suppose one place relies on the fact we checked elsewhere that
map->dev_name != NULL.

Still, I can see a defensive programming argument for keeping that check,
although I suspect if we apply that argument we should probably check a
lot more things too throughout the code?

-- 
nvpublic

