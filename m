Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab1DWX1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 19:27:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:51196 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab1DWX1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 19:27:36 -0400
Subject: Re: [PATCH RFC] clk: add support for automatic parent handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, kernel@pengutronix.de,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1104211147300.3323@ionos>
References: <alpine.LFD.2.00.1104192339180.2744@localhost6.localdomain6>
	 <1303308457-7501-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <alpine.LFD.2.02.1104201704350.3323@ionos>
	 <20110420185922.GD31131@pengutronix.de>
	 <alpine.LFD.2.02.1104202113250.3323@ionos>
	 <4DAFD5AA.9020404@codeaurora.org>
	 <alpine.LFD.2.02.1104211147300.3323@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 09:26:21 +1000
Message-ID: <1303601181.2513.132.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 12:33 +0200, Thomas Gleixner wrote:
> 
> Depends, there is a lot of sane hardware out there (not necessarily in
> the ARM SoC world). We can do with a pointer if the need arises.
>  
> > >     optionally a set of common register accessor functions like I did
> > >     for the generic irq chip.
> > 
> > Again, I don't see the point in having this in the common code. May be I'm
> > missing something?
> 
> See my RFC patch of a generic irq chip implementation and how much
> duplicated five line inline functions they removed.
>  
> > IMO, a better option instead of the base register and the offsets would be an
> > option to have a priv_data pointer. I forgot the exact use case, but we
> > thought that would have been helpful when we tried to port the msm clock
> > driver in our tree on top of Jeremy's patches.
> 
> It works either way, but we should try to comeup with a sensible
> common base struct for sane hardware. 

Doesn't have to be in the base struct tho. I think a better approach is
to keep the base struct reasonably API-only, and have an
"implementation" subclass called something like simple_clk for example,
that carries those few fields common to most MMIO based implementation
and which can be created with existing "helper" code for the most common
ones.

Ben.


