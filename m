Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2KLNYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:24:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:36711 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2KLNY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:24:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,762,1344236400"; 
   d="scan'208";a="167202611"
Date: Mon, 12 Nov 2012 15:27:39 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 1/3] ACPI: Move device resources interpretation code from
 PNP to ACPI core
Message-ID: <20121112132739.GD31759@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <2429141.J1r7BIpiiT@vostro.rjw.lan>
 <1370133.TuantNmiU4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370133.TuantNmiU4@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 01:00:26PM +0100, Rafael J. Wysocki wrote:
> +/**
> + * acpi_dev_irq_flags - Determine IRQ resource flags.
> + * @triggering: Triggering type as provided by ACPI.
> + * @polarity: Interrupt polarity as provided by ACPI.
> + * @shareable: Whether or not the interrupt is shareable.
> + */
> +unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable)
> +{
> +	unsigned long flags = IORESOURCE_IRQ;
> +
> +	if (triggering == ACPI_LEVEL_SENSITIVE)
> +		flags = polarity == ACPI_ACTIVE_LOW ?
> +			IORESOURCE_IRQ_LOWLEVEL : IORESOURCE_IRQ_HIGHLEVEL;

This wants to have '|=' instead of '='.

> +	else
> +		flags = polarity == ACPI_ACTIVE_LOW ?
> +			IORESOURCE_IRQ_LOWEDGE : IORESOURCE_IRQ_HIGHEDGE;

Ditto.

> +
> +	if (shareable == ACPI_SHARED)
> +		flags |= IORESOURCE_IRQ_SHAREABLE;
> +
> +	return flags;
> +}
> +EXPORT_SYMBOL_GPL(acpi_dev_irq_flags);
