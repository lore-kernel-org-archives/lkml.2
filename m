Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1EaJuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:50:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:41295 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab1EaJud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:50:33 -0400
Date: Tue, 31 May 2011 11:50:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
In-Reply-To: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
Message-ID: <alpine.LFD.2.02.1105311146360.3078@ionos>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
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

On Sat, 28 May 2011, Geert Uytterhoeven wrote:

> 	Hi all,
> 
> Now sparc32 has beaten me, I pushed out my work in progress of converting m68k
> to use the generic hardirq framework:

That leaves only s390 in the rain, but I don't expect that they
replace their magic interrupt opcode ever :)

> git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git m68k-genirq
> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-genirq
> 
> It contains the following commits:
> 
>   [1] ide-{cd,floppy,tape}, keyboard: Do not include <linux/irq.>
>   [2] m68k/irq: Rename irq_controller to irq_chip
>   [3] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
>   [4] m68k/irq: Rename irq_node to irq_data
>   [5] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
>   [6] m68k/irq: Rename setup_irq() to m68k_setup_irq() and make it static
>   [7] m68k/irq: Extract irq_set_chip()
>   [8] m68k/irq: Add genirq support
>   [9] m68k/atari: Convert Atari to genirq
> 
>   [1] is a temporary(?) fix to avoid redefinitions during the remainder of
>       the series,
>   [2-7] refactor the current m68k irq framework to match the generic hardirq
>         framework more closely w.r.t. to its (platform) users,
>   [8] adds generic hardirq support to the core, which can be enabled through
>       a config option, so both legacy and generic hardirq can coexist at the
>       source level during the migration,
>   [9] converts Atari to use generic hardirqs.

Very sensible approach! Patches are looking good so far! Feel free to
add Acked-by-me!

Thanks,

	tglx
