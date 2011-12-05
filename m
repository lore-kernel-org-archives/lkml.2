Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1LEUVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:21:33 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41465 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab1LEUVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:21:31 -0500
Date: Tue, 6 Dec 2011 00:21:25 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        linux-ide@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111205202125.GA32592@oksana.dev.rtsoft.ru>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
 <20111202192618.GC3037@localhost.localdomain>
 <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
 <1322867573.11728.22.camel@pasglop>
 <20111205161157.GA27550@localhost.localdomain>
 <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
 <20111205180253.GB29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051310150.2357@xanadu.home>
 <4EDD1897.4030208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EDD1897.4030208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 01:16:39PM -0600, Rob Herring wrote:
[...]
> At least for DT enabled platforms, we could force "no irq" to be 0 in
> the DT irq code. Searching the dts files, I found 2 occurrences of IRQ0.

Please note that there are HW IRQ numbers and "Virtual" IRQ numbers.
dev->irq and thus the thing that we pass into request_irq() is a
virtual IRQ thing, a "cookie".

While in device tree you see real HW IRQ numbers.

Legal VIRQ is always > 0, while HW IRQ could be >= 0.

> Prima2 has timer on IRQ0, and VersatileAB has watchdog on IRQ0. Prima2
> should be fine currently as it doesn't use the of_irq_* functions to get
> the timer irq, but that is an issue as it skips any translation.
> VersatileAB should be okay with the VIC irqdomain support.

It shouldn't be an issue to use of_irq_*() functions for these IRQs.
of_irq_*() will remap HW IRQ 0 to some other VIRQ. If it does not do
this currently, then it's a bug and should be fixed.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
