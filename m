Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2EGU0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:26:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:41958 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab2EGU0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:26:46 -0400
Date: Mon, 7 May 2012 22:26:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: init hpet event_handler to noop
In-Reply-To: <1335283031-12942-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.LFD.2.02.1205072150590.6271@ionos>
References: <1335283031-12942-1-git-send-email-vdavydov@parallels.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012, Vladimir Davydov wrote:

> If hpet is enabled by hpet_late_init() - this usually occurs on systems
> with buggy BIOS, which does not report about hpet presence through ACPI,
> hpet_clockevent's event_handler can be left uninitialized by
> clockevents_register_device() because of hpet_clockevent low rating (by
> the time hpet_late_init() is called, high prio apic timers have already
> been setup). The event_handler is then initialized a bit later by the
> clocksource_done_booting() procedure.
> 

This explanation is worse than an oracle and aside of that, it's
patently wrong.

How the hell is clocksource_done_booting() related to the HPET
clockevent mechanism?

> Normally, timer interrupts should not be delivered between these two
> calls, but if e.g. the kernel is booted using kexec, there might be some
> pending interrupts from the previous kernel's context, which can lead to
> a NULL pointer dereference in timer_interrupt().

How is kexec related to this?

And how should pending interrupts be not handled by the always first
initialized PIT ?

> Avoid this by initializing hpet's event_handler to noop in its definition.

"Avoid" is the correct term: You're avoiding to track down the root
cause of the problem. 

This is fairy tale mode. I really love fairy tales, just not in the
context of kernel code.

Please provide proper proof why this can happen instead of some
handwavy explanations.

Thanks,

	tglx
