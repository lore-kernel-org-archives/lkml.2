Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965619Ab2JYNmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:42:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38966 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965359Ab2JYNl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:41:58 -0400
Message-ID: <50894198.40003@ti.com>
Date: Thu, 25 Oct 2012 15:41:44 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <sshtylyov@mvista.com>
Subject: Re: [PATCH v4 6/7] usb: dwc3-omap: Minor fixes to get dt working
References: <1350307680-24938-1-git-send-email-kishon@ti.com> <1350307680-24938-7-git-send-email-kishon@ti.com>
In-Reply-To: <1350307680-24938-7-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 10/15/2012 03:27 PM, Kishon Vijay Abraham I wrote:
> Includes few minor fixes in dwc3-omap like populating the compatible
> string in a correct way, extracting the utmi-mode property properly and
> changing the index of get_irq since irq of core is removed from hwmod
> entry.
> Also updated the documentation with dwc3-omap device tree binding
> information.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/dwc3-omap.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index b84ddf3..10aad46 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -318,11 +318,10 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
>  	struct resource		*res;
>  	struct device		*dev = &pdev->dev;
>  
> -	int			size;
>  	int			ret = -ENOMEM;
>  	int			irq;
>  
> -	const u32		*utmi_mode;
> +	u32			utmi_mode;
>  	u32			reg;
>  
>  	void __iomem		*base;
> @@ -336,13 +335,13 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, omap);
>  
> -	irq = platform_get_irq(pdev, 1);
> +	irq = platform_get_irq(pdev, 0);

Cannot you use the name of the resource to avoid that kind of trick?
This is for that reason that we added the resource name in DTS :-)

>  	if (irq < 0) {
>  		dev_err(dev, "missing IRQ resource\n");
>  		return -EINVAL;
>  	}
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

Same here.

Regards,
Benoit

