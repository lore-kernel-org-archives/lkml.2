Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1DTO2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:28:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53042 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1DTO2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:28:46 -0400
Date: Wed, 20 Apr 2011 16:28:16 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
Message-ID: <20110420142816.GZ31131@pengutronix.de>
References: <1299134429.100626.661279191478.0.gpush@pororo>
 <1302754859.2767.30.camel@pororo>
 <20110414100048.GB1611@n2100.arm.linux.org.uk>
 <1302776705.28876.113.camel@pasglop>
 <20110414103200.GF1611@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1104140751220.24613@xanadu.home>
 <20110414120904.GH1611@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1104140920110.24613@xanadu.home>
 <20110414153813.GC6259@n2100.arm.linux.org.uk>
 <20110418105442.GB27864@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110418105442.GB27864@linux-sh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 18, 2011 at 07:54:42PM +0900, Paul Mundt wrote:
> If you'd prefer not to be the guinea pig for the clock bits going in to
> .40 I'm certainly happy to take them in a topic branch, convert my
> platforms on top of that and send the bits off to Linus early in the
> merge window.
To get this forward I set up a branch with the generic bits sent to the
list so far. I really think this should be fixed better now than later
to give enough time for potential users of the new API to implement it
for their platform.

The following changes since commit f0e615c3cb72b42191b558c130409335812621d8:

  Linux 2.6.39-rc4 (2011-04-18 21:26:00 -0700)

are available in the git repository at:
  git://git.pengutronix.de/git/ukl/linux-2.6.git common-struct-clk

Jeremy Kerr (2):
      Add a common struct clk
      clk: Generic support for fixed-rate clocks

Russell King - ARM Linux (1):
      Fix clkdev return value for NULL clk case

Sascha Hauer (1):
      clk: Make NULL a valid clock again

 drivers/clk/Kconfig  |    3 +
 drivers/clk/Makefile |    1 +
 drivers/clk/clk.c    |  173 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clkdev.c |   26 +++++---
 include/linux/clk.h  |  180 +++++++++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 364 insertions(+), 19 deletions(-)
 create mode 100644 drivers/clk/clk.c

I declare this to be stable, so assuming people are OK with it, you can
use that as a base to convert your platforms.

@Linus: I hope you're willing to pull this branch after .39?! (A public
"yes" might motivate one or the other maintainer to convert their
platform to it.)

There is a 2nd branch on that repository that also contains my RFC patch
just sent to this list in case you want to test it.

The following changes since commit 0ddb7f510fd51213801bf33194629fabf0818f39:

  clk: Make NULL a valid clock again (2011-04-20 16:02:29 +0200)

are available in the git repository at:
  git://git.pengutronix.de/git/ukl/linux-2.6.git common-struct-clk-wip

Uwe Kleine-König (1):
      [RFC] clk: add support for automatic parent handling

 drivers/clk/clk.c   |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h |    8 ++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
