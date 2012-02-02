Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab2BBSnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:43:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8629 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab2BBSnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:43:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 02 Feb 2012 10:43:14 -0800
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
Date: Thu, 2 Feb 2012 10:43:13 -0800
Subject: RE: [PATCH] pinctrl: pin configuration states
Thread-Topic: [PATCH] pinctrl: pin configuration states
Thread-Index: AczhF7n0EtTZMJGyTQaDKXFBBwnA4AAwn/UA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E124AD2@HQMAIL01.nvidia.com>
References: <1326725496-28928-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1780DAB15E@HQMAIL01.nvidia.com>
 <CACRpkdZAofVVQ5_b_R2FUWy5AfWOge1NOuO61q7vFiLB4wUizQ@mail.gmail.com>
In-Reply-To: <CACRpkdZAofVVQ5_b_R2FUWy5AfWOge1NOuO61q7vFiLB4wUizQ@mail.gmail.com>
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

Linus Walleij wrote at Wednesday, February 01, 2012 12:29 PM:
> On Thu, Jan 19, 2012 at 8:03 PM, Stephen Warren <swarren@nvidia.com> wrote:
...
> >> +     /*
> >> +      * Make a copy of the config state array - string pointers will end up
> > ...
> >> +     pinconf_states = tmp;
> >> +     pinconf_states_num += num_states;
> >
> > We need to allow multiple tables to be registered, for all the same
> > reasons we do for the pinmux mapping table. This implementation only
> > keeps the most recently registered table.
> 
> ? beats me.
> 
> Please check the code for how I realloc the tmp variable (in the v2
> patch set), I cannot spot the problem. It was designed to allow exactly
> multiple calls to add tables piece by piece.

Sorry, I must have been asleep when I wrote that...

I was expecting the implementation to copy each table separately and
store them in a list (since this would allow easy dynamic removel of the
entries too), hence when I saw the assignment to a single global, I
assumed it was just over-writing it; I guess I didn't even look at the
realloc above or noticed that it was assigning "tmp" not just the caller-
supplied parameter:-(

-- 
nvpublic

