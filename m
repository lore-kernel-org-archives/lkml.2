Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab2INNsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:48:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65524 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2INNsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120913221125.GA10032@glitch>
References: <1347519686-10170-1-git-send-email-linus.walleij@stericsson.com>
	<505205B1.4080708@wwwdotorg.org>
	<20120913221125.GA10032@glitch>
Date: Fri, 14 Sep 2012 15:48:05 +0200
Message-ID: <CACRpkdb+QC_iHOkoihqxDgC+b+PUij-qi6BiOKmnCB3vPnJTjw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: document semantics vs GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:11 AM, Domenico Andreoli <cavokz@gmail.com> wrote:
> On Thu, Sep 13, 2012 at 10:11:29AM -0600, Stephen Warren wrote:

>> I think it makes sense to more strongly recommend that for GPIO muxing,
>> the GPIO driver always call into the pinctrl subsystem (if needed by the
>> HW) to perform that muxing, so that standalone gpio_direction_*() always
>> work without any use of pinctrl; the interaction between the two should
>> only be required if pin configuration (not just pin muxing) is also
>> required.
>
> Don't know. Isn't possible to reach the same effect moving this kind
> of knowledge into higher level helper functions and remove this bridge
> across the subsystems?

I'm not following, please elaborate on this.

What are these higher level functions, and where will they be
located? In which subsystem, and using what symbols/signatures and
so on?

Deepak or Arnd suggested to add a set of functions to the pinctrl
driver vtable and make it possible to implement a generic gpio_chip
deeply merged with a pin controller driver. I'm considering this,
since it would also be a natural stepping stone to the /dev/pinctrl0
device(s) I want to see for userspace access the day we need it.

> Because there is also the pin config stuff that
> may require special mixing as well and it's clear that there is no space
> for it in these calls.

Yes but it is clear from the above that this need to be handled by
pin control, either through hogs or as a last resort at runtime
in the driver.

Yours,
Linus Walleij
