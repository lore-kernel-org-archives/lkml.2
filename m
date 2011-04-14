Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab1DNQJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:09:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35637 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023Ab1DNQJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:09:17 -0400
Date: Thu, 14 Apr 2011 18:08:48 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
Message-ID: <20110414160848.GC31990@pengutronix.de>
References: <1299134429.100626.661279191478.0.gpush@pororo>
 <1302754859.2767.30.camel@pororo>
 <20110414100048.GB1611@n2100.arm.linux.org.uk>
 <1302776705.28876.113.camel@pasglop>
 <20110414103200.GF1611@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110414103200.GF1611@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:32:00AM +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 14, 2011 at 08:25:05PM +1000, Benjamin Herrenschmidt wrote:
> > On Thu, 2011-04-14 at 11:00 +0100, Russell King - ARM Linux wrote:
> > > 
> > > I will take it, but at the moment I'm rather unhappy about the response
> > > from the community to Linus' complaint.
> > > 
> > > If existing platform maintainers can show that moving over to this will
> > > result in a net reduction of code under arch/arm, then that will be good.
> > > What I don't want to see at the moment is arch/arm increasing in size as
> > > a result of any change.  We desperately need to see a reduction for the
> > > next merge window.
> > 
> > It's a chicken and egg... platform maintainers wait for you to take it
> > and you wait for them to take it :-)
> > 
> > It seems to me that this fits well into the category of "better common
> > abstractions" that was discussed in the thread initiated by Linus as one
> > of the ways to improve on the "clutter"...
> 
> That depends - sometimes creating generic stuff results in a net increase
> in the overall size, and that's something that Linus also complained about.
> 
> According to linux-next, where we are at the moment with arch/arm is a
> net increase of 6000 lines since the close of the last merge window,
> and arch/arm is responsible for almost 75% of arch/ changes.  It looks
> very much like the same situation which Linus complained about.
Well, looking at the output of

	git diff --dirstat=3 linus/master...next/master -- arch

(with linus/master == 85f2e689a and next/master == 9e06a6ea7) I think
the main culprit is 12dc7eff5 that moved arch/arm/mach-mx3 to
arch/arm/mach-imx. (75 files changed, 9783 insertions(+), 9731
deletions(-)) That's a part of the effort to consolidate the i.MX
platforms and allow to compile more SoCs in a single image.

That commit accounts for more than the half of the (loc) changes in
arch/arm.

OK, this doesn't discuss away the 6000 added lines, but at least the
percentage thingy. And I think when you point out this commit Linus will
be much quiter when replying to your pull request.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
