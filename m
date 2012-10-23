Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab2JWJNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:13:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63889 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab2JWJNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:13:07 -0400
MIME-Version: 1.0
In-Reply-To: <20121022155028.GA13791@core.coreip.homeip.net>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121022155028.GA13791@core.coreip.homeip.net>
Date: Tue, 23 Oct 2012 11:13:05 +0200
Message-ID: <CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: tony@atomide.com, b-cousson@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 5:50 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Sourav,
>
> On Mon, Oct 22, 2012 at 06:43:00PM +0530, Sourav Poddar wrote:
>> Adapt keypad to use pinctrl framework.
>>
>> Tested on omap4430 sdp with 3.7-rc1 kernel.
>
> I do not see anything in the driver that would directly use pinctrl. Is
> there a better place to select default pin configuration; maybe when
> instantiating platform device?

The option is to use pinctrl hogs. Then the pins will be taken,
muxed and configured by the pin controller itself.

Another option (not implemented) is to use bus notifiers.

(I wrote about this in some other thread but can't find it now.)

Each approach above come with its own set of problems.

If the driver need to handle multiple states like default/idle/sleep
it is IMO better to put the handling into the driver, so if that
is what is going to happen also to this driver it could be a good
idea to actually implement that code upfront and include in
this submission so as to show that this driver is really going
to exercise its pins.

But it's also a question of conformity: if other drivers in the
system is using different states and this is the only one
using a single "default" state, then it doesn't make sense
to have just one driver get its pins using hogs, it's just
inconsistent.

So Sourav, please tell us a bit about your plans for this
and other drivers!

Yours,
Linus Walleij
