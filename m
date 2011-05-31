Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1EaKfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:35:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:36559 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab1EaKfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:35:16 -0400
Date: Tue, 31 May 2011 12:35:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] irq: handle spurios irq detection for threaded
 irqs
In-Reply-To: <1306824972-27067-2-git-send-email-sebastian@breakpoint.cc>
Message-ID: <alpine.LFD.2.02.1105311233020.3078@ionos>
References: <1306824972-27067-1-git-send-email-sebastian@breakpoint.cc> <1306824972-27067-2-git-send-email-sebastian@breakpoint.cc>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Sebastian Andrzej Siewior wrote:
>  			raw_spin_unlock_irq(&desc->lock);
> -			handler_fn(desc, action);
> +			action_ret = handler_fn(desc, action);
> +			if (!noirqdebug) {
> +				raw_spin_lock_irq(&desc->lock);

Hmm. This will deadlock in __report_bad_irq().

> +				note_interrupt(action->irq, desc, action_ret);
> +				raw_spin_unlock_irq(&desc->lock);
> +			}

Thanks,

	tglx
