Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1AJLBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 06:01:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44300 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1AJLBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 06:01:04 -0500
Date: Mon, 10 Jan 2011 11:00:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110110110028.GB12552@n2100.arm.linux.org.uk>
References: <1294199462.347935.472473715866.0.gpush@pororo> <1294199462.348449.192344022926.1.gpush@pororo> <20110108131520.GE26617@pengutronix.de> <201101101043.05406.jeremy.kerr@canonical.com> <20110110104122.GI12078@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110104122.GI12078@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 11:41:22AM +0100, Sascha Hauer wrote:
> This branch must be reworked because the correct locking is missing, but
> the first branch should be ready for merging once your clk-common
> patches are merged. I'll post the patches for review soon. I hope it's
> clear soon that your clk-common patches get merged.

Unless the locking problems can be resolved, the patches aren't ready.

>From what I've seen there's still quite a problem with what kind of
lock to use in the clock - mutex or spinlock.

I don't see that having some clocks be one and others another is really
acceptable - think about the resulting mess if you end up with some
parent mux'd clocks which are a mutex and others which are a spinlock.
Can a driver use an atomic call for that?  Sometimes depending on the
mux, sometimes depending on whether a parent clock is already enabled.

What if your clock was enabled while the mux selected another spinlock-
locked clk, but then you switched to a different operating point and the
mux then selected the mutex-locked clock.

We could say that this is illegal - but then we need to have the code
explicitly check this otherwise such situations will be created.
