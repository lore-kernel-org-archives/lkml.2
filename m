Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2BRTo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 14:44:59 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:18733 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2BRTo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 14:44:58 -0500
Date: Sat, 18 Feb 2012 20:44:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3 v4] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <20120218204448.224903bf@endymion.delvare>
In-Reply-To: <f493506b-2223-4c1d-8572-d8f7f06961b6@zimbra>
References: <c68928fc-816e-4738-9108-ee3dfbf6427b@zimbra>
	<f493506b-2223-4c1d-8572-d8f7f06961b6@zimbra>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, BTW...

On Fri, 17 Feb 2012 17:28:23 -0600 (CST), Aaron Sierra wrote:
> This driver currently creates resources for use by a forthcoming ICH
> chipset GPIO driver. It could be expanded to created the resources for
> converting the esb2rom (mtd) and iTCO_wdt (wdt), and potentially more,
> drivers to use the mfd model.
> 
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> (...)
> +static void lpc_ich_finalize_cell(struct mfd_cell *cell,
> +					const struct pci_device_id *id)
> +{
> +	cell->id = id->driver_data;

I don't think this makes any sense. By using global variables for
per-device resources and states, your driver pretty much assumes that
at most one supported device is present on every given system (which is
indeed always the case AFAIK.) So you should set id to 0 here...

> +	cell->platform_data = &lpc_chipset_info[id->driver_data];
> +	cell->pdata_size = sizeof(struct lpc_ich_info);
> +}
> (...)
> +	ret = mfd_add_devices(&dev->dev, 0, &lpc_ich_cells[LPC_GPIO],
> +				1, NULL, 0);

... and to -1 here, so that the platform devices created don't receive a
number at all. Many mfd drivers do exactly this.

-- 
Jean Delvare
