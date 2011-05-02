Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab1EBPPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:15:53 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:40326 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932169Ab1EBPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:15:51 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18QK7fS1/LYd3QhSX8/4Nm6
Date: Mon, 2 May 2011 08:15:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/8] arm/dt: probe for platforms via the device tree
Message-ID: <20110502151542.GG2092@atomide.com>
References: <20110429070135.12522.35745.stgit@ponder>
 <20110429071548.12522.56929.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429071548.12522.56929.stgit@ponder>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [110429 00:13]:
> +
> +/**
> + * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
> + * @dt_phys: physical address of dt blob
> + *
> + * If a dtb was passed to the kernel in r2, then use it to choose the
> + * correct machine_desc and to setup the system.
> + */
> +struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
> +{
...

> +
> +	/* Retrieve various information from the /chosen node */
> +	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);

Just to make sure we're considering properly what this change means..

Does this patch require using CONFIG_CMDLINE_FORCE for older bootloaders
with the device tree append patch?

Or should we still somehow get ATAG_CMDLINE let's say in the uncompress
code and use that if nothing else is found?

Otherwise booting old boards with the same kernel will be painful as
it requires a kernel recompile to set the cmdline..

Also, not counting the separate DT append issues, I got things booting
with these patches (and the dts files) on omaps. So for patches 1 - 5,
and patch 8:

Tested-by: Tony Lindgren <tony@atomide.com>

I don't have versatile or tegra, so can't test those :)
