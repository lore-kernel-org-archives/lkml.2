Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2D0GVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:21:22 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59520 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab2D0GVU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:21:20 -0400
MIME-Version: 1.0
In-Reply-To: <878vhi9qj8.fsf@ti.com>
References: <20120425025637.7832.14013.stgit@notabene.brown>
 <20120425030524.7832.52047.stgit@notabene.brown> <878vhi9qj8.fsf@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Fri, 27 Apr 2012 11:50:58 +0530
Message-ID: <CAMQu2gyfE6otEmWhJ7pkNYPjb8iUY21dzL6a3-qAGZXWP_kk-w@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC interrupts.
To: Kevin Hilman <khilman@ti.com>
Cc: NeilBrown <neilb@suse.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 2:09 AM, Kevin Hilman <khilman@ti.com> wrote:
> NeilBrown <neilb@suse.de> writes:
>

[...]

>
> From 644742ddae59731bc10aacde94645d7c49ca5ecd Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 25 Apr 2012 13:05:24 +1000
> Subject: [PATCH] ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC interrupts.
>
> Without an ->irq_set_wake() method in an irq_chip, calls to
> enable_irq_wake() will fail.  This also causes these interrupts to not
> be able to abort suspend (via check_wakeup_irqs() in late suspend.)
>
> Currently, we don't implement ->irq_set_wake() for INTC interrupts
> because they default to be wakeup enabled by setting the GRPSEL bits
> in PM init.  Even though there is no ->irq_set_wake(), we want
> enable_irq_wake() to succeed so these interrupts can abort suspend
> when necessary.
>
> To fix, set IRQCHIP_SKIP_SET_WAKE flag for all the INTC
> interrupts which avoids trying to check irq_chip->irq_set_wake()
> and failing when it doesn't exist.
>
> Longer term, we need to implement ->irq_set_wake() for the INTC
> which can manage the appropriate GRPSEL bits.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> [khilman@ti.com: rework changelog]
> Signed-off-by: Kevin Hilman <khilman@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
