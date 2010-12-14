Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab0LNQ6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:58:18 -0500
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:34411 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759326Ab0LNQ6Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:58:16 -0500
MIME-Version: 1.0
In-Reply-To: <795969.76999.qm@web180308.mail.gq1.yahoo.com>
References: <cover.1291925752.git.bengardiner@nanometrics.ca>
	<795969.76999.qm@web180308.mail.gq1.yahoo.com>
Date: Tue, 14 Dec 2010 11:58:15 -0500
Message-ID: <AANLkTin5KBeD=Q6r4bFU+Yppb4bcDAUR3ePVczgHJoT1@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/3] slower spi-gpio
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: David Brownell <david-b@pacbell.net>, Wolfram Sang <w.sang@pengutronix.de>
Cc: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 11:38 PM, David Brownell <david-b@pacbell.net> wrote:
> You know, the spi-gpio code was written so it
> would not need Kconfiguration, and I'd like
> to see that continued.
>
> Surely the minimal configuration you'd need
> could be wrapped up in #defineslike the
> actual GPIO numbers are wrapped up in.
>
> Heck, nothing outside your patches needs your
> :slow it way the heck down" option, so there's
> no point to exposing it  via Kconfig;
> such stuff is routinely embedded in C code.

Hi David,

Thanks for your comments. I'm glad to get a better picture of what you
expect from future proposed changes to spi_gpio.

Ok. Kconfig is clearly not an acceptable way to keep spi_gpio fast for
those who want it.

> Would it make more sense to have a separate
> slowed-down veresion of the driver, maybe just
> custom defs for our hardware plus the current
> driver body, as explained in the driver code
> (last time I looked at it, anyway).

I'm hearing that a separate driver is.

> (I notice you didn't even check the GPIOs to see
> if they are sleeping calls (e.g. over I2C), which
> would have been preferable to a static always-slow
> Kconfig option.  (But not to an always-slow object
> vs the current default always-fast model.

I hadn't thought that we could check for sleeping calls, thanks for
that suggestion.

> I still need to be able to get multi-megabit
> SPI clock rates out of the standard spi-gpio
> code base.  (When I've had to use spi-gpio it
> has never been a performance issue; the code
> was written to facilitate inner bitbang loops
> of about half a dozen instructions (ARM).

Ok so current users of spi_gpio require it to operate 'as fast as it
can.' But compile-time switching in the driver is undesireable.

What I'm taking away from the discussion is that we should introduce a
second bitbanging SPI master driver that reuses as much code as
possible from the existing spi_gpio driver.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
