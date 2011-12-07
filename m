Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab1LGQGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:06:12 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39896 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab1LGQGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:06:11 -0500
MIME-Version: 1.0
In-Reply-To: <1323268911-6104-1-git-send-email-robherring2@gmail.com>
References: <4EDEE2B2.7080606@gmail.com> <1323268911-6104-1-git-send-email-robherring2@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Dec 2011 08:05:49 -0800
X-Google-Sender-Auth: 0MeRb_E6ptzP279sSVom6o_zEWQ
Message-ID: <CA+55aFzz2SMvKJcRzOU0+Rd1MHMtygTmT9rDcyy7qGjuVFJKHg@mail.gmail.com>
Subject: Re: [RFC PATCH] microblaze/irq: Change NO_IRQ to 0
To: Rob Herring <robherring2@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>, John Linn <John.Linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ingo Molnar <mingo@elte.hu>,
        Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 6:41 AM, Rob Herring <robherring2@gmail.com> wrote:
>
> This patch changes the Microblaze NO_IRQ setting from -1 to 0 to bring
> it in line with most of the rest of the kernel.  It also prepares for
> Microblaze eventually supporting multiple interrupt controllers by
> breaking the assumption that hwirq# == Linux IRQ#.  The Linux IRQ
> number is just a cookie with no guarantee of a direct relationship
> with the hardware irq arrangement.

This looks really nice and would probably be a great example for other
architectures with the same issue.

My only (small) nit is that just from a debuggability standpoint I'd
actually suggest keeping the "translated" and "hardware" interrupt
numbers totally disjoint, which would seem to be trivial - make the
offset be 32 instead of 1. Sure, some NR_IRQ arrays would end up being
a bit bigger that way, but it would allow for trivially seeing whether
anybody reports the raw or translated irq numbers by just looking at
the number. That could reduce lots of confusion if somebody ends up
having the old non-translated number hardcoded etc.

It would also potentially allow for actual debug checks - having code
like "WARN_ON_ONCE(irq < 32)" in some arch-specific irq controller
registration path etc, which is much harder to do with the overlapping
numbers.

But it's nice to see how small the patch *can* be.

               Linus
