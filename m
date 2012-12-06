Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2LFTZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:25:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41563 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab2LFTZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:25:06 -0500
MIME-Version: 1.0
In-Reply-To: <1354765784.12428.3.camel@trivette.home.lan>
References: <1348620130-25987-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<CACRpkdaaD6HY2o-NNBRZYCXm97Dts7Njzz13Zj7m2ZycV-Ar5g@mail.gmail.com>
	<1349720405.23690.45.camel@trivette>
	<CACRpkdbbungMiZ74o=-CfRoLQj127CaWaYr7adKKSquFd=x5qg@mail.gmail.com>
	<1354765784.12428.3.camel@trivette.home.lan>
Date: Thu, 6 Dec 2012 20:25:04 +0100
Message-ID: <CACRpkdYZXvjwcu3=7=KY6gd8b7dY7hPE=KGPMXpPELLym3A_gw@mail.gmail.com>
Subject: Re: [PATCH] gpio: add TS-5500 DIO headers support
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 4:49 AM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:

> I looked at some drivers and if I'm not mistaken, this case is
> different. Technologic Systems platforms (such as the TS-5500) have
> several pin blocks. Each block has input-only, input-output or
> output-only pins. Only one pin per block is connected to an interrupt
> line. But sadly, these interrupt-connected lines are input only.
> Here are the details about the TS-5500 pin block "DIO1":
>
> http://wiki.embeddedarm.com/wiki/TS-5500#DIO1_Header

Aha I get it now. How odd ... OK we need to support this too.

> That's why I previously used a dio1_irq platform data field, to return
> the interrupt connected to the IRQ-able pin for any GPIO on DIO1, in the
> gpio_to_irq() implementation.

OK I get it.

> A Linux IRQ per pin doesn't seem to be possible because the
> irq_create_mapping() documentation says that "Only one mapping per
> hardware interrupt is permitted." Should I still implement the
> irq_chip/irqdomain for a single IRQ per block? For each pin?
> What do you think about this implementation?

So basically there are in total three pins and yeah this is too
little and too strange to warrant an irqdomain so go ahead
with it as it looks and fix the other comments. I'm happy with
keeping this now.

Linus Walleij
