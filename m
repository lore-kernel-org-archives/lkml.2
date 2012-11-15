Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768024Ab2KOO1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:27:07 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:57521 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767933Ab2KOO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:27:05 -0500
Date: Thu, 15 Nov 2012 15:26:52 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] RFC: pinctrl: grab default handler with bus notifiers
Message-ID: <20121115152652.44c567d5@skate>
In-Reply-To: <CACRpkdY-tye5LNOwxQ-XrjM-x9RffAvj-tPfsFQA3ZWOY8P-Vw@mail.gmail.com>
References: <1352636539-6318-1-git-send-email-linus.walleij@stericsson.com>
	<50A15A54.3090803@wwwdotorg.org>
	<20121113063546.GD18224@opensource.wolfsonmicro.com>
	<CACRpkdY-tye5LNOwxQ-XrjM-x9RffAvj-tPfsFQA3ZWOY8P-Vw@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Thu, 15 Nov 2012 15:03:40 +0100, Linus Walleij wrote:

> > I have to say that I agree with this, notifiers seem to make life more
> > complicated for limited gain.  Otherwise I guess we could enhance
> > notifiers so that they're able to trigger deferrals?
> 
> OK I'll have to come up with a patch to the device core
> instead... it'll be much simpler anyway and if both of you guys
> can back it I guess Greg might be OK with it too.

At ELCE, I've discussed with one person having an interesting use case:
they are using the same pin for two different purposes during the
system operation.

At boot time, this pin is muxed as a SPI pin and is used to program the
bitstream of a FPGA. This is done in Linux, through a userspace
application.

Then, once it is done, this pin is remuxed as a UART pin, and used to
communicate with another device on the board.

If the pinctrl configuration is done at probe() time inside the driver
core, then how can this kind of use case be supported? If each driver
does its own muxing, we could think of letting the SPI and UART driver
only do their muxing when the device is opened, and remove their muxing
when the device is closed, so that such sharing of pins for two
separate functions could be supported. Is this something we want to
support?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
