Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab0LBRjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:39:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33877 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab0LBRjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:39:01 -0500
Date: Thu, 2 Dec 2010 17:38:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Anton Vorontsov <avorontsov@mvista.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, Jamie Iles <jamie.iles@picochip.com>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-tegra@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/8] ARM: SCU: Add common routines for secondary CPU
	bootup
Message-ID: <20101202173824.GE10461@n2100.arm.linux.org.uk>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru> <20101130171658.GA24034@oksana.dev.rtsoft.ru> <20101130233204.GB14383@n2100.arm.linux.org.uk> <20101201002527.GC14383@n2100.arm.linux.org.uk> <AANLkTikpjq-8BVanF5W76j0ZdDBur8DyHWSH8GGgJBQs@mail.gmail.com> <20101202152428.GD10461@n2100.arm.linux.org.uk> <1291307320.11271.51.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291307320.11271.51.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 04:28:40PM +0000, Catalin Marinas wrote:
> The SCU is part of the core TRM, so I don't expect it to be the same
> across various MP cores (and A15 is an example).
> 
> You may want to consolidate functions like scu_prepare_cpus (maybe call
> it smp_prepare_cpus)

You do realise the function called from architecture independent code is
called 'smp_prepare_cpus' ?

> and something that calls set_cpu_possible() but
> with platform callbacks for getting the number of calls and initialising
> the SMP (SCU for most platforms).

What if a platform, for what ever reason, wants to have 3 CPUs,
numbered 0, 2, 3 ?  That's the reason why the code which sets the
possible and present maps isn't in the ARM core code - Eg, we don't
know if a platform wants to keep CPU 1 in AMP mode to run some
special software on it.

> Whether this is worth, I don't know.

I don't think it's worth it because I think trying to considate this
is going to cripple the code structure in the future.

What we currently have is a nice sane separation of the core SMP
support from the platform specific parts of the SMP support.

BTW, is it worth making sure that the IC and SCU standby mode bits
are set for A9 MPCore ?
