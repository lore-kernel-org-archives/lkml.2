Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423Ab2ERHzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:55:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:48882 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760274Ab2ERHzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:55:18 -0400
Date: Fri, 18 May 2012 09:55:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ning Jiang <ning.n.jiang@gmail.com>
cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: add IRQS_PENDING for nested, simple and level handler to early
 abort suspend operation
In-Reply-To: <CAH3Oq6Rhqr+cZmYPCOhHqOP=B60zw_GRFDCkOTjEr9wp9NtFmA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1205180950400.3231@ionos>
References: <CAH3Oq6Rhqr+cZmYPCOhHqOP=B60zw_GRFDCkOTjEr9wp9NtFmA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Ning Jiang wrote:

> During suspend check_wakeup_irqs() will check IRQS_PENDING flag to
> abort a suspend operation, however, this only applies for edge
> triggered irq. Add IRQS_PENDING for nested, simple and level handler
> to mimic the same behaviour as edge irq handler.
> 
> Without this optimization, level irq can be handled correctly but there
> is some penalty. It has to go through a full run/suspend power cycle for level
> irq to be detected and handled. With it, we can abort the suspend operation
> earlier and thus shorten the interrupt latency.
> 
> I know this is ugly as IRQS_PENDING is intended for edge irq but I don't
> know how to do it in a right way. Please enlighten me if you have better ideas.

First of all, please send patches inlined. Aside of that a similar
patch is queued in tip/irq/core commit d4dc0f90.

Thanks,

	tglx


