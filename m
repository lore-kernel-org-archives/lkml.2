Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2HNXXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:23:23 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:55825 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2HNXXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:23:21 -0400
Date: Wed, 15 Aug 2012 02:22:50 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 11/31] arm64: IRQ handling
Message-ID: <20120814232250.GB747@harshnoise.musicnaut.iki.fi>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-12-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-12-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 14, 2012 at 06:52:12PM +0100, Catalin Marinas wrote:
> +void handle_IRQ(unsigned int irq, struct pt_regs *regs)
> +{
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +
> +	irq_enter();
> +
> +	/*
> +	 * Some hardware gives randomly wrong interrupts.  Rather
> +	 * than crashing, do something sensible.
> +	 */
> +	if (unlikely(irq >= nr_irqs)) {
> +		if (printk_ratelimit())
> +			pr_warning("Bad IRQ%u\n", irq);

I guess pr_warn_ratelimited() should be used for new code.

(See include/linux/printk.h, "Please don't use printk_ratelimit()...")

A.
