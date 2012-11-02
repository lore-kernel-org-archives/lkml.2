Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab2KBM1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:27:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35437 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab2KBM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:27:34 -0400
Date: Fri, 2 Nov 2012 12:15:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2] ARM: plat-versatile: move FPGA irq driver to
	drivers/irqchip
Message-ID: <20121102121556.GV21164@n2100.arm.linux.org.uk>
References: <1351805329-19576-1-git-send-email-linus.walleij@linaro.org> <20121101232010.78269291@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101232010.78269291@skate>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 11:20:10PM +0100, Thomas Petazzoni wrote:
> Linus,
> 
> On Thu,  1 Nov 2012 22:28:49 +0100, Linus Walleij wrote:
> 
> > +void fpga_handle_irq(struct pt_regs *regs);
> 
> This function does not need to be exposed in a public header: as
> proposed for the bcm2835 and armada-370-xp IRQ controller drivers, the
> driver should directly do handle_arch_irq = fpga_handle_irq, and
> therefore there is no need for the machine desc structure to reference
> fpga_handle_irq anymore.

Err no, then you don't understand what's going on here.  This may or may
not be a top-level IRQ handler.  Some ARM platforms have three of these
cascaded, others have one of these cascaded off a VIC or GIC.

To override the top level IRQ handler unconditionally is going to break
platforms.
