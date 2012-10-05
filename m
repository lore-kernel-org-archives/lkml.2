Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2JEJfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:35:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43586 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2JEJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:35:04 -0400
Message-ID: <506EA9C4.2000609@monstr.eu>
Date: Fri, 05 Oct 2012 11:35:00 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 11/11] net: xilinx: Show csum in bootlog
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu>  <1349374497-9540-11-git-send-email-monstr@monstr.eu> <1349378144.2817.23.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1349378144.2817.23.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 09:15 PM, Ben Hutchings wrote:
> On Thu, 2012-10-04 at 20:14 +0200, Michal Simek wrote:
>> Just show current setting in bootlog.
> [...]
>> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
>> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
>> @@ -1052,12 +1052,14 @@ static int __devinit temac_of_probe(struct platform_device *op)
>>   	/* Setup checksum offload, but default to off if not specified */
>>   	lp->temac_features = 0;
>>   	p = (__be32 *)of_get_property(op->dev.of_node, "xlnx,txcsum", NULL);
>> +	dev_info(&op->dev, "TX_CSUM %d\n", be32_to_cpup(p));
>>   	if (p && be32_to_cpu(*p)) {
>>   		lp->temac_features |= TEMAC_FEATURE_TX_CSUM;
>>   		/* Can checksum TCP/UDP over IPv4. */
>>   		ndev->features |= NETIF_F_IP_CSUM;
>>   	}
>>   	p = (__be32 *)of_get_property(op->dev.of_node, "xlnx,rxcsum", NULL);
>> +	dev_info(&op->dev, "RX_CSUM %d\n", be32_to_cpup(p));
> [...]
>
> Is there any particular reason you think this needs to be logged by
> default, rather than letting users run ethtool -k?  I suggest using
> dev_dbg() instead.

Ok. I have looked at it and there are missing some bits in ndev->features.

Can you please check that my setting is correct?

It is SG DMA ip/driver.
ndev->features = NETIF_F_FRAGLIST | NETIF_F_SG

With two options for csum on RX/TX. They can be selected independently.
tx Partial csum over IPv4. -> NETIF_F_IP_CSUM
tx Full csum. -> NETIF_F_HW_CSUM

rx Full csum -> NETIF_F_RXCSUM

Is there any option to support partial csum?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
