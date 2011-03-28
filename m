Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab1C1JOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:14:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:33318 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1C1JOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:14:03 -0400
Date: Mon, 28 Mar 2011 11:13:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v2 1/2] staging: Add ST-Ericsson CG2900 driver
In-Reply-To: <1301302950-10628-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
Message-ID: <alpine.LFD.2.00.1103281110210.31464@localhost6.localdomain6>
References: <1301302950-10628-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Par-Gunnar Hjalmdahl wrote:

This wants to be split up for review.

> +/**
> + * cts_interrupt() - Called to handle CTS interrupt.
> + * @irq:	Interrupt that occurred.
> + * @dev_id:	Device ID where interrupt occurred.
> + *
> + * The cts_interrupt() function is called if interrupt on CTS occurred.
> + * It disables the interrupt and starts a new work thread to handle
> + * the interrupt.
> + */
> +static irqreturn_t cts_interrupt(int irq, void *dev_id)
> +{
> +	struct uart_info *uart_info = dev_get_drvdata(dev_id);
> +#ifdef CONFIG_PM
> +	disable_irq_wake(irq);
> +#endif
> +	disable_irq_nosync(irq);
> +
> +	/* Create work and leave IRQ context. */
> +	(void)create_work_item(uart_info, handle_cts_irq);
> +
> +	return IRQ_HANDLED;
> +}

Have you thought about using a threaded interrupt handler? That would
make all this work cruft go away.

Thanks,

	tglx
