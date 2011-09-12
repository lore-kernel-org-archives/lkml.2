Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1ILHyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 03:54:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:60174 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1ILHx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 03:53:59 -0400
Date: Mon, 12 Sep 2011 09:53:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/28] genirq: Add missing "else" in irq_shutdown()
In-Reply-To: <1315742394-16036-2-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.LFD.2.02.1109120953190.2723@ionos>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org> <1315742394-16036-2-git-send-email-geert@linux-m68k.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Sep 2011, Geert Uytterhoeven wrote:

> If an irq_chip provides .irq_shutdown(), but neither of .irq_disable() or
> .irq_mask(), free_irq() crashes when jumping to NULL.
> Fix this by only trying .irq_disable() and .irq_mask() if there's no
> .irq_shutdown() provided.
> 
> This revives the symmetry with irq_startup(), which tries .irq_startup(),
> .irq_enable(), and irq_unmask(), and makes it consistent with the comment for
> irq_chip.irq_shutdown() in <linux/irq.h>, which says:
> 
>  * @irq_shutdown:	shut down the interrupt (defaults to ->disable if NULL)
> 
> This is also how __free_irq() behaved before the big overhaul, cfr. e.g.
> 3b56f0585fd4c02d047dc406668cb40159b2d340 ("genirq: Remove bogus conditional"),
> where the core interrupt code always overrode .irq_shutdown() to
> .irq_disable() if .irq_shutdown() was NULL.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Applied into irq/urgent with a note to stable@...

Thanks,

	tglx
