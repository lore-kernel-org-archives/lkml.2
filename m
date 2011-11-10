Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab1KJIkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:40:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58038 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab1KJIkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:40:19 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17408051C2@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17408051C2@HQMAIL01.nvidia.com>
Date: Thu, 10 Nov 2011 09:40:18 +0100
Message-ID: <CACRpkdY8YXooD5ChHqQnERPPGhk7TgUvL=TodAPY8Jit9eS=fw@mail.gmail.com>
Subject: Re: pinctrl discussions @ Linaro Connect, and also requesting GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 9, 2011 at 9:34 PM, Stephen Warren <swarren@nvidia.com> wrote:

> I'm curious about any pinctrl-related discussions that happened at Linaro
> Connect. Are you able to summarize any discussions/decisions, or point me
> at some existing summary? Especially anything to do with the new pin config
> options, possibly extending the mapping table to control them, etc.

There was not much of discussion really, and I didn't have any specific
pinmux session. It seems like most people with an interest in this were
in Prague, none in Orlando...

I'll make a patch with some kind of solution that I intutively came up
with, then we will probably refactor that a few good times before the
next merge window.

> Many drivers currently call gpio_request(). This is defined /not/ to
> perform any pinmux manipulation.

Is it?

I always though that the GPIO driver could call out to the pinctrl
counterpart.

For COH901* GPIO driver I plan to move the entire GPIO driver
to drivers/pinctrl/ and add pin config in the same file, then also
expose a pinctrl interface. This way the functionality can cross-call
each other using local statics. IIRC Grant also said ACKed this
approach to silicon that do combines pin control and GPIO in
one block especially.

> a) Should drivers explicitly call pinmux_request_gpio() before calling
> gpio_request() instead, so that the board files don't have to set this up
> first?

I hope not. I think the GPIO driver shall do this as part of
gpio_request().

> b) Shouldn't this be hidden inside the pinctrl's mapping table; if a driver
> needs to set up non-GPIO pinmux options, it's all done in pinmux_get() and
> pinmux_enable(), whereas for GPIOs they need to use the other API. Can we
> unify this?

Is there some problem with having it as part of gpio_request()?

> I think extending the mapping table to be able to represent either the
> existing mux configuration, or GPIO allocation, might make sense. In fact,
> if we do that, perhaps pinmux_{request,free}_gpio() wouldn't even be needed?

Hmmm I definately want different mappings for muxes and
pinctrl since they can be used as orthogonal concepts.

As for GPIO allocation thru mappings somekindof, I don't have a clear
picture. I always though of the cross-relationship between GPIO
and pin control as an intrinsic of each GPIO driver, not a system-wide
configuration problem.

Yours,
Linus Walleij
