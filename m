Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1AHQ0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 11:26:13 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:58573 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1AHQ0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 11:26:11 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V8 12/13] ptp: Added a clock driver for the IXP46x.
References: <cover.1293820862.git.richard.cochran@omicron.at>
	<8151196c018776704df34748f333bdb159497d0b.1293820862.git.richard.cochran@omicron.at>
	<m3ei8plpa0.fsf@intrepid.localdomain>
	<20110107170752.GB8666@riccoc20.at.omicron.at>
Date: Sat, 08 Jan 2011 17:25:36 +0100
In-Reply-To: <20110107170752.GB8666@riccoc20.at.omicron.at> (Richard Cochran's
	message of "Fri, 7 Jan 2011 18:07:52 +0100")
Message-ID: <m3r5cnuzun.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> The time stamp code clones the skb, but the LE version frees the skb
> too early. Perhaps we can move that dev_kfree_skb(skb) in the LE case
> to be the last statement in eth_xmit(). What do you think?

I think so. Or something similar.

> Do you mean, you don't like the constant on the left hand side?

Yes.

> Is that prohibited by CodingStyle or similar?

I don't think so. It's just a personal taste. I think it's based on
things learned in primary school, they teach to write (comparisons)
X = 4 instead of the other way around, and my brain seems to shock
a bit on the opposite.

> I got into the habit of writing it that way to prevent a typo like:
>
> 	if (irq = NO_IRQ)

I see. Unfortunately it doesn't prevent typos like this when the right
side isn't a constant. Anyway gcc warns about them, even when both sides
are variable.

>> Also I don't like the ixp_read/ixp_write() trivial macros. Why not
>> simply call __raw_readl() and __raw_writel()?
>
> Well, I have had the experience back in 2.4 days of having my drivers
> ruined by the changing IO macros in the kernel. The wrappers are
> supposed to help if that ever happens again. Seeing *two* leading
> underscores in the macro names certainly makes me nervous.

Well, these two underscores mainly mean it's arch-dependent, but so are
the ixp4xx drivers. Using the __raw_read* directly is the preferred
method (or, perhaps, in such case, it's the only way).

Actually, I was thinking about changing the macros some time ago, and it
may eventually happen. But we'll fix all the code using them then.
-- 
Krzysztof Halasa
