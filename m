Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1JTMS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 08:18:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63147 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1JTMS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 08:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 20 Oct 2011 14:18:56 +0200
X-Google-Sender-Auth: 8DML8mlRCYLsA-qCRf3cSjYegRw
Message-ID: <CAMuHMdWOhKcoDoyTnKJzruZ=gpV5uKNFpXnGCkrac7oEkCihJw@mail.gmail.com>
Subject: Re: [PATCH 00/28 v6] m68k: Convert to genirq
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 13:59, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> This patch series converts the m68k/mmu (nommu was converted before)
> architecture to the generic hardirq framework.
>
>  - [01/28] genirq: Add missing "else" in irq_shutdown()
>  - [02/28] ide-{cd,floppy,tape}: Do not include <linux/irq.>
>  - [03/28] keyboard: Do not include <linux/irq.>
>  - [04/28] m68k/irq: Rename irq_controller to irq_chip
>  - [05/28] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
>  - [06/28] m68k/irq: Rename irq_node to irq_data
>  - [07/28] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
>  - [08/28] m68k/irq: Rename setup_irq() to m68k_setup_irq() and make it static
>  - [09/28] m68k/irq: Extract irq_set_chip()
>  - [10/28] m68k/irq: Add m68k_setup_irq_controller()
>  - [11/28] m68k/irq: Rename {,__}m68k_handle_int()
>  - [12/28] m68k/irq: Remove obsolete IRQ_FLG_* definitions and users
>  - [13/28] m68k/irq: Add genirq support
>  - [14/28] m68k/atari: Convert Atari to genirq
>  - [15/28] m68k/atari: Remove code and comments about different irq types
>  - [16/28] m68k/amiga: Refactor amiints.c
>  - [17/28] m68k/amiga: Convert Amiga to genirq
>  - [18/28] m68k/amiga: Optimize interrupts using chain handlers
>  - [19/28] m68k/mac: Convert Mac to genirq
>  - [20/28] m68k/mac: Optimize interrupts using chain handlers
>  - [21/28] m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
>  - [22/28] m68k/vme: Convert VME to genirq
>  - [23/28] m68k/apollo: Convert Apollo to genirq
>  - [24/28] m68k/sun3: Use the kstat_irqs_cpu() wrapper
>  - [25/28] m68k/sun3: Convert Sun3/3x to genirq
>  - [26/28] m68k/q40: Convert Q40/Q60 to genirq
>  - [27/28] m68k/irq: Remove obsolete m68k irq framework
>  - [28/28] m68k/irq: Remove obsolete support for user vector interrupt fixups
>
> Overview:
>  - [01] is a fix for the core genirq code,

This went into v3.1-rc6.

>  - [02-03] are fixes to avoid compile problems later in the conversion
>    process,

The keyboard path went into the tty -next tree.
The IDE one is still pending (I've just resent it).

>  - [04-12] refactor the current m68k irq framework to match the generic
>    hardirq framework more closely w.r.t. to its (platform) users,
>  - [13] adds generic hardirq support to the core, which can be enabled through
>    a config option, so both legacy and generic hardirq can coexist at the
>    source level during the migration,
>  - [14-26] convert the individual platforms to use generic hardirqs,
>  - [27] removes support for the legacy m68k irq framework,
>  - [28] removes a now unused feature.
>
> The code has received some testing on Amiga, Atari (mainly ARAnyM), and Mac.
> There are some known issues with drivers, which Finn and Michael are looking
> into.

Any fixes I still have to apply?

> I will update my m68k-genirq branch as soon as master.kernel.org is available
> again.

Updated, on top of m68k master (which is at v3.1-rc10 now).
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-genirq

If noone objects, I'd like to add this to the m68k master and for-3.2 branches.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
