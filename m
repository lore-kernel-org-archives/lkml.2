Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab1F0JCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:02:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:54941 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab1F0JBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:01:05 -0400
Date: Mon, 27 Jun 2011 11:00:59 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] irq: add irq_domain translation infrastructure
Message-ID: <20110627090059.GA31287@linutronix.de>
References: <20110526065438.23444.69386.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110526065438.23444.69386.stgit@ponder>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-05-26 00:54:38 [-0600]:

>diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
>index 39645b6..9891cd4 100644
>--- a/arch/x86/kernel/devicetree.c
>+++ b/arch/x86/kernel/devicetree.c
>@@ -371,36 +321,49 @@ static struct of_ioapic_type of_ioapic_type[] =
> 	},
> };
> 
>-static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
>-			u32 *out_hwirq, u32 *out_type)
>+static int ioapic_dt_translate(struct irq_domain *domain,
>+				struct device_node *controller,
>+				const u32 *intspec, u32 intsize,
>+				irq_hw_number_t *out_hwirq, u32 *out_type)
> {
>-	struct mp_ioapic_gsi *gsi_cfg;
> 	struct io_apic_irq_attr attr;
> 	struct of_ioapic_type *it;
> 	u32 line, idx, type;
>+	int rc;
> 
>-	if (intsize < 2)
>+	if (controller != domain->of_node)
> 		return -EINVAL;

Is there a reason not havining the (controller != domain->of_node) check
in irq_create_of_mapping()?

Sebastian
