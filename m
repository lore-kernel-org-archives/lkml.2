Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1ERVY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:24:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:44565 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab1ERVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:24:28 -0400
Date: Wed, 18 May 2011 23:24:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
In-Reply-To: <20110518155615.GJ15292@game.jcrosoft.org>
Message-ID: <alpine.LFD.2.02.1105182313060.3078@ionos>
References: <201105181047.17309.arnd@arndb.de> <20110518155615.GJ15292@game.jcrosoft.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 10:47 Wed 18 May     , Arnd Bergmann wrote:
> > We will probably not be fully functional during the 2.6.40 merge window,
> > but we are trying our best to be useful. For 2.6.41, my hope is that
> > we can merge the bulk of the ARM subarchitecture changes through this
> > tree. Once Linus is happy with the way that the process works, we can
> > mandate that all ARM subarchitecture changes go through our tree, until
> > then it stays voluntary.
> How do you plan to manage with already sub arch maintainers?

The sub arch maintainers are not replaced by this.
 
> In my ming such tree could be good to organise cross arch drivers

This is not about drivers. drivers need to move out of arch/arm into
the proper drivers/subsystem where consolidation makes really sense
even across architectures. We have already multiple drivers for the
same stupid IP block in tree just because they were glued into
different SoCs (ARM, x86, ....). That's not an ARM specific problem,
it's all across the board, but on ARM it is very visible.

> but for real arch specific the current workflow is good

There is a difference between arch specific code - i.e. core ARM
architecture code - and SoC specific code which goes into
arch/arm/[mach|plat]-*. The core code was never and issue and we are
not touching it as Russell is handling it perfectly. The real issue is
the code in [mach|plat]-* which flows rather randomly into mainline
today. That results in lack of review, push back and makes
consolidation as hard as it gets.

> If we add a new stage it will be difficult to follow for people

What is difficult about that? How does it matter whether you ask A or
B to pull and propagate your subarch code?
 
> I'd like to have scenario example where such workflow will give a significant
> advantage compare to the current workflow. And please real example.

See above. It's not about examples, it's about solving issues like
lack of review, lack of central places to do consolidation work and
lack of push-back when stuff goes into the wrong direction.

Thanks,

	tglx


