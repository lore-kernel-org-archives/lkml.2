Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2IFOBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:01:39 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:60796 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2IFOBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:01:37 -0400
Message-ID: <5048ACBE.2030205@atmel.com>
Date: Thu, 6 Sep 2012 16:01:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davem@davemloft.net>, <havard@skinnemoen.net>,
        <plagnioj@jcrosoft.com>, <jamie@jamieiles.com>,
        <linux-kernel@vger.kernel.org>, <patrice.vilchez@atmel.com>
Subject: Re: [PATCH 08/10] net/macb: macb_get_drvinfo: add GEM/MACB suffix
 to differentiate revision
References: <cover.1346775479.git.nicolas.ferre@atmel.com>  <fc701a2ed18198b7a671c55f1e65725f1709509c.1346775479.git.nicolas.ferre@atmel.com> <1346887671.5325.47.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1346887671.5325.47.camel@bwh-desktop.uk.solarflarecom.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 01:27 AM, Ben Hutchings :
> On Wed, 2012-09-05 at 11:00 +0200, Nicolas Ferre wrote:
>> Add an indication about which revision of the hardware we are running in
>> info->driver string.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  drivers/net/ethernet/cadence/macb.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
>> index bd331fd..c7c39f1 100644
>> --- a/drivers/net/ethernet/cadence/macb.c
>> +++ b/drivers/net/ethernet/cadence/macb.c
>> @@ -1313,6 +1313,10 @@ static void macb_get_drvinfo(struct net_device *dev,
>>  	struct macb *bp = netdev_priv(dev);
>>  
>>  	strcpy(info->driver, bp->pdev->dev.driver->name);
>> +	if (macb_is_gem(bp))
>> +		strcat(info->driver, " GEM");
>> +	else
>> +		strcat(info->driver, " MACB");
>>  	strcpy(info->version, "$Revision: 1.14 $");
> 
> Related to hardware revisions (which don't belong here, as David said),
> I rather doubt this CVS ID is very useful as a driver version.
> 
> If the driver doesn't have a meaningful version (aside from the kernel
> version) then you can remove this function and let the ethtool core fill
> in the other two fields automatically.

Absolutely, I will do this.

Thanks for the tip.

Best regards,
-- 
Nicolas Ferre
