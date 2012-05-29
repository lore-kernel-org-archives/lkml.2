Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2E2Oe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:34:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45231 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2E2Oe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:34:27 -0400
Date: Tue, 29 May 2012 16:34:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Daniel Mack <daniel@zonque.org>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mx35: add cpufreq support
Message-ID: <20120529143414.GE16535@pengutronix.de>
References: <20120507141437.GA9636@lovely.krouter>
 <20120509072239.GG27341@pengutronix.de>
 <20120509075618.GA4412@lovely.krouter>
 <20120509081306.GK27341@pengutronix.de>
 <1337276960.4970.4.camel@lovely>
 <20120517182036.GK30400@pengutronix.de>
 <1337280058.4970.6.camel@lovely>
 <20120517224205.GA7021@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120517224205.GA7021@mars>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:29:31 up 198 days, 22:16, 70 users,  load average: 0.08, 0.13,
 0.37
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:42:05AM +0200, Christoph Fritz wrote:
> On Thu, May 17, 2012 at 08:40:58PM +0200, Christoph Fritz wrote:
> > On Thu, 2012-05-17 at 20:20 +0200, Sascha Hauer wrote:
> > > On Thu, May 17, 2012 at 07:49:20PM +0200, Christoph Fritz wrote:
> > 
> > > > Is there already a version I can rebase the patch?
> > > > 
> > > > On your repo at git://git.pengutronix.de/git/imx/linux-2.6.git I can't
> > > > find the new clock framework or even a work-in-progress version.
> > > 
> > > They are in linux-next now.
> 
> There changed a lot of stuff: Where should I register the function to
> set/get the cpu frequency?
> 
> To get an idea of how it should be done, I looked at imx51: Is there
> cpufreq-support still implemented/working?  I can see the
> arch/arm/mach-imx/cpu_op-mx51.c but not its correlating
> clk_cpu_set_rate function in arch/arm/mach-imx/clk-imx51-imx53.c.

>From what I see there must be a clkdev registered for the cpu clock.
Seems this got lost during conversion to the generic clock framework.

in arch/arm/plat-mxc/cpufreq.c:

	cpu_clk = clk_get(NULL, "cpu_clk");

should be:

	cpu_clk = clk_get(NULL, "cpu");

I don't know if that's enough though.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
