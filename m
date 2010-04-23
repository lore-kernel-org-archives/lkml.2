Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0DWN3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:29:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44523 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab0DWN3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:29:09 -0400
Date: Fri, 23 Apr 2010 14:29:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded irq handler question
Message-ID: <20100423132907.GB28132@sirena.org.uk>
References: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l2u87a5b0801004210935wf6ca2991ua777c39c737391f8@mail.gmail.com>
X-Cookie: Reapply as necessary.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 05:35:32PM +0100, Will Newton wrote:

> I have a threaded irq handler attached to a level-triggered gpio
> interrupt line. The check handler checks the status of the gpio line
> and disables the irq line amd returns WAKE_THREAD in that case:

...

> My problem is that this structure does not work, because once I call
> disable_irq_nosync() on the irq in the check handler the thread will
> no longer run because the irq is disabled. However if I don't call
> disable_irq_nosync() I will get endless irqs because the line is
> level-triggered and will not be deasserted until the thread has run.

> Could someone tell me what I'm doing wrong here?

The genirq framework has native support for doing this using a oneshot
IRQ handler - if you request the IRQ with IRQF_ONESHOT and provide only 
a threaded IRQ handler then genirq will disable the interrupt when the
primary IRQ fires and schedule the threaded handler.

See wm831x or wm8350 for an example.
