Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0KXNxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:53:22 -0500
Received: from www.tglx.de ([62.245.132.106]:41136 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab0KXNxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:53:21 -0500
Date: Wed, 24 Nov 2010 14:53:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [question] NR_IRQS in genirq
In-Reply-To: <AANLkTik5N0d9wcaiS538UWQ83E_HhXoWC8nMxVY__1+k@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1011241449120.2900@localhost6.localdomain6>
References: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com> <alpine.LFD.2.00.1011241416360.2900@localhost6.localdomain6> <AANLkTik5N0d9wcaiS538UWQ83E_HhXoWC8nMxVY__1+k@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Haojian Zhuang wrote:
> On Wed, Nov 24, 2010 at 9:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Why can nr_irqs become larger? Is that a theoretical problem or did
> > you run into this ?
> 
> My hardware environment is ARM. Each machine description can specify
> nr_irqs. In my implementation of PXA, NR_IRQS is fixed for SoC
> internal IRQs. And there's some additional board IRQs, we arrange them
> between NR_IRQS and nr_irqs. So nr_irqs will be larger than NR_IRQS if
> board IRQs exists.

And that's wrong. NR_IRQS is the upper bound. nr_irqs is the runtime
bound which is supposed to be <= NR_IRQS.

The whole point of sparse_irq is that it does not statically allocate
irq_desc[NR_IRQS] to reduce memory consumption if only a small number
of irqs are actuallt used by a specific board.

Thanks,

	tglx
