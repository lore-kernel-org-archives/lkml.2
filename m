Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab2CSIuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:50:55 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:53664
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757027Ab2CSIuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:50:54 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
Message-ID: <4F66F35E.60103@analog.com>
Date: Mon, 19 Mar 2012 09:50:38 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [PATCH] mfd: adp5520: Use i2c_get_clientdata and dev_get_drvdata
 at appropriate places
References: <1332140938.10116.0.camel@phoenix>
In-Reply-To: <1332140938.10116.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 08:08 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   drivers/mfd/adp5520.c |    8 +++-----
>   1 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> index 8d816cc..1a7e22e 100644
> --- a/drivers/mfd/adp5520.c
> +++ b/drivers/mfd/adp5520.c
> @@ -309,7 +309,7 @@ out_free_chip:
>
>   static int __devexit adp5520_remove(struct i2c_client *client)
>   {
> -	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
> +	struct adp5520_chip *chip = i2c_get_clientdata(client);
>
>   	if (chip->irq)
>   		free_irq(chip->irq, chip);
> @@ -323,8 +323,7 @@ static int __devexit adp5520_remove(struct i2c_client *client)
>   #ifdef CONFIG_PM
>   static int adp5520_suspend(struct device *dev)
>   {
> -	struct i2c_client *client = to_i2c_client(dev);
> -	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
> +	struct adp5520_chip *chip = dev_get_drvdata(dev);
>
>   	adp5520_clr_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
>   	return 0;
> @@ -332,8 +331,7 @@ static int adp5520_suspend(struct device *dev)
>
>   static int adp5520_resume(struct device *dev)
>   {
> -	struct i2c_client *client = to_i2c_client(dev);
> -	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
> +	struct adp5520_chip *chip = dev_get_drvdata(dev);
>
>   	adp5520_set_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
>   	return 0;


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


