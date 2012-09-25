Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2IYGXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:23:45 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:36639 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab2IYGXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:23:44 -0400
Message-ID: <50614DEE.9050400@c-s.fr>
Date: Tue, 25 Sep 2012 08:23:42 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: David S Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] lxt PHY: Support for the buggy LXT973 rev A2
References: <201209241400.q8OE0w38011790@localhost.localdomain> <20120924183035.GA2252@netboy.at.omicron.at>
In-Reply-To: <20120924183035.GA2252@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 24/09/2012 20:30, Richard Cochran a écrit :
> On Mon, Sep 24, 2012 at 04:00:58PM +0200, Christophe Leroy wrote:
>
>> diff -u a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
>> --- a/drivers/net/phy/lxt.c	2012-09-23 03:08:48.000000000 +0200
>> +++ b/drivers/net/phy/lxt.c	2012-09-23 03:18:00.000000000 +0200
> ...
>
>> @@ -175,6 +292,16 @@
>>   	.driver		= { .owner = THIS_MODULE,},
>>   }, {
>>   	.phy_id		= 0x00137a10,
>> +	.name		= "LXT973-A2",
>> +	.phy_id_mask	= 0xffffffff,
>> +	.features	= PHY_BASIC_FEATURES,
>> +	.flags		= 0,
>> +	.probe		= lxt973_probe,
>> +	.config_aneg	= lxt973_config_aneg,
>> +	.read_status	= lxt973a2_read_status,
> I like this way of matching the A2 chips much better than what you had
> before. But are you sure this will work correctly?
Apparently it does.
>
> What do A3 chips have in the last nibble of phy_id?

A2 chip has phy_id 0x00137a10
A3 chip has phy_id 0x00137a11

Christophe
>
>> +	.driver		= { .owner = THIS_MODULE,},
>> +}, {
>> +	.phy_id		= 0x00137a10,
>>   	.name		= "LXT973",
>>   	.phy_id_mask	= 0xfffffff0,
>>   	.features	= PHY_BASIC_FEATURES,
> Thanks,
> Richard
>

