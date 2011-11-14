Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1KNOYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:24:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39487 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1KNOYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZvnD_UfuYwoexdCHRmON_o_ec8=dnOaDNhBrRz1WjMfw@mail.gmail.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
	<CAJuYYwRy-oy6MXxrPs+CZU=C2VcvV=-fVfju5Jfc1jJRp1ousg@mail.gmail.com>
	<CACRpkdZvnD_UfuYwoexdCHRmON_o_ec8=dnOaDNhBrRz1WjMfw@mail.gmail.com>
Date: Mon, 14 Nov 2011 19:54:36 +0530
Message-ID: <CAJuYYwQe3AYZjV1iENQCwYzyQTLzxkCCX-9AAAEH0=_pSNzhWQ@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: add a generic pin config interface
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2011 15:06, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Nov 11, 2011 at 12:26 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>

[...]

>> Samsung parts have a 'drive strength' config option for the pads. The
>> drive strength is represented as 1x, 2x, 4x, etc .. depending on the
>> SoC. The config param that can be used to represent drive strength in
>> this case could be PIN_CONFIG_POWER_SOURCE. Or should there be another
>> config param for representing drive strength? Otherwise, the above
>> config param options are sufficient for all existing Samsung SoC's.
>
> I strongly suspect that you want to use
> PIN_CONFIG_DRIVE_PUSH_PULL with a custom argument
> representing the drive strength as "data" passed in the call.
>
> Moste "strong" driving is done by push/pull (the others are just oddities)
> and if you want to specify a number representing drive strength, the
> data parameter is there to do exactly that. For this drive mode the
> parameter does not have defined semantics, so you can interpret it
> the way you need in your driver.

Ok.

>
> That said, 1x, 2x, 4x aren't exactly scientific - what does this really
> represent, speaking electronics?

I have not attempted to understand that yet.

>
> On some forum I found this:
> http://www.edaboard.com/thread74140.html

Thanks for the link. This was very informative.

[...]

> In practice is seems: 2x = 2 transistors in driver stage, 4x =
> 4 transistors in driver stage etc.
>
> Maybe we should simply standardize the semantics of the
> data argument to PIN_CONFIG_DRIVE_PUSH_PULL
> to mean "x times nominal load capacitance with equal
> rise/fall times"?

Ok. This should be fine for Exynos platforms. But it might not seem
intuitive to use PIN_CONFIG_DRIVE_PUSH_PULL for driver strength.
Probably, this might need additional documentation.

>
> Alternatively we could use the
> PIN_CONFIG_SLEW_RATE_RISING and
> PIN_CONFIG_SLEW_RATE_FALLING for this,
> however there I defined the semantics to be in
> nanoseconds, assuming that electronics that can control
> this have more delicate amplifiers, and in this case I
> think it is more about limiting the rise/fall time by shunting
> in resistances in the circuit.

Ok. As everybody might not understand the electronics behind the
driver strength, it would be difficult to use RATE_RISING and
RATE_FALLING config options. Maybe we should have a simpler config
option that is easy to understand and program for drive strength.

Thank you Linus.

Regards,
Thomas.

>
> Yours,
> Linus Walleij
>
