Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1JXOUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:20:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36640 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab1JXOUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:20:12 -0400
Message-ID: <4EA57417.8060709@gmail.com>
Date: Mon, 24 Oct 2011 09:20:07 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ahci: add DT binding for Calxeda AHCI controller
References: <1314976215-23902-1-git-send-email-robherring2@gmail.com> <4E8A6FB3.4090909@gmail.com>
In-Reply-To: <4E8A6FB3.4090909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

On 10/03/2011 09:30 PM, Rob Herring wrote:
> On 09/02/2011 10:10 AM, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Add devicetree match table to ahci platform driver for Calxeda Highbank
>> AHCI controller.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: Jeff Garzik <jgarzik@pobox.com>
>> Cc: linux-ide@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>> ---
> 
> Any comments on this?
> 

Ping.

Can you please apply this for 3.2.

Regards,
Rob

>>  .../devicetree/bindings/ata/calxeda-sata.txt       |   17 +++++++++++++++++
>>  drivers/ata/ahci_platform.c                        |    7 +++++++
>>  2 files changed, 24 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/ata/calxeda-sata.txt
>>
>> diff --git a/Documentation/devicetree/bindings/ata/calxeda-sata.txt b/Documentation/devicetree/bindings/ata/calxeda-sata.txt
>> new file mode 100644
>> index 0000000..79caa56
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ata/calxeda-sata.txt
>> @@ -0,0 +1,17 @@
>> +* Calxeda SATA Controller
>> +
>> +SATA nodes are defined to describe on-chip Serial ATA controllers.
>> +Each SATA controller should have its own node.
>> +
>> +Required properties:
>> +- compatible        : compatible list, contains "calxeda,hb-ahci"
>> +- interrupts        : <interrupt mapping for SATA IRQ>
>> +- reg               : <registers mapping>
>> +
>> +Example:
>> +        sata@ffe08000 {
>> +		compatible = "calxeda,hb-ahci";
>> +                reg = <0xffe08000 0x1000>;
>> +                interrupts = <115>;
>> +        };
>> +
>> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
>> index 6fef1fa..9bfc970 100644
>> --- a/drivers/ata/ahci_platform.c
>> +++ b/drivers/ata/ahci_platform.c
>> @@ -171,11 +171,18 @@ static int __devexit ahci_remove(struct platform_device *pdev)
>>  	return 0;
>>  }
>>  
>> +static const struct of_device_id ahci_of_match[] = {
>> +	{ .compatible = "calxeda,hb-ahci", },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, ahci_of_match);
>> +
>>  static struct platform_driver ahci_driver = {
>>  	.remove = __devexit_p(ahci_remove),
>>  	.driver = {
>>  		.name = "ahci",
>>  		.owner = THIS_MODULE,
>> +		.of_match_table = ahci_of_match,
>>  	},
>>  };
>>  
> 

