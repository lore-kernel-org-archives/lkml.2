Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab1CCJfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:35:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46562 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab1CCJfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:35:39 -0500
Date: Thu, 3 Mar 2011 10:35:32 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, xiao-lizhang@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
Message-ID: <20110303093532.GO22310@pengutronix.de>
References: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com>
 <20110302215238.GK22310@pengutronix.de>
 <alpine.LFD.2.00.1103022343410.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1103022343410.2701@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guten Morgen Thomas,

On Thu, Mar 03, 2011 at 12:51:32AM +0100, Thomas Gleixner wrote:
> Uwe,
> 
> On Wed, 2 Mar 2011, Uwe Kleine-König wrote:
> > On Wed, Mar 02, 2011 at 11:17:58AM -0600, Dinh.Nguyen@freescale.com wrote:
> > > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> > > --- /dev/null
> > > +++ b/arch/arm/mach-mx5/pm.c
> > I'd like to have that called pm-imx51.c
> 
> And I'd like to have a pony.
http://www.carl-russ-schule.de/files/Pony.jpg

> 
> > > +		ccm_clpcr |= (0x3 << MXC_CCM_CLPCR_STBY_COUNT_OFFSET);
> > the parentheses aren't needed here
> 
> Could you finally provide a patch to checkpatch.pl or git commit which
> resolves that issue once and forever ?
> 
> Not to mention the fact, that those parentheses are not disturbing the
> readability of that code at all.
So it seems we're different.

> 
> > > +		ccm_clpcr |= (0x1 << MXC_CCM_CLPCR_LPM_OFFSET);
> > ditto
> 
> Ditto.
> 
> > > +static int __init mx5_pm_init(void)
> > I'd prefer to have that called by imx51_init_early.
> 
> And the reason is? 
> 
>     1) your personal preference
>     2) there is some useful technical reason
> 
> If #1, then this comment was just waste of electrons
> If #2, you failed to provide some reasonable explanation
Actually it's #2, and to quote a different review[1]:

	Reviewers hint to a correct solution and you are supposed to
	lookup what that solution means and act accordingly. If you do
	not understand the hint or its implications please ask [...]

> Again, I'd like to have a pony.
http://h-6.abload.de/img/pony01_pixelquelle_dal8701.jpg

> Seriously, while all of us admire your invaluable skills of running
> scripts over patches and kernel code, that kind of review you are
> trying to provide is utterly useless.
actually it's not a script, but I guess that doesn't matter much.

> 1) The patch itself has been questioned about its correctness hours
>    before you added the output of your secret script. It was already
>    reported to be non functional. So what's the value of adding
>    scriptable review to it?
It might save the patch sender from a third iteration.

> 2) As long as you do not see the most obvious functional problems with
>    a patch please spare your script computing power and the bandwidth
>    you are consuming by your futile attempts to gain a profile as a
>    patch reviewer.
The functionallity of the patch has been questioned before so I didn't
see a value in repeating that :-)  To be honest, I didn't check for
functional problems, but IMHO it's OK to provide feedback about a part
of the problems if you don't see all of them.

Best regards
Uwe

[1] http://article.gmane.org/gmane.linux.kernel/1107265

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
