Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2JII1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 04:27:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43556 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448Ab2JII1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 04:27:42 -0400
Date: Tue, 9 Oct 2012 17:27:27 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Christopher Heiny <cheiny@synaptics.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Message-ID: <20121009082719.GC8237@opensource.wolfsonmicro.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
 <1349496603-20775-2-git-send-email-cheiny@synaptics.com>
 <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 09:43:13AM +0200, Linus Walleij wrote:
> On Sat, Oct 6, 2012 at 6:09 AM, Christopher Heiny <cheiny@synaptics.com> wrote:

> > + * @cs_assert - For systems where the SPI subsystem does not control the CS/SSB
> > + * line, or where such control is broken, you can provide a custom routine to
> > + * handle a GPIO as CS/SSB.  This routine will be called at the beginning and
> > + * end of each SPI transaction.  The RMI SPI implementation will wait
> > + * pre_delay_us after this routine returns before starting the SPI transfer;
> > + * and post_delay_us after completion of the SPI transfer(s) before calling it
> > + * with assert==FALSE.

> Hm hm, can you describe the case where this happens?

> Usually we don't avoid fixes for broken drivers by duct-taping
> solutions into other drivers, instead we fix the SPI driver.

> I can think of systems where CS is asserted not by using
> GPIO but by poking some special register for example, which
> is a valid reason for including this, but working around broken
> SPI drivers is not a valid reason to include this.

> (Paging Mark about it.)

Yeah, this seems silly - by this logic we'd have to go round implementing
manual /CS control in every single SPI client driver which isn't
terribly sensible.  The driver should just assume that the SPI
controller does what it's told.  As you say if there's an issue the
relevant controller driver should take care of things.

We should also have generic support in the SPI framework for GPIO based
/CS, there's enough drivers open coding this already either due to
hardware limitations or to support extra chip selects.

The ability of SPI hardware and driver authors to get /CS right is
pretty depressing :/
