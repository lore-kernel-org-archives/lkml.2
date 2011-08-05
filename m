Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1HEUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:25:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55040 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1HEUZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <20110805103045.GG28651@trinity.fluff.org>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com>
	<20110805094017.GC20575@n2100.arm.linux.org.uk>
	<20110805103045.GG28651@trinity.fluff.org>
Date: Fri, 5 Aug 2011 22:25:55 +0200
Message-ID: <CACRpkdai55JSN+dkaYu96FTDDVSa8bHZFkBS6M1u3gPUDmpE_g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] If an IRQ is a GPIO, request and configure it
From: Linus Walleij <linus.walleij@linaro.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, ccross@android.com, olof@lixom.net,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 12:30 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Fri, Aug 05, 2011 at 10:40:17AM +0100, Russell King - ARM Linux wrote:
>> Trying to go from IRQ to GPIO is not a good idea - most of the
>> IRQ <-> GPIO macros we have today are just plain broken.  Many of them
>> just add or subtract a constant, which means non-GPIO IRQs have an
>> apparant GPIO number too.  Couple this with the fact that all positive
>> GPIO numbers are valid, and this is a recipe for wrong GPIOs getting
>> used and GPIOs being requested for non-GPIO IRQs.
>
> Yes, and there's a pile without these defined/

And I'm piling a few patches *deleting* irq_to_gpio() from platforms that
define but actually don't use it, like U300 and SA1100.

Linus Walleij
