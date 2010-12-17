Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab0LQVRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:17:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:34403 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab0LQVRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:17:10 -0500
Subject: Re: [PATCH 07/15] of: move of_irq_map_pci() into generic code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <1292600033-12271-8-git-send-email-bigeasy@linutronix.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
	 <1292600033-12271-8-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 08:16:37 +1100
Message-ID: <1292620597.16694.541.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 16:33 +0100, Sebastian Andrzej Siewior wrote:
> +
> +#if defined(CONFIG_PPC64) || defined(CONFIG_X86)
> +static struct device_node *pci_get_parent_node(struct pci_dev *pdev)
> +{
> +       return pci_bus_to_OF_node(pdev->bus);
> +}
> +#endif
> +
> +#if defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE)
> +static struct device_node *pci_get_parent_node(struct pci_dev *pdev)
> +{
> +       struct pci_controller *host;
> +
> +       host = pci_bus_to_host(pdev->bus);
> +       return host ? host->dn : NULL;
> +}
> +#endif
> + 

I'd like it better if instead you added pci_bus_to_OF_node() to ppc32
and microblaze.

The easy way to do so is to do:

	struct pci_controller *host;

	if (bus->self)
		return pci_device_to_OF_node(bus->self);
	host = pci_bus_to_host(pdev->bus);
	return host ? host->dn : NULL;

Cheers,
Ben.


