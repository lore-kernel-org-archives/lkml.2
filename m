Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2DCPrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:47:10 -0400
Received: from mail.solarflare.com ([216.237.3.220]:57214 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753846Ab2DCPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:47:08 -0400
Message-ID: <1333468024.2577.21.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] marvell sky2 driver: fix irq number assignment bug
From: Ben Hutchings <bhutchings@solarflare.com>
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Stephen Hemminger <shemminger@vyatta.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 3 Apr 2012 16:47:04 +0100
In-Reply-To: <201204031526.q33FQvFO031746@farm-0027.internal.tilera.com>
References: <201204031526.q33FQvFO031746@farm-0027.internal.tilera.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18814.005
X-TM-AS-Result: No--14.814300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 11:10 -0400, Chris Metcalf wrote:
> Fix a minor bug that will display wrong IRQ number in ifconfig output.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  drivers/net/ethernet/marvell/sky2.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
> index 423a1a2..879b0a4 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -4978,6 +4978,13 @@ static int __devinit sky2_probe(struct pci_dev *pdev,
>  			goto err_out_free_netdev;
>   	}
>  
> +	/*
> +	 * Need to set the IRQ # for the net_device here again after
> +	 * setting it in sky2_init_netdev() initially, because MSI
> +	 * will assign a new IRQ # to this PCI device.
> +	 */
> +	dev->irq = hw->pdev->irq;
> +
>  	err = register_netdev(dev);
>  	if (err) {
>  		dev_err(&pdev->dev, "cannot register net device\n");

I think the consensus now is that net_device::irq should be left at 0
for devices that don't support manual configuration (ISA and the like).

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

