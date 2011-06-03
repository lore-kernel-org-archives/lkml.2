Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1FCPXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:23:34 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:27526
	"EHLO CH1EHSOBE013.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751588Ab1FCPXd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:23:33 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz9371M168aJ1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 3 Jun 2011 23:26:44 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <patches@linaro.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] Move plat-mxc gpio driver into drivers/gpio
Message-ID: <20110603152643.GB19344@S2100-06.ap.freescale.net>
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
 <20110603075201.GE10532@n2100.arm.linux.org.uk>
 <20110603143406.GA19344@S2100-06.ap.freescale.net>
 <BANLkTi=5kNAt51DP3-rykkT3ZONczD5Crg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <BANLkTi=5kNAt51DP3-rykkT3ZONczD5Crg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Fri, Jun 03, 2011 at 08:55:58AM -0600, Grant Likely wrote:
> On Fri, Jun 3, 2011 at 8:34 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> > Hi Russell,
> >
> > On Fri, Jun 03, 2011 at 08:52:01AM +0100, Russell King - ARM Linux wrote:
> >> On Thu, Jun 02, 2011 at 11:33:48AM +0800, Shawn Guo wrote:
> >> >  arch/arm/plat-mxc/gpio.c                        |  361 -------------------
> >> >  drivers/gpio/gpio-mxc.c                         |  433 +++++++++++++++++++++++
> >>
> > My bad here.  I should have used 'git diff --stat -M' to show the
> > the following.
> >
> > .../arm/plat-mxc/gpio.c => drivers/gpio/gpio-mxc.c |  216 +++++++++++++-------
> >
> >> I'm wondering why just moving this driver into drivers/gpio has
> >> resulted in it growing by 72 lines - and it's not clear from the
> >> diffs why that is because of the way they're broken up.
> >>
> > Yes, I agree.  But when I did something like that to ease the review,
> > people think it's not necessary :)
> >
> > http://permalink.gmane.org/gmane.linux.kernel/1143257
> 
> The issue was bisectability: it looked like the build would break
> after applying the first patch.  The first patch should move the

Yes, the build would break only if you change Kconfig/Makefile to
actually build it.  The patch does not enable the build of the driver
in the patch.

> driver without breaking the build, and then you can follow up with
> driver fixes.  I don't want to see functional changes mixed in with
> the file move change.
> 
Understood.  Do you want me to resend the gpio-mxs and gpio-mxc patch
sets for that?  Or can I follow the practice you and Russell
suggested in the future posts?  I have learnt the lesson.

> > +
> > +static struct platform_driver mxc_gpio_driver = {
> > +       .driver         = {
> > +               .name   = "gpio-mxc",
> 
> .owner = THIS_MODULE,
> 
Do I need to re-spin the patch set to fix it, or maintainer (you or
Sascha) can help to fix it up?

BTW, do you and Sascha get the agreement on which tree the gpio-mxs
and gpio-mxc should go through?

-- 
Regards,
Shawn

