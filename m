Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab1BEJsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 04:48:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51178 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab1BEJsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 04:48:23 -0500
Date: Sat, 5 Feb 2011 09:47:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Colin Cross <ccross@android.com>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Linus Walleij <linus.walleij@stericsson.com>, konkers@android.com,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for
	re-enabling l2x0
Message-ID: <20110205094730.GA23965@n2100.arm.linux.org.uk>
References: <1295834493-5019-5-git-send-email-ccross@android.com> <1295968464.10109.264.camel@e102109-lin.cambridge.arm.com> <20110125154133.GB17280@n2100.arm.linux.org.uk> <1295979242.10109.308.camel@e102109-lin.cambridge.arm.com> <2f97ec8a084e590220e1548fc927b60e@mail.gmail.com> <-8932138696981683633@unknownmsgid> <AANLkTi=cTXmQFm_s5OL2pGyyaFv5UR_f9MV=S5Ajx0tu@mail.gmail.com> <20110204234331.GF8732@n2100.arm.linux.org.uk> <AANLkTi=fHnivHXHnYrQvdP6JWbEA3t1X3DuBxj5gN3H0@mail.gmail.com> <1bebe4b5c8590059b70a146d5486fa6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bebe4b5c8590059b70a146d5486fa6a@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 01:21:24PM +0530, Santosh Shilimkar wrote:
> GIC save/restore on OMAP follows different strategy. There is a
> Predefined layout to save content and restore is done atomically
> by boot ROM code.
> L2 cache also same case. Only AUXCTRL needs to be programmed on
> wakeup from low power mode and that too with secure call. Rest
> of the registers are managed by boot ROM code.
> 
> TWD is already managed through framework. Othe CPU low power
> sequence is very small and OMAP has restrictions on the last
> core to go down and first to wakeup.
> 
> So at least I don't see any use of common notifiers for GIC
> and L2 will help OMAP lower power code.

What this means is that we're going to end up littering things like GIC
and other stuff with lots of individual SoC specific code to save state
into individual SoC specific structures.  This is not sane, and we're
not going to corrupt generic code with SoC specific code.
