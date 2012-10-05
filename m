Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab2JEHAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:00:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53469 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2JEHAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:00:09 -0400
Message-ID: <506E7619.3010104@monstr.eu>
Date: Fri, 05 Oct 2012 07:54:33 +0200
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
Subject: Re: [PATCH 02/11] net: axienet: Add ioctl support
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu>  <1349374497-9540-2-git-send-email-monstr@monstr.eu> <1349378262.2817.25.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1349378262.2817.25.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 09:17 PM, Ben Hutchings wrote:
> On Thu, 2012-10-04 at 20:14 +0200, Michal Simek wrote:
>> Allow user to access the MDIO from userspace.
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> CC: Anirudha Sarangi <anirudh@xilinx.com>
>> CC: John Linn <John.Linn@xilinx.com>
>> CC: Grant Likely <grant.likely@secretlab.ca>
>> CC: Rob Herring <rob.herring@calxeda.com>
>> CC: David S. Miller <davem@davemloft.net>
>> ---
>>   drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   15 +++++++++++++++
>>   1 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>> index 50167ab..a5b41cd 100644
>> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
>> @@ -1053,6 +1053,20 @@ static void axienet_poll_controller(struct net_device *ndev)
>>   }
>>   #endif
>>
>> +/* Ioctl MII Interface */
>> +static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>> +{
>> +	struct axienet_local *priv = netdev_priv(dev);
>> +
>> +	if (!netif_running(dev))
>> +		return -EINVAL;
>
> Not sure this is the appropriate error code.
>
>> +	if (!priv->phy_dev)
>> +		return -ENODEV;
>
> Error code should be EOPNOTSUPP - the device is present but just doesn't
> support MDIO.

ok. Thanks will fix it.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
