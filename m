Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab2HFUED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:04:03 -0400
Received: from isis.lip6.fr ([132.227.60.2]:55390 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab2HFUEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:04:00 -0400
X-pt: isis.lip6.fr
Message-ID: <20120806215727.60177hgs4k81txvw@webmail.lip6.fr>
Date: Mon, 06 Aug 2012 21:57:27 +0200
From: Julia.Lawall@lip6.fr
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Samuel Ortiz <sameo@linux.intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers/mfd: drop frees of devm allocated data
References: <1344099049-15212-2-git-send-email-Julia.Lawall@lip6.fr>
 <20120806140515.GM4352@mwanda>
In-Reply-To: <20120806140515.GM4352@mwanda>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-15;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.11)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (isis.lip6.fr [132.227.60.2]); Mon, 06 Aug 2012 21:57:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Carpenter <dan.carpenter@oracle.com>:

> On Sat, Aug 04, 2012 at 06:50:45PM +0200, Julia Lawall wrote:
>> diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
>> index cd0bf52..2bd090e 100644
>> --- a/drivers/mfd/88pm80x.c
>> +++ b/drivers/mfd/88pm80x.c
>> @@ -45,17 +45,14 @@ int __devinit pm80x_init(struct i2c_client *client,
>>
>>  	map = devm_regmap_init_i2c(client, &pm80x_regmap_config);
>>  	if (IS_ERR(map)) {
>> -		ret = PTR_ERR(map);
>>  		dev_err(&client->dev, "Failed to allocate register map: %d\n",
>>  			ret);
>                         ^^^
> The ret = PTR_ERR(map); is still needed for the error message.

Good point.  Thanks.  I will fix it as soon as possible, at the end of  
the week.

julia

>> -		goto err_regmap_init;
>> +		return PTR_ERR(map);
>>  	}
>
> regards,
> dan carpenter
>
>




