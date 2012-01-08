Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2AHXgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:36:55 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:35559 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603Ab2AHXgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:36:54 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A01F@HQMAIL01.nvidia.com>
References: <1324249593-3051-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92C1B@HQMAIL01.nvidia.com>
	<CACRpkdaQriLV0uxTdX1juJZ7ERAa0tcMGC4UyfXASTo4txub5g@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE3A01F@HQMAIL01.nvidia.com>
Date: Mon, 9 Jan 2012 00:36:53 +0100
Message-ID: <CACRpkdZnhW7tT0EtoDOx8gXP0vV0zCLWAVmemD=K4D2t2HuMdA@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: add support for group and pinmux states
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 7, 2012 at 12:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Linus Walleij wrote at Monday, January 02, 2012 4:36 AM:

> The main issue I see is that:
>
> * With the current pin mux API, the driver is simply defining what the
> SoC can do, and the mapping table (outside the driver) is selecting which
> of those things to do. There's zero knowledge (or need) of board-specific
> data in the pin mux driver.
>
> * With your proposal for pin configuration, the driver still of course
> defines what the SoC can do since it must implement it, but also the
> (e.g. platform) data that defines which of those things to do is now
> Handled by the driver rather than the pinctrl/pinconfig core.
>
> That seems like a needless semantic difference.

I'm  buying this and the following argument. I need to come up with
something better. Apparently this idea of states need to be paired
with a proper state configuration table like you suggest, so no
shortcuts (I was hoping to do one, then the other) I will have to
code it all in one go.

One minor thing:

> IIRC, I was talking about two different kinds of states.
>
> The PIN_GROUP_STATE_* you quoted above are individual pin group states.
>
> The "standard states" in the second chunk I wrote above was regarding
> states of an entire device (a pmx entry I think)

They were to use the same states.

Since a PMX corresponds to one or more groups these are easy
to couple, that's what it's all about. So setting the state of a pmx just
falls through to the state of it's mapped in groups. And if these
share the same syntax, it's a quick thing to do.

This will work with string-named states too I think, we'll see.

Yours,
Linus Walleij
