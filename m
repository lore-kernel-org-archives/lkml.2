Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab1KVRqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:46:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33606 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1KVRqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:46:07 -0500
Date: Tue, 22 Nov 2011 17:45:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>, Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        aul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 0/5] common clk framework
Message-ID: <20111122174544.GA19739@n2100.arm.linux.org.uk>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <20111122154259.GA18954@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122154259.GA18954@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 07:42:59AM -0800, Greg KH wrote:
> On Mon, Nov 21, 2011 at 05:40:42PM -0800, Mike Turquette wrote:
> >   .sysfs support.  Visualize your clk tree at /sys/clk!  Where would be
> > a better place to put the clk tree besides the root of /sys/?
> 
> Um, in the "proper" place for it under /sys/devices like the rest of the
> device tree is?

I'd suggest that making the clock tree visible in sysfs (and therefore
part of the kernel ABI) is not a good idea.  Some of the nodes in there
will be specific to the implementation.  Exposing the clock nodes means
that if you have to change the clock tree structure, you change the
visible userspace ABI.

So, I'd suggest that we need to see a justification for this, rather
than exposing this stuff via debugfs as has been done with existing
implementations.
