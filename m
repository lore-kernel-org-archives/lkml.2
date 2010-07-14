Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0GNSmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:42:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46609 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0GNSmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:42:53 -0400
Date: Wed, 14 Jul 2010 19:42:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific
	data
Message-ID: <20100714184251.GG5933@sirena.org.uk>
References: <20100713203852.GA1756@rakim.wolfsonmicro.main> <20100714145053.GA1689@bnru01.bnr.st.com> <20100714145748.GF31073@rakim.wolfsonmicro.main> <20100714153643.GB1689@bnru01.bnr.st.com> <20100714154726.GH31073@rakim.wolfsonmicro.main> <20100714160941.GC1689@bnru01.bnr.st.com> <20100714162048.GA27512@rakim.wolfsonmicro.main> <20100714164708.GD1689@bnru01.bnr.st.com> <20100714170323.GF5933@sirena.org.uk> <20100714173650.GA21893@bnru01.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714173650.GA21893@bnru01.bnr.st.com>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 11:06:51PM +0530, Sundar R IYER wrote:

> > OK, but your current set of supplies is *very* suspect since you're
> > offering all this control to lists of consumers that don't exist, and

> As said, dont exist for *now*.

This comes back to my point about the control only making sense when the
consumers are present - if you've got missing or partial consumer setup
done then control is questionable.

> Probably, I should remove the REGULATOR_CHANGE_VOLTAGE flag for the fixed
> supplies (as in the driver) to clear up any confusing link. Should I?

Yes.

> > This is normal, but for fairly obvious reasons the very lowest power
> > states are generally handled outside of the regulator API at a hardware
> > level via hardware signals to the regulator.  It's not normally part of
> > the runtime constraints for use while the CPU is live.

> Yes. But my point was that even at a lower level than kernel (BIOS/firmware?)
> the switching would happen via SW. Please correct me if I am wrong!

Well, ultimately it's always triggered by software but the actual signal
to the regulator is often a logic level output by the SoC as the
processor enters a low power state rather than an I2C/SPI write.

> > I'm not sure how you expect this to actually work in practice?  It's
> > going to be pretty hard for a driver to do anything constructive if the
> > power to the hardware gets cut, for example.  Unless you can guarantee
> > that there will never be any use of the hardware without a driver with
> > regulator support one driver's idea of optimal may not join up with what
> > the other consumers need at all.

> Very true. But, I think this will *enforce* drivers using/sharing
> regulators to adhere to the framework to avoid surprises and sole-owner
> misuses, which is good, now that the AB8500 regulators *are* supported.

If you think your users will be sympathetic to this approach then I
guess...  obviously, it does have the potential to go rather badly wrong
especially if there are some drivers without regulator support out
there.
