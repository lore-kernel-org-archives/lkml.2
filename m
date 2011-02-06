Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1BFWGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:06:36 -0500
Received: from www.tglx.de ([62.245.132.106]:48424 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab1BFWGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:06:34 -0500
Date: Sun, 6 Feb 2011 23:06:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
cc: sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>, gregkh@suse.de,
        jbarnes@virtuousgeek.org, dmitry.torokhov@gmail.com, dtor@mail.ru,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: Request (2nd) for unicore32 architecture codes to merge into
 linux-next
In-Reply-To: <01c701cbba0f$08185800$18490800$@mprc.pku.edu.cn>
Message-ID: <alpine.LFD.2.00.1102062254560.31804@localhost6.localdomain6>
References: <01c701cbba0f$08185800$18490800$@mprc.pku.edu.cn>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, Guan Xuetao wrote:

> Hi, I want to merge unicore32 repo into linux-next tree, the
> position is (unicore32 branch):

Sorry for late reply.
 
>  arch/unicore32/kernel/time.c                  |  148 +++++

static struct clock_event_device ckevt_puv3_osmr0 ...
#ifdef CONFIG_ARCH_FPGA
        .shift          = 18, /* correct shift val: 16, but warn_on_slowpath */
#else
        .shift          = 30,
#endif

....
        ckevt_puv3_osmr0.mult =
                div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, ckevt_puv3_osmr0.shift);

Please use the function which calculates the optimizes mult/shift
values for you depending on the clock frequency.

clockevents_calc_mult_shift() is your friend.

>  arch/unicore32/kernel/irq.c                   |  426 +++++++++++++

Please convert your irq_chips to the new function pointers:

       .mask -> .irq_mask
       ...

The new functions replace the "unsigned int irq" argument with
"struct irq_data *d".

So conversion for your chips is simply

s/unsigned int irq/struct irq_data *d/

and 

s/irq/d->irq/ in the implementation.

Then your arch should select: GENERIC_HARDIRQS_NO_DEPRECATED

Otherwise I'm happy with your irq and time related patches.

Thanks,

	tglx
