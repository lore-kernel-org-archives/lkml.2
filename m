Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab1EaULC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:11:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:44870 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab1EaUK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:10:59 -0400
Date: Tue, 31 May 2011 22:10:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
In-Reply-To: <BANLkTinsMhQZSeO_ujtYEJuOcAa=FRh-6g@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1105312208030.3078@ionos>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg> <BANLkTinsMhQZSeO_ujtYEJuOcAa=FRh-6g@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert,

On Tue, 31 May 2011, Geert Uytterhoeven wrote:
> On Sat, May 28, 2011 at 20:32, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > Next on my list is Amiga, which will cover autovectored and chained interrupts.
> 
> Plain chained interrupts should be handled by calling irq_set_chained_handler()
> to register an irq_flow_handler_t, and let the handler call
> generic_handle_irq() for
> each successive interrupt, right?
> 
> However, on Amiga we have interrupts (IRQ_AMIGA_PORTS and
> IRQ_AMIGA_EXTER) that are a combination of chained (for the CIA interrupt
> controllers) and shared level interrupts (for motherboard hardware and
> Zorro expansion
> boards).
> But irq_set_chained_handler() sets IRQ_NOREQUEST, i.e. the interrupt cannot
> be requested anymore via request_irq(), so this rules out using it with shared
> level interrupts.
> 
> What's the preferred way to handle this? Is there are standard way, or should I
> write my own specialized irq_flow_handler_t that handles both?
> 
> In the old scheme, we just registered the chain handlers with
> request_irq(), so they
> worked nicely together with the shared level interrupts (cfr.
> arch/m68k/amiga/cia.c)

You still can setup all those handlers setup via request_irq() and
handle the demux part by calling generic_handle_irq() from the handler
which deals with that demux hardware. irq_set_chained_handler() is
merily an optimization which does not apply to potentially shared
primary interrupts.

Thanks,

	tglx
