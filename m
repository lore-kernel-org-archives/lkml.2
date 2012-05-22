Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab2EVS07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:26:59 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:17642 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2EVS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:26:58 -0400
Message-ID: <4FBBDA70.8020307@cavium.com>
Date: Tue, 22 May 2012 11:26:56 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Daney <ddaney.cavm@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Fleming Andy-AFLEMING <afleming@freescale.com>
Subject: Re: [PATCH 4/5] netdev/phy: Add driver for Broadcom BCM87XX 10G Ethernet
 PHYs
References: <1337709592-23347-1-git-send-email-ddaney.cavm@gmail.com>	 <1337709592-23347-5-git-send-email-ddaney.cavm@gmail.com> <1337710660.3432.8.camel@joe2Laptop>
In-Reply-To: <1337710660.3432.8.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2012 18:26:56.0986 (UTC) FILETIME=[783FCBA0:01CD3848]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 11:17 AM, Joe Perches wrote:
> On Tue, 2012-05-22 at 10:59 -0700, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
>
> trivia:

As long as we are splitting hairs...

>
>> diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
> []
>> @@ -0,0 +1,237 @@
>
>> +static int bcm87xx_of_reg_init(struct phy_device *phydev)
>> +{
>> +	const __be32 *paddr;
>> +	int len, i, ret;
>> +
>> +	if (!phydev->dev.of_node)
>> +		return 0;
>> +
>> +	paddr = of_get_property(phydev->dev.of_node,
>> +				"broadcom,c45-reg-init",&len);
>> +	if (!paddr || len<  (4 * sizeof(*paddr)))
>> +		return 0;
>> +
>> +	ret = 0;
>> +	len /= sizeof(*paddr);
>> +	for (i = 0; i<  len - 3; i += 4) {
>> +		u16 devid = be32_to_cpup(paddr + i);
>> +		u16 reg = be32_to_cpup(paddr + i + 1);
>> +		u16 mask = be32_to_cpup(paddr + i + 2);
>> +		u16 val_bits = be32_to_cpup(paddr + i + 3);
>> +		int val;
>
> These might read better as
>
> 	len /= 4;

Where did the magic value of 4 come from?

> 	for (i = 0; i<  len; i++) {
> 		u16 devid	= be32_to_cpu(*paddr++);
> 		u16 reg		= be32_to_cpu(*paddr++);
> 		u16 mask	= be32_to_cpu(*paddr++);
> 		u16 val_bits	= be32_to_cpu(*paddr++);

Is the main problem that they didn't align, or that the index was 
explicit instead of implicit?

