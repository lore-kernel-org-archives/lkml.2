Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1LTCW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:22:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38704 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1LTCW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:22:27 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF176BE92C1B@HQMAIL01.nvidia.com>
References: <1324249593-3051-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92C1B@HQMAIL01.nvidia.com>
Date: Tue, 20 Dec 2011 10:22:26 +0800
Message-ID: <CAN1soZwEj2SYa9eqH-Nyw0wvVF8kk7tn_gLu+BPDS3ZT1Has+Q@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: add support for group and pinmux states
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 8:24 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Sunday, December 18, 2011 4:07 PM:
>> This makes it possible for pin groups and pin muxes to go into
>> different states, which is especially useful for power management,
>> both runtime and across suspend/resume.
>
>> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
>
>> +Pin group states
>> +================
>> +
>> +To simplify handling of specific group states, such as when a group of
>> +pins need to be deactivated or put in a specific sleep state, the pin controller
>> +may implement a .pin_group_set_state() callback. This will for example be
>> +called automatically to set a certain pin group in active state when the groups
>> +are selected for use in a certain pin multiplexing configuration (see below).
>> +This is a good opportunity to set up any default pin configuration (see below)
>> +for the pins in a group.
>
> I don't think it's possible for a pinctrl driver to implement such a
> callback; the appropriate state for a pin may well be board-specific,
> and the pinctrl driver itself can't possibly know what that state is.
>
> For example, for some random pin that a board happens to be using as a
> GPIO - how does the pinctrl driver know whether that GPIO actually does
> something while in suspend; if the GPIO isn't used, the SoC can probably
> just turn off all drivers and pull-up/downs on the pin, but if the GPIO
> is used to control some aspect of a PMIC, it probably needs to be in a
> specific state during suspend. This kind of thing is entirely board-
> specific.
>
> Similarly, the sequencing of reprogramming of the various pins when
> entering/leaving suspend is most likely board specific, e.g. there may
> be a need to assert a "speaker mute" GPIO before de-asserting a GPIO
> that enables power to speaker amplifiers etc.
>

Do we really need to configure low power mode in device driver? In most time,
user will set and tune the low power mode of pins. If the low power setting
could be configured via sysfs, it could save a lot of time to rebuild kernel.

Especially GPIO pins are board specific. I think that configure all low power
setting in board specific code is more reasonable.

Thanks
Haojian
