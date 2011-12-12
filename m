Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1LLJg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:36:26 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:40025 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab1LLJgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:36:22 -0500
X-SpamScore: -7
X-BigFish: VS-7(z1039ozbb2dI9371I103dK1432N98dKzz1202hzzz2dh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 12 Dec 2011 17:49:20 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] irq: convert generic-chip to use irq_domain
Message-ID: <20111212094919.GH9572@S2100-06.ap.freescale.net>
References: <1323470689-6200-1-git-send-email-robherring2@gmail.com>
 <20111211160025.GA9572@S2100-06.ap.freescale.net>
 <4EE554BA.9040408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EE554BA.9040408@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 07:11:22PM -0600, Rob Herring wrote:
> Shawn,
> 
> On 12/11/2011 10:00 AM, Shawn Guo wrote:
> > Hi Rob,
> > 
> > I installed the patch and played it a little bit, and I some feedback
> > below.
> 
> Thanks!
> 
> > * It breaks some existing irq_chip_generic users like imx5, which
> >   is currently numbering irq from 0.  For such users, irq_alloc_descs()
> >   will fail because it's asked to search irq #0 starting from irq #1.
> >   Yes, I know numbering irq from 0 is a bad idea and really needs to
> >   get fixed.  But is it your intention to break such users and force
> >   them get fixed with this patch?
> 
> I was trying not to break things and allow the existing irq base.
> 
> My problem is irq 0-15 are unallocated, 16-159 are the GIC. So when I
> try to allocate 8 irqdescs for gpio, I don't really want irq_alloc_descs
> to pick 0-15. Ideally we would just globally reserve 0-15 on ARM, but
> this will cause problems. So starting at 1 was at least slightly better
> than 0.
> 
> I think I'll just skip irq_alloc_descs call when the irq_base is >= 0.
> 
Yes, looks good.  But both parameter irq_base of irq_alloc_generic_chip
and member irq_base of 'struct irq_domain' are unsigned int, which
might be a little problem for irq_chip_generic users to pass -1 for
asking irq_chip_generic to allocate Linux irq numbers for it.

-- 
Regards,
Shawn

