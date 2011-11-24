Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1KXBJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 20:09:20 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40543 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754804Ab1KXBJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 20:09:09 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1//R22tlO3CLpT/qOdTzZwN
Date: Wed, 23 Nov 2011 17:08:55 -0800
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
Message-ID: <20111124010855.GN31337@atomide.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-6-git-send-email-mturquette@linaro.org>
 <20111122154900.GB18954@kroah.com>
 <CAPtuhThPQtWwihE8aGru55k87oV7QOr=O836TTJ+=30d6dtVhA@mail.gmail.com>
 <20111122191347.GB4844@kroah.com>
 <20111123165903.GF31337@atomide.com>
 <20111123180651.GB19739@n2100.arm.linux.org.uk>
 <20111123185518.GG31337@atomide.com>
 <20111123224248.GC19739@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123224248.GC19739@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [111123 14:07]:
> On Wed, Nov 23, 2011 at 10:55:19AM -0800, Tony Lindgren wrote:
> > What else are you aware of that is really needed early for clocks other
> > than clockevent?
> 
> TWD will lose its auto-calibration.  Then there's various clock source
> and clock event implementations.  These all call for the clk API to be
> up and running at init_early time.

If we can't initialize those later on, then it sounds like some clocks
and some parts of the clock fwk code needs to be static.

However, we could still make big chunks of the clock framework into a
regular device driver for allocating non-static clocks, debugfs interface
and so on.

Regards,

Tony
