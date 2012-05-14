Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2ENJrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:47:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57857 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2ENJrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:47:40 -0400
Date: Mon, 14 May 2012 10:47:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com, sameo@linux.intel.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120514094737.GB2189@sirena.org.uk>
References: <20120511233402.43D813E0791@localhost>
 <cover.1334219873.git.rubini@gnudd.com>
 <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
 <20120514072534.GA29871@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120514072534.GA29871@mail.gnudd.com>
X-Cookie: Pushing 40 is exercise enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 09:25:34AM +0200, Alessandro Rubini wrote:

> >> +	/* 384 was used in previous code: be compatible for other drivers */
> >> +	err = irq_alloc_descs(-1, 384, GSTA_NR_GPIO, NUMA_NO_NODE);

> > Where does the number 384 come from?  It looks like the driver only
> > needs to allocate a range of irqs and that it doesn't actually matter
> > what the real numbers are.  Can 0 be used instead?

> The problem is that there are a number of drivers already working (but
> not ready to be upstreamed), and we'd better continue using them.  So,
> the mmc driver is requesting a specific interrupt number.  The code is
> GPL (published on sourceforge) and I'd better remain compatible.

> I'm not completely clear (yet) about how to get the right interrupt
> number in those other drivers, but I'm willing to remove the constraint
> as they are cleaned up and submitted.

Use platform data for both this driver and the other drivers (or device
tree if you're doing that).  This will hard code the magic numbers in
the board files, not in the driver.
