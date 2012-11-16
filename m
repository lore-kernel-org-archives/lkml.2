Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab2KPLgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:36:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45276 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPLgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:36:35 -0500
MIME-Version: 1.0
In-Reply-To: <50A53304.6040904@wwwdotorg.org>
References: <1352636539-6318-1-git-send-email-linus.walleij@stericsson.com>
	<50A15A54.3090803@wwwdotorg.org>
	<20121113063546.GD18224@opensource.wolfsonmicro.com>
	<CACRpkdY-tye5LNOwxQ-XrjM-x9RffAvj-tPfsFQA3ZWOY8P-Vw@mail.gmail.com>
	<50A53304.6040904@wwwdotorg.org>
Date: Fri, 16 Nov 2012 12:36:33 +0100
Message-ID: <CACRpkdYd6B-fTfUg18q5BjZRbY7sUAUNXA_7VPBs9SQoug9Q4w@mail.gmail.com>
Subject: Re: [PATCH] RFC: pinctrl: grab default handler with bus notifiers
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 7:23 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/15/2012 07:03 AM, Linus Walleij wrote:

>> OK I'll have to come up with a patch to the device core
>> instead... it'll be much simpler anyway and if both of you guys
>> can back it I guess Greg might be OK with it too.
>
> I did have one thought here; how will this interact with hogs? If a
> device's pinctrl configuration must be pinctrl_get()'d before the device
> is probed, then a pinctrl device with hogs will never get probed because
> it won't be registered to provide the pinctrl node parsing.

Catch 22 :-(

Yeah we need to come up with something there.

> Solutions might include:
>
> a) Some special case where if the pinctrl driver only can't probe due to
> missing pinctrl from its own node, don't defer the probe, but defer the
> pinctrl_get().
>
> b) Separate out DT node parsing from device instantiation, so that the
> driver can always parse the DT, without needing the context of a
> specific pinctrl device to do so.

But this mechanism can't be device tree-specific, we have some
of olschool pdata users and ACPI probing around the corner.

I will likely just cook up something like seeing if the
dev_name() for provider and consumer is the same and
in that case avoid deferral.

Oh well, I'll try to actually code this now...

Yours,
Linus Walleij
