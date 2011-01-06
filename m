Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1AFTLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:11:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49003
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab1AFTLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:11:16 -0500
Date: Thu, 06 Jan 2011 11:11:48 -0800 (PST)
Message-Id: <20110106.111148.189705155.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: axel.lin@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ixp4xx_eth: Return proper error for eth_init_one
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3bp3vi6v9.fsf@intrepid.localdomain>
References: <1294205046.8294.2.camel@mola>
	<m3bp3vi6v9.fsf@intrepid.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 05 Jan 2011 18:43:22 +0100

> Axel Lin <axel.lin@gmail.com> writes:
> 
>> Return PTR_ERR(port->phydev) instead of 1 if phy_connect failed.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
>> --- a/drivers/net/arm/ixp4xx_eth.c
>> +++ b/drivers/net/arm/ixp4xx_eth.c
>> @@ -1229,8 +1229,10 @@ static int __devinit eth_init_one(struct platform_device *pdev)
>>  	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT, "0", plat->phy);
>>  	port->phydev = phy_connect(dev, phy_id, &ixp4xx_adjust_link, 0,
>>  				   PHY_INTERFACE_MODE_MII);
>> -	if ((err = IS_ERR(port->phydev)))
>> +	if (IS_ERR(port->phydev)) {
>> +		err = PTR_ERR(port->phydev);
>>  		goto err_free_mem;
>> +	}
>>  
>>  	port->phydev->irq = PHY_POLL;
> 
> Right. Thanks.
> 
> Acked-by: Krzysztof Halasa <khc@pm.waw.pl>

I'll apply this, thanks.
