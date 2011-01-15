Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab1AOPDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:03:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37876 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1AOPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:03:51 -0500
Date: Sat, 15 Jan 2011 16:03:31 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christer Weinigel <christer@weinigel.se>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110115150331.GB6917@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com>
 <20110111091607.GI12552@n2100.arm.linux.org.uk>
 <4D2D184A.8020405@codeaurora.org>
 <20110112090301.GS11039@n2100.arm.linux.org.uk>
 <4D31A8F1.4080301@weinigel.se>
 <20110115145358.GC15996@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110115145358.GC15996@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sat, Jan 15, 2011 at 02:53:58PM +0000, Russell King - ARM Linux wrote:
> We've been around returning EAGAIN, WARN_ONs, BUG_ONs, having clk_enable()
> vs clk_enable_atomic(), clk_enable_cansleep() vs clk_enable(), etc.
> 
> There's been a lot of talk on this issue for ages with no real progress
> that I'm just going to repeat: let's unify those implementations which
> use a spinlock for their clks into one consolidated solution, and
> a separate consolidated solution for those which use a mutex.
> 
> This will at least allow us to have _some_ consolidation of the existing
> implementations - and it doesn't add anything to the problem at hand.
> It might actually help identify what can be done at code level to resolve
> this issue.
Great, so how should we do it?  Take Jeremy's patch and make the
differenciation between sleeping and atomic implementation a Kconfig
variable?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
