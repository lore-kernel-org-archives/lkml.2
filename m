Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab1LBRyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:54:13 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:19897 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab1LBRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:54:11 -0500
Message-ID: <4ED910B6.7080000@atmel.com>
Date: Fri, 02 Dec 2011 18:53:58 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
CC: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/macb: add DT support
References: <20111202153832.GA4998@totoro> <1322846050-4543-1-git-send-email-nicolas.ferre@atmel.com> <20111202172854.GB4998@totoro>
In-Reply-To: <20111202172854.GB4998@totoro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 06:28 PM, Jamie Iles :
> Hi Nicolas,
>
> On Fri, Dec 02, 2011 at 06:14:10PM +0100, Nicolas Ferre wrote:
>> From: Jean-Christophe PLAGNIOL-VILLARD<plagnioj@jcrosoft.com>
>>
>> Allow the device tree to provide the mac address and the phy mode.
>>
>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD<plagnioj@jcrosoft.com>
>> [nicolas.ferre@atmel.com: change "compatible" node property, doc and DT hwaddr]
>> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
>> Cc: Jamie Iles<jamie@jamieiles.com>
>
> Looks nice to me.  There's a patch below to add the GEM stuff to the
> binding too if you want to role that in.

Yes, I will push it in a "v3" (I was busy correcting a bug and did not 
see your answer before sending v2...).

> Acked-by: Jamie Iles<jamie@jamieiles.com>
>
> 8<----
>
> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
> index 7f0b90a..e09e3fb 100644
> --- a/Documentation/devicetree/bindings/net/macb.txt
> +++ b/Documentation/devicetree/bindings/net/macb.txt
> @@ -1,9 +1,11 @@
> -* Cadence MACB Ethernet controller
> +* Cadence MACB/GEM Ethernet controller
>
>   Required properties:
> -- compatible: Should be "cdns,[<chip>-]macb"
> +- compatible: Should be "cdns,[<chip>-]{macb,gem}"
>     Use "cdns,at91sam9260-macb" Atmel at91sam9260 and at91sam9263 SoCs.
>     Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb"
> +  Use "cnds,pc302-gem" for Picochip picoXcell pc302 and later devices based on
> +  the Cadence GEM, or the generic form "cdns,gem".
>   - reg: Address and length of the register set for the device
>   - interrupts: Should contain macb interrupt
>   - phy-mode: String, operation mode of the PHY interface.
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index 103c6e6..89060e6 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -1247,6 +1247,8 @@ static const struct of_device_id macb_dt_ids[] = {
>   	{ .compatible = "cdns,at32ap7000-macb" },
>   	{ .compatible = "cdns,at91sam9260-macb" },
>   	{ .compatible = "cdns,macb" },
> +	{ .compatible = "cdns,pc302-gem" },
> +	{ .compatible = "cdns,gem" },
>   	{ /* sentinel */ }
>   };

BTW, I think we may also modify the MII/RMII selection code for adding 
gigabit selection... but maybe you already have the patches?

Best regards,
-- 
Nicolas Ferre
