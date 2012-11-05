Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab2KEXRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:17:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37049 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2KEXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:17:48 -0500
Date: Mon, 5 Nov 2012 23:14:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: plat-versatile: move FPGA irq driver to
	drivers/irqchip
Message-ID: <20121105231410.GK28327@n2100.arm.linux.org.uk>
References: <1351805329-19576-1-git-send-email-linus.walleij@linaro.org> <20121102121556.GV21164@n2100.arm.linux.org.uk> <50983422.9090301@gmail.com> <201211052242.26894.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211052242.26894.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 10:42:26PM +0000, Arnd Bergmann wrote:
> On Monday 05 November 2012, Rob Herring wrote:
> > But this should work:
> > 
> > if (!handle_arch_irq)
> >         handle_arch_irq = fpga_handle_irq;
> > 
> > As long as the primary controller is always initialized first, this will
> > work. This is guaranteed by DT of_irq_init, and you will probably have
> > other problems if that wasn't the case for non-DT.
> 
> How about adding a top-level function in arch/arm that does the assignment
> and hides the handle_arch_irq variable:
> 
> void set_handle_irq(void (*handle_irq)(struct pt_regs *))
> {
> 	if (WARN_ON(handle_arch_irq))
> 		return;
> 
> 	handle_arch_irq = handle_irq;
> }
> EXPORT_SYMBOL_GPL(set_handle_irq);
> 
> Hmm, maybe putting the top-level handler into a loadable module is a bit
> far-fetched, but one can hope ;-)

Definitely no point in exporting this (never export a symbol unless you
really want to use it from a module) - if you don't already have something
in handle_arch_irq, you're not going to get anywhere near the module
loader.
