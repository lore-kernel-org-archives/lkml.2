Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab1HXDbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:31:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48018 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1HXDbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:31:34 -0400
Message-ID: <4E547092.6040008@gmail.com>
Date: Tue, 23 Aug 2011 22:31:30 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 3/3] i2c-designware: add OF binding support
References: <1312579468-19365-1-git-send-email-robherring2@gmail.com> <1312579468-19365-4-git-send-email-robherring2@gmail.com>
In-Reply-To: <1312579468-19365-4-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

On 08/05/2011 04:24 PM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add of_match_table and DT style i2c registration to designware i2c
> driver.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: linux-i2c@vger.kernel.org
> ---

Any comments on this? If not, will you apply to your tree?

Rob

>  Documentation/devicetree/bindings/i2c/dw-i2c.txt |   23 ++++++++++++++++++++++
>  drivers/i2c/busses/i2c-designware.c              |    8 +++++++
>  2 files changed, 31 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/i2c/dw-i2c.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/dw-i2c.txt b/Documentation/devicetree/bindings/i2c/dw-i2c.txt
> new file mode 100644
> index 0000000..cbcb404
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/dw-i2c.txt
> @@ -0,0 +1,23 @@
> +* Synopsys DesignWare I2C
> +
> +Required properties :
> +
> + - compatible : should be "snps,designware-i2c"
> + - reg : Offset and length of the register set for the device
> + - interrupts : <IRQ> where IRQ is the interrupt number.
> +
> +Recommended properties :
> +
> + - clock-frequency : desired I2C bus clock frequency in Hz.
> +
> +Example :
> +
> +	i2c@f0000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "snps,designware-i2c";
> +		reg = <0xf0000 0x1000>;
> +		interrupts = <11>;
> +		clock-frequency = <400000>;
> +	};
> +
> diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
> index b7a51c4..0223b98 100644
> --- a/drivers/i2c/busses/i2c-designware.c
> +++ b/drivers/i2c/busses/i2c-designware.c
> @@ -769,6 +769,7 @@ static int __devinit dw_i2c_probe(struct platform_device *pdev)
>  			sizeof(adap->name));
>  	adap->algo = &i2c_dw_algo;
>  	adap->dev.parent = &pdev->dev;
> +	adap->dev.of_node = pdev->dev.of_node;
>  
>  	adap->nr = pdev->id;
>  	r = i2c_add_numbered_adapter(adap);
> @@ -819,6 +820,12 @@ static int __devexit dw_i2c_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id dw_i2c_of_match[] = {
> +	{ .compatible = "snps,designware-i2c", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, dw_i2c_of_match);
> +
>  /* work with hotplug and coldplug */
>  MODULE_ALIAS("platform:i2c_designware");
>  
> @@ -827,6 +834,7 @@ static struct platform_driver dw_i2c_driver = {
>  	.driver		= {
>  		.name	= "i2c_designware",
>  		.owner	= THIS_MODULE,
> +		.of_match_table = dw_i2c_of_match,
>  	},
>  };
>  

