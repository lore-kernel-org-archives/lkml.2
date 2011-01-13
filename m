Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab1AMKjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:39:08 -0500
Received: from www.tglx.de ([62.245.132.106]:46518 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab1AMKjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:39:06 -0500
Date: Thu, 13 Jan 2011 11:38:48 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH 10/15] x86/ioapic: Add OF bindings for	IO-APIC
Message-ID: <20110113103848.GA23275@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-11-git-send-email-bigeasy@linutronix.de> <20110111235353.GG2131@angua.secretlab.ca> <20110112170707.GA6907@www.tglx.de> <4D2DE2B9.2000607@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4D2DE2B9.2000607@linux.intel.com>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin | 2011-01-12 09:19:53 [-0800]:

>On 01/12/2011 09:07 AM, Sebastian Andrzej Siewior wrote:
>>>
>>> I'm confused here.  Are there multiple ioapic's described by a single
>>> device tree node?
>
>That's normal multiple IOAPIC behavior (and multiple IOAPICs is a common
>thing), but why use the same device tree node for both?

I'm sorry, I miss understood Grant's question. The two io apics in the
system are described by two nodes. ioapic_add_ofnode() is called for one
node:

> +     for (i = 0; i < nr_ioapics; i++) {
> +             if (r.start == mp_ioapics[i].apicaddr) {
> +                     struct irq_domain *id;
> +
> +                     mp_of_ioapic[i].node = np;
> +                     id = kzalloc(sizeof(*id), GFP_KERNEL);
> +                     BUG_ON(!id);
> +                     id->controller = np;
> +                     id->xlate = ioapic_xlate;
> +                     id->priv = (void *)i;
> +                     add_interrupt_host(id);
> +                     return;
> +             }

and once it matches the previously registered io apic it calls
add_interrupt_host() on it and returns. x86_add_irq_domains() calls it
for every io apic node so it calls add_interrupt_host() twice.

>	-hpa

Sebastian
