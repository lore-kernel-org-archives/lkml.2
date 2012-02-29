Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031269Ab2B2R13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:27:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4752 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031240Ab2B2R12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:27:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 29 Feb 2012 09:27:23 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Date: Wed, 29 Feb 2012 09:27:22 -0800
Subject: RE: [PATCH] pinctrl: make the pinmux-pins more helpful
Thread-Topic: [PATCH] pinctrl: make the pinmux-pins more helpful
Thread-Index: Acz2xfCUW24XGeS1RpWUU1sHR0AgcAAQRp6Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF2083@HQMAIL01.nvidia.com>
References: <1330062969-25016-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC79@HQMAIL01.nvidia.com>
 <CACRpkdZ-a+kyknb-q+_=TLGcNshwkLAY4918bwD7e6LzL3sWbg@mail.gmail.com>
In-Reply-To: <CACRpkdZ-a+kyknb-q+_=TLGcNshwkLAY4918bwD7e6LzL3sWbg@mail.gmail.com>
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

Linus Walleij wrote at Wednesday, February 29, 2012 2:39 AM:
> On Fri, Feb 24, 2012 at 5:44 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > If we do make a change like this, I'd prefer the format to be:
> >
> > UNCLAIMED
> > "%s (HOG)", desc->owner
> > desc->owner
> 
> I don't see the point, the debugfs files are supposed to be
> human-readable, a human is not interested in the fact that
> the pinctrl device itself is owning the pin, what is interesting is
> that it is hogged.

Well, I'm a human and I care far more that the pin controller device is
what owns the configuration rather than some artificial "hog" concept
is present...

> >> I somewhat mourn the loss of being able to tell from the debugfs
> >> which function is using a certain pin, does anyone have ideas on
> >> how to go about fixing this properly? The root file
> >> pinctrl-handles does tell it, but requires cross-referencing
> >> which isn't helpful.
> >
> > This doesn't seem like a big deal to me; it's very easy to cross-
> > reference.
> 
> Not to me it isn't, looks like I would have to create scripts to
> do that for a large pin controller and that's less helpful than
> just having the information there.
> 
> > That said, we could either:
> >
> > a) Add a field to pin_desc which indicates current usage. This would be
> > set whenever the pin's mux function was set, i.e. in pinctrl_select_state()
> > or pinctrl_request_gpio().
> 
> That's like re-introducing the former "function" field I guess.
> 
> Simple if I just also #ifdef CONFIG_DEBUGFS... so I'd go
> for this.
> 
> > b) Add a pinctrl driver ops function which reads and prints the current
> > state from HW.
> >
> > (and note the fact that having the debug file list the current mux
> > function per pin doesn't really make sense on HW where the muxing is
> > per group...)
> 
> On U300 it makes a lot of sense even thogh it is essentially
> group based. When sitting with the datasheet with the pin names
> and use groups it's simple to see exactly how any one pin is muxed
> for the moment and troubleshoot from there.

If the HW muxes per group, then there's no concept of "which function is
selected for a pin", since functions are selected for a group not for a
pin.

So, the datasheet will be written in terms of "group X supports functions
A, B, C, D", not pins P, Q, R support functions "A, B, C, D". So,
representing mux function in debugfs at the group level would make a lot
more sense given that HW design.

-- 
nvpublic

