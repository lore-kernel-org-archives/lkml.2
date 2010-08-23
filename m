Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0HWJ51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:57:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58297 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751551Ab0HWJ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:57:25 -0400
Date: Mon, 23 Aug 2010 10:57:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH 1/2] spi/spi_s3c64xx: Make probe
 more robust against missing board config
Message-ID: <20100823095722.GA6061@rakim.wolfsonmicro.main>
References: <1282321028-32196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTimggbZqgv=eKe+wx8YvUX5vOppDfmwpLwTgxJFM@mail.gmail.com>
 <20100821100855.GA5545@opensource.wolfsonmicro.com>
 <AANLkTikbGR4wWUEHjR74UFu8P-w9us3ZpKgmG+yDukfC@mail.gmail.com>
 <20100821193015.GA16455@opensource.wolfsonmicro.com>
 <AANLkTikDj7YsOQXnFGjZCNRYuQQbLRtKiWw5Sm=vkCuq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikDj7YsOQXnFGjZCNRYuQQbLRtKiWw5Sm=vkCuq@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 12:37:25PM +0900, Jassi Brar wrote:

> An immediate kernel crash ? :)
> I mean if the developer didn't even run-check the board init code, he ought
> to face a kernel crash.
> On a more lenient note, probably a check like yours or !sci->num_cs
> could be added.

I'd personally not actually be that upset with a BUG_ON(), my main
reason for changing the code was that it was non-obvious what the source
of the error was rather than the fact that things fell over.

> > It did occur to me that a nice way of dealing with this would be to have
> > the driver default to using the built in chip select (even if driven as
> > a GPIO for the sake of code simplicity) but leave the current method
> > there as an override.  That way if people are using the IP block in the
> > "natural" manner they'd have less to set up.

> I thought about it but decided against it, for that would complicate the
> driver by having to switch between two mechanism in runtime and there
> are some peculiarities in the controller about clocking and CS'ing.

Yeah, that's why I suggested driving it as a GPIO for simplicity - from
the user point of view it doesn't matter if that's what the controller
does so long as the driver figures out the chip select without external
help.
