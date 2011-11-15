Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1KORVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 12:21:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49096 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab1KORVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 12:21:08 -0500
Date: Tue, 15 Nov 2011 17:20:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Patrick Combes <p-combes@ti.com>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hugo Dupras <h-dupras@ti.com>
Subject: Re: [RFC][PATCH] gpiolib: add irq_wake (power-management) sysfs
	file
Message-ID: <20111115172053.GB9581@n2100.arm.linux.org.uk>
References: <1321004406-15663-1-git-send-email-p-combes@ti.com> <20111115131636.GA31028@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115131636.GA31028@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:16:37PM +0000, Mark Brown wrote:
> On Fri, Nov 11, 2011 at 10:40:06AM +0100, Patrick Combes wrote:
> > +	else if (sysfs_streq(buf, "enable") || sysfs_streq(buf, "1"))
> > +		status = enable_irq_wake(gpio_to_irq(gpio));
> > +	else if (sysfs_streq(buf, "disable") || sysfs_streq(buf, "0"))
> > +		status = disable_irq_wake(gpio_to_irq(gpio));
> > +	else
> > +		status = -EINVAL;
> 
> ...this doesn't do anything to stop userspace doing multiple enables and
> disables.

It doesn't check whether gpio_to_irq(gpio) returns something sane either.
It should be doing something like this before taking the mutex:

	irq = gpio_to_irq(gpio);
	if (irq <= 0)
		return irq < 0 ? irq : -EINVAL;

and then doing (enable|disable)_irq_wake() on irq.
