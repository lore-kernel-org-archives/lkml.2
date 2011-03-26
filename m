Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1CZUZE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 16:25:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:35529 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab1CZUZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 16:25:02 -0400
Date: Sat, 26 Mar 2011 21:24:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Varun Wadekar <vwadekar@nvidia.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [patch 02/23] arm: tegra: Remove unused function which fiddles
 with irq_desc
In-Reply-To: <4D8E4897.5030705@nvidia.com>
Message-ID: <alpine.LFD.2.00.1103262118010.31464@localhost6.localdomain6>
References: <20110325131617.258789658@linutronix.de> <20110325132047.552074703@linutronix.de> <4D8E4897.5030705@nvidia.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Mar 2011, Varun Wadekar wrote:
> 
> Thomas, then how do you think we should handle restoring of gpio states
> across suspend-resume cycles?

That code is unused. Period. No caller, nothing nada. So what does it
handle?
 
> > -
> > -	for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
> > -		struct irq_desc *desc = irq_to_desc(i);
> > -		if (!desc || (desc->status & IRQ_WAKEUP))
> > -			continue;
> > -		enable_irq(i);
> > -	}

And this part is totally unacceptable and should have never been
merged. Further it is in the way of cleanups to the core code and as
there is no user I'm not willing to even think about what it does and
why it is there.

FYI, the core code deals with interrupt suspending/resuming
already. So if there is a problem with that which does not cover your
specific problem, then you better talk to me before hacking up such
private workarounds and expecting that I tolerate them in unused code.

Thanks,

	tglx

