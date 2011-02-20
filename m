Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1BTNIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:08:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36512 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1BTNIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:08:23 -0500
Date: Sun, 20 Feb 2011 13:07:37 +0000
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
Message-ID: <20110220130737.GE14495@n2100.arm.linux.org.uk>
References: <1297233693.242364.862698430999.1.gpush@pororo> <201102151526.54280.jeremy.kerr@canonical.com> <20110215083759.GA4152@n2100.arm.linux.org.uk> <201102151733.30332.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102151733.30332.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:33:29PM +0800, Jeremy Kerr wrote:
> Hi Russell,
> 
> > > Why is that? Consider two devices using one clock; one does some
> > > initialisation based on the return value of clk_get_rate(), the other
> > > calls clk_set_rate() some time later. Now the first device is
> > > incorrectly initialised.
> > 
> > What about a clock sourced from a PLL which provides the dotclock for a
> > framebuffer device?  On every mode set, should the clk have to be disabled,
> > unprepared, rate set, re-prepared and re-enabled?
> 
> Sounds heavy-handed, but I honestly have no idea if that's reasonable or not.
> 
> Other options are:
> 
>  * Require that the driver has called clk_prepare, and that prepare_count
>    is 1 during the set_rate call (indicating that this is the only user); or
> 
>  * Leave the set_rate and set_parent semantics as-is and assume that anything
>    calling either knows what it's doing (and that it won't affect other
>    devices)
> 
> Are you OK if we address this separately to the API unification though?

Absolutely.  I think there's enough issues already without adding new
changes on top.  The unification step should do just that - unify.  It
should not introduce new restrictions that are not absolutely necessary
for the unification step.
