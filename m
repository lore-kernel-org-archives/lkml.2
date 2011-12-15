Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1LOFqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:46:32 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:40263
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514Ab1LOFqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:46:31 -0500
X-SpamScore: -2
X-BigFish: VS-2(z1039oz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Dec 2011 13:55:04 +0800
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
Message-ID: <20111215055501.GC21815@S2101-09.ap.freescale.net>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
 <1323876538-20406-4-git-send-email-robherring2@gmail.com>
 <20111215052512.GB21815@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111215052512.GB21815@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 01:25:20PM +0800, Shawn Guo wrote:
> On Wed, Dec 14, 2011 at 09:28:52AM -0600, Rob Herring wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > Add irq domain support to irq generic-chip. This enables users of
> > generic-chip to support dynamic irq assignment needed for DT interrupt
> > binding. Users must be converted to use irq_data.hwirq for determining
> > local interrupt numbers rather than using the Linux irq number.
> > 
> > irq_base is kept for now as there are a few users of it. Once they
> > are converted to use the irq domain, it can be removed.
> > 
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > ---
> 
> Tested-by: Shawn Guo <shawn.guo@linaro.org>
> 
Sorry, I have to take that tag back after I correct my test setup.
It does not work for imx5 TZIC case, because the following change
I suggested before is missed.

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index eb763f7..2a2aac1 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -39,7 +39,7 @@ void irq_domain_add(struct irq_domain *domain)
                        return;
                }
                d->domain = domain;
-               d->hwirq = hwirq;
+               d->hwirq = hwirq - domain->hwirq_base;
        }

        mutex_lock(&irq_domain_mutex);

-- 
Regards,
Shawn

