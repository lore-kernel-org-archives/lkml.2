Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab2DJNLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:11:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49778 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab2DJNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:58 -0400
Date: Tue, 10 Apr 2012 14:10:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] gpio: add MSIC gpio driver
Message-ID: <20120410131056.GA31551@sirena.org.uk>
References: <20120410131734.28046.25265.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410131734.28046.25265.stgit@bob.linux.org.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 02:18:04PM +0100, Alan Cox wrote:

> +	if (mg->trig_change_mask) {
> +		offset = __ffs(mg->trig_change_mask);
> +
> +		reg = msic_gpio_to_ireg(offset);
> +		if (reg < 0)
> +			goto out;
> +
> +		if (mg->trig_type & IRQ_TYPE_EDGE_RISING)
> +			trig |= MSIC_GPIO_TRIG_RISE;
> +		if (mg->trig_type & IRQ_TYPE_EDGE_FALLING)
> +			trig |= MSIC_GPIO_TRIG_FALL;
> +
> +		intel_msic_reg_update(reg, trig, MSIC_GPIO_INTCNT_MASK);
> +		mg->trig_change_mask = 0;
> +	}

What happens if we manage to get more than one change flagged while the
lock is held?

> +/* Firmware does all the masking and unmasking for us, no masking here. */
> +static void msic_irq_unmask(struct irq_data *data) { }

> +static void msic_irq_mask(struct irq_data *data) { }

Shouldn't these just be omitted if they don't do anything (or
alternatively, how does the firmware figure out that it needs to do the
masking and unmasking)?

> +	mg = kzalloc(sizeof(*mg), GFP_KERNEL);
> +	if (!mg)
> +		return -ENOMEM;

devm_kzalloc()
