Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1KWSzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:55:37 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26318 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751397Ab1KWSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:55:36 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX181s8b1wi+74VxR+AKCbTdl
Date: Wed, 23 Nov 2011 10:55:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, Mike Turquette <mturquette@linaro.org>,
        linaro-dev@lists.linaro.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, jeremy.kerr@canonical.com,
        Mike Turquette <mturquette@ti.com>, sboyd@quicinc.com,
        magnus.damm@gmail.com, dsaxena@linaro.org,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org,
        patches@linaro.org, tglx@linutronix.de, linux-omap@vger.kernel.org,
        richard.zhao@linaro.org, shawn.guo@freescale.com, paul@pwsan.com,
        linus.walleij@stericsson.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        skannan@quicinc.com
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
Message-ID: <20111123185518.GG31337@atomide.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-6-git-send-email-mturquette@linaro.org>
 <20111122154900.GB18954@kroah.com>
 <CAPtuhThPQtWwihE8aGru55k87oV7QOr=O836TTJ+=30d6dtVhA@mail.gmail.com>
 <20111122191347.GB4844@kroah.com>
 <20111123165903.GF31337@atomide.com>
 <20111123180651.GB19739@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123180651.GB19739@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [111123 09:31]:
> On Wed, Nov 23, 2011 at 08:59:04AM -0800, Tony Lindgren wrote:
> > ..let's plan on getting rid of the early usage of clocks instead so
> > you don't have the issue of deferring stuff.
> 
> No - we have too many platforms already using them early to do a change
> like this - and to do such a change will force them to invent some other
> way.  That's just stupid.

Not necessarily for all the systems. For omap2+ we should be able to
boot the system initially with the perf counter as the clockevent and
32KiHz always running timer. Then a dmtimer using proper clockevent
driver could take over.
 
> Keep the clk API as a fundamental thing which should be initialized early
> so we don't have to invent new clk APIs to get around its unavailability.

What else are you aware of that is really needed early for clocks other
than clockevent?

We've already proven that SRAM init can be moved to happen later. The
optional debug serial port is already enabled by the bootloader.

Regards,

Tony
