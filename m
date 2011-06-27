Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab1F0J0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:26:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:47303 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab1F0JYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:24:38 -0400
Subject: Re: [RFC PATCH] irq: add irq_domain translation infrastructure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110627090059.GA31287@linutronix.de>
References: <20110526065438.23444.69386.stgit@ponder>
	 <20110627090059.GA31287@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 19:24:19 +1000
Message-ID: <1309166659.32158.380.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 11:00 +0200, Sebastian Andrzej Siewior wrote:
> * Grant Likely | 2011-05-26 00:54:38 [-0600]:
> 
> >diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
> >index 39645b6..9891cd4 100644
> >--- a/arch/x86/kernel/devicetree.c
> >+++ b/arch/x86/kernel/devicetree.c
> >@@ -371,36 +321,49 @@ static struct of_ioapic_type of_ioapic_type[] =
> > 	},
> > };
> > 
> >-static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
> >-			u32 *out_hwirq, u32 *out_type)
> >+static int ioapic_dt_translate(struct irq_domain *domain,
> >+				struct device_node *controller,
> >+				const u32 *intspec, u32 intsize,
> >+				irq_hw_number_t *out_hwirq, u32 *out_type)
> > {
> >-	struct mp_ioapic_gsi *gsi_cfg;
> > 	struct io_apic_irq_attr attr;
> > 	struct of_ioapic_type *it;
> > 	u32 line, idx, type;
> >+	int rc;
> > 
> >-	if (intsize < 2)
> >+	if (controller != domain->of_node)
> > 		return -EINVAL;
> 
> Is there a reason not havining the (controller != domain->of_node) check
> in irq_create_of_mapping()?

Not all domains are associated with a single OF node.

Take xics, where there can be quite a few "source controllers" which act
as device-tree interrupt parents but there's a single global domain.
 
Cheers,
Ben.

