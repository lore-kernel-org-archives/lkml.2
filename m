Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1BOIjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 03:39:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35448 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1BOIjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 03:39:12 -0500
Date: Tue, 15 Feb 2011 08:37:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Message-ID: <20110215083759.GA4152@n2100.arm.linux.org.uk>
References: <1297233693.242364.862698430999.1.gpush@pororo> <201102151041.40655.jeremy.kerr@canonical.com> <4D5A100F.9000809@codeaurora.org> <201102151526.54280.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102151526.54280.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 03:26:53PM +0800, Jeremy Kerr wrote:
> Hi Saravana,
> 
> > Sure, one could argue that in some archs for a certain set of clocks the
> > slow stuff in prepare/unprepare won't need to be done during set rate --
> > say, a simple clock that always runs off the same PLL but just has a
> > integer divider to change the rate.
> > 
> > In those cases, not grabbing the prepare_lock would make the code less
> > "locky".
> > 
> > > We
> > > may even want to disallow set_rate (and set_parent) when prepare_count is
> > > non- zero.
> > 
> > This is definitely not right.
> 
> Why is that? Consider two devices using one clock; one does some 
> initialisation based on the return value of clk_get_rate(), the other calls 
> clk_set_rate() some time later. Now the first device is incorrectly 
> initialised.

What about a clock sourced from a PLL which provides the dotclock for a
framebuffer device?  On every mode set, should the clk have to be disabled,
unprepared, rate set, re-prepared and re-enabled?

