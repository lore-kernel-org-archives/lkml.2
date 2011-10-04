Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab1JDR76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:59:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63803 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab1JDR7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:59:55 -0400
Date: Tue, 4 Oct 2011 11:59:46 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-ide@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ahci: add DT binding for Calxeda AHCI controller
Message-ID: <20111004175946.GA2870@ponder.secretlab.ca>
References: <1314976215-23902-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314976215-23902-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:10:15AM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add devicetree match table to ahci platform driver for Calxeda Highbank
> AHCI controller.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  .../devicetree/bindings/ata/calxeda-sata.txt       |   17 +++++++++++++++++
>  drivers/ata/ahci_platform.c                        |    7 +++++++
>  2 files changed, 24 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/calxeda-sata.txt
> 
> diff --git a/Documentation/devicetree/bindings/ata/calxeda-sata.txt b/Documentation/devicetree/bindings/ata/calxeda-sata.txt
> new file mode 100644
> index 0000000..79caa56
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ata/calxeda-sata.txt
> @@ -0,0 +1,17 @@
> +* Calxeda SATA Controller
> +
> +SATA nodes are defined to describe on-chip Serial ATA controllers.
> +Each SATA controller should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains "calxeda,hb-ahci"
> +- interrupts        : <interrupt mapping for SATA IRQ>
> +- reg               : <registers mapping>
> +
> +Example:
> +        sata@ffe08000 {
> +		compatible = "calxeda,hb-ahci";
> +                reg = <0xffe08000 0x1000>;
> +                interrupts = <115>;
> +        };
> +
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 6fef1fa..9bfc970 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -171,11 +171,18 @@ static int __devexit ahci_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id ahci_of_match[] = {
> +	{ .compatible = "calxeda,hb-ahci", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ahci_of_match);
> +
>  static struct platform_driver ahci_driver = {
>  	.remove = __devexit_p(ahci_remove),
>  	.driver = {
>  		.name = "ahci",
>  		.owner = THIS_MODULE,
> +		.of_match_table = ahci_of_match,
>  	},
>  };
>  
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
