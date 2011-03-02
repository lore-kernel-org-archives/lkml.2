Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1CBXvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:51:50 -0500
Received: from www.tglx.de ([62.245.132.106]:58473 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab1CBXvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:51:49 -0500
Date: Thu, 3 Mar 2011 00:51:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        xiao-lizhang@freescale.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
In-Reply-To: <20110302215238.GK22310@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1103022343410.2701@localhost6.localdomain6>
References: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com> <20110302215238.GK22310@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1761830475-1299107078=:2701"
Content-ID: <alpine.LFD.2.00.1103030005120.2701@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1761830475-1299107078=:2701
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1103030005121.2701@localhost6.localdomain6>

Uwe,

On Wed, 2 Mar 2011, Uwe Kleine-König wrote:
> On Wed, Mar 02, 2011 at 11:17:58AM -0600, Dinh.Nguyen@freescale.com wrote:
> > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

> > --- /dev/null
> > +++ b/arch/arm/mach-mx5/pm.c
> I'd like to have that called pm-imx51.c

And I'd like to have a pony.

> > +		ccm_clpcr |= (0x3 << MXC_CCM_CLPCR_STBY_COUNT_OFFSET);
> the parentheses aren't needed here

Could you finally provide a patch to checkpatch.pl or git commit which
resolves that issue once and forever ?

Not to mention the fact, that those parentheses are not disturbing the
readability of that code at all.

> > +		ccm_clpcr |= (0x1 << MXC_CCM_CLPCR_LPM_OFFSET);
> ditto

Ditto.

> > +static int __init mx5_pm_init(void)
> I'd prefer to have that called by imx51_init_early.

And the reason is? 

    1) your personal preference
    2) there is some useful technical reason

If #1, then this comment was just waste of electrons
If #2, you failed to provide some reasonable explanation

Again, I'd like to have a pony.

Seriously, while all of us admire your invaluable skills of running
scripts over patches and kernel code, that kind of review you are
trying to provide is utterly useless.

1) The patch itself has been questioned about its correctness hours
   before you added the output of your secret script. It was already
   reported to be non functional. So what's the value of adding
   scriptable review to it?

2) As long as you do not see the most obvious functional problems with
   a patch please spare your script computing power and the bandwidth
   you are consuming by your futile attempts to gain a profile as a
   patch reviewer.

Just for the record. The obvious bug with this code is this:

> > +	plat_lpc |= MXC_CORTEXA8_PLAT_LPC_DSM
> > +		    | MXC_CORTEXA8_PLAT_LPC_DBG_DSM;
> > +	arm_srpgcr |= MXC_SRPGCR_PCR;
> > +
> > +	__raw_writel(plat_lpc, MXC_CORTEXA8_PLAT_LPC);
> > +	__raw_writel(ccm_clpcr, MXC_CCM_CLPCR);
> > +	__raw_writel(arm_srpgcr, MXC_SRPG_ARM_SRPGCR);
> > +	__raw_writel(arm_srpgcr, MXC_SRPG_NEON_SRPGCR);
> > +
> > +	if (tzic_enable_wake(0) != 0)
> > +		return -EAGAIN;

It happily returns here with -EAGAIN w/o undoing the already committed
changes which are preparatory to the tzic_enable_wake() check.

I might be wrong as usual, but if this is cleaned up by the calling
code magically then the "return -EINVAL"; lacks a big fat
comment. While such an omission is not a triggerable bug it documents
the lack of tought and taste by creating asymetric mechanisms w/o the
courtesy to document them properly. Even if documented, asymetric
interfaces are crap most of the time.

> > +	cpu_do_idle();
> > +	return 0;
> > +}

Thanks,

	tglx
---1463795968-1761830475-1299107078=:2701--
