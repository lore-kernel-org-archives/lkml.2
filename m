Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab1GVWCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:02:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932420Ab1GVWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110722135247.GA27855@opensource.wolfsonmicro.com>
References: <20110722135247.GA27855@opensource.wolfsonmicro.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Jul 2011 15:02:01 -0700
Message-ID: <CA+55aFw-8ShsN2M-7dXCOEFhOx4xVQhN2rtzwJWV=rcwvPgF9g@mail.gmail.com>
Subject: Re: [GIT PULL] regmap: Generic I2C and SPI register map library
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant@secretlab.ca>,
        Liam Girdwood <lrg@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 6:52 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
> I'm not 100% happy with the implementation at present (to a large extent
> due to keeping it simple for initial review, though there's some stuff
> I'm just not happy with) so I expect a bit of internal churn but the
> external interface should be solid and allow other code to start making
> use of the code.

What kind of sh*t is this?

First it says

   "There are no user servicable options here, this is an API intended
to be used by other kernel subsystems.  These subsystems should select
the appropriate symbols.:"

and then it does

   config REGMAP_I2C
        tristate
        default I2C

so now that thing turns on REGMAP_I2C and compiles in the code WITHOUT
EVEN ASKING. It's enough to enable i2c.

That is TOTALLY UNACCEPTABLE. It's pure and utter sh*t.

                       Linus
