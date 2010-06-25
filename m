Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0FYLWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:22:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54178 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753206Ab0FYLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:22:34 -0400
Date: Fri, 25 Jun 2010 12:22:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Liam Girdwood <lrg@slimlogic.co.uk>, Tony Lindgren <tony@atomide.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Sundar Iyer <sundar.iyer@stericsson.com>,
       Bengt Jonsson <bengt.jonsson@stericsson.com>
Subject: Re: [PATCH] MMC: remove regulator refcount fiddling in mmc core
Message-ID: <20100625112232.GA21217@opensource.wolfsonmicro.com>
References: <1277392337-27627-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277392337-27627-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 05:12:17PM +0200, Linus Walleij wrote:

> Currently the mmc_regulator_set_ocr() fiddles with the regulator
> refcount by selectively calling regulator_[enable|disable]
> depending on the state of the regulator. This will confuse the
> reference count if case the regulator is for example shared with
> other MMC slots or user for other stuff than the MMC card.

> Push regulator_[enable|disable] out into the MMC host drivers
> and remove this from the MMC core so the reference count can be
> trusted.

So, the feedback from folks at the time this was originally written was
that the MMC code was unable to cope with sharing regulators since it
really needs to be able to set specific voltages.  This needn't be a
showstopper since people can force a single voltage in the constraints
but it does need to be considered here.
