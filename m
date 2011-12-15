Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab1LOOCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 09:02:53 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:20682
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab1LOOCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 09:02:52 -0500
X-SpamScore: -4
X-BigFish: VS-4(z1039oz168aJ1432N98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Dec 2011 22:15:56 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Kevin Hilman <khilman@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Barry Song <baohua.song@csr.com>, Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/9] irq: convert generic-chip to use irq_domain
Message-ID: <20111215141555.GC2963@S2100-06.ap.freescale.net>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
 <1323876538-20406-4-git-send-email-robherring2@gmail.com>
 <20111215052512.GB21815@S2101-09.ap.freescale.net>
 <20111215055501.GC21815@S2101-09.ap.freescale.net>
 <4EE9F899.7010402@gmail.com>
 <4EE9FC99.6030905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EE9FC99.6030905@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 07:56:41AM -0600, Rob Herring wrote:
[...]
> >> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> >> index eb763f7..2a2aac1 100644
> >> --- a/kernel/irq/irqdomain.c
> >> +++ b/kernel/irq/irqdomain.c
> >> @@ -39,7 +39,7 @@ void irq_domain_add(struct irq_domain *domain)
> >>                         return;
> >>                 }
> >>                 d->domain = domain;
> >> -               d->hwirq = hwirq;
> >> +               d->hwirq = hwirq - domain->hwirq_base;
> > 
> > This is a problem. It entirely defeats the point of hwirq_base and it
> > would break the GIC. We need to fix this in the generic irq chip.
> > 
> 
> I think I found a fix. Can you try 's/d->hwirq/(d->hwirq % 32)/' in
> generic-chip.c.
> 
Needless to try (will try later), this will work.  But again, what do
we need to change 'd->irq - d->irq_base' at all?

-- 
Regards,
Shawn

