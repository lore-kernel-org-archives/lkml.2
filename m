Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab1FPUDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:03:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:60993 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab1FPUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:03:33 -0400
Date: Thu, 16 Jun 2011 22:03:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
In-Reply-To: <BANLkTik5-H1fc2rk3QrwvQiF=7fELmE2CA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1106162201390.11814@ionos>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg> <BANLkTimebx56-Wb5JPWxYVnND9gG8OVdsQ@mail.gmail.com> <BANLkTin+gp2Cnxj8kHbHRmuoEgyDR8YeaQ@mail.gmail.com> <BANLkTik5-H1fc2rk3QrwvQiF=7fELmE2CA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Geert Uytterhoeven wrote:
> > Seems like everything (Atari/ARAnyM and Amiga) still works when using
> > handle_simple_irq instead of handle_level_irq.
> > As a bonus, BogoMIPS is above 16 again.
> 
> With handle_simple_irq(), we no longer need to define irq_{,un}mask() methods
> in our irq_chips. Hence the "old" m68k platform interrupt code seems to be much
> closer to genirq than I thought...
> 
> Does this make sense?

It makes sense, when your interrupt chips do not require any action
when an interrupt is handled. In that case you can avoid the hardware
access.

Thanks,

	tglx
