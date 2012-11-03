Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2KCOO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 10:14:56 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:43283 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911Ab2KCOOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:14:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="179992480"
Date: Sat, 3 Nov 2012 15:14:51 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: walter harms <wharms@bfs.de>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] drivers/net/ethernet/ibm/emac/mal.c: use WARN
In-Reply-To: <50950055.8040307@bfs.de>
Message-ID: <alpine.DEB.2.02.1211031513220.1955@localhost6.localdomain6>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <1351940317-14812-11-git-send-email-Julia.Lawall@lip6.fr> <50950055.8040307@bfs.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, walter harms wrote:

>
>
> Am 03.11.2012 11:58, schrieb Julia Lawall:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Use WARN rather than printk followed by WARN_ON(1), for conciseness.
>>
>> A simplified version of the semantic patch that makes this transformation
>> is as follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression list es;
>> @@
>>
>> -printk(
>> +WARN(1,
>>   es);
>> -WARN_ON(1);
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>  drivers/net/ethernet/ibm/emac/mal.c |    6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
>> index 479e43e..84c6b6c 100644
>> --- a/drivers/net/ethernet/ibm/emac/mal.c
>> +++ b/drivers/net/ethernet/ibm/emac/mal.c
>> @@ -738,13 +738,11 @@ static int __devexit mal_remove(struct platform_device *ofdev)
>>  	/* Synchronize with scheduled polling */
>>  	napi_disable(&mal->napi);
>>
>> -	if (!list_empty(&mal->list)) {
>> +	if (!list_empty(&mal->list))
>>  		/* This is *very* bad */
>> -		printk(KERN_EMERG
>> +		WARN(1, KERN_EMERG
>>  		       "mal%d: commac list is not empty on remove!\n",
>>  		       mal->index);
>> -		WARN_ON(1);
>> -	}
>>
>>  	dev_set_drvdata(&ofdev->dev, NULL);
>>
>>
>
> Hi Julia,
> you are removing the {} behin the if. I prefer to be a bit conservative
> about {}. There is suggest to keep them because WARN may be expanded in
> future (with a second line) and that will cause subtle changes that do
> no break the code. (Yes i know it is possible to write macros that
> contain savely more than one line.)

WARN is already multi-line, surrounded by ({ }).  It seems to be set up to 
be used as an expression.  Is it necessary to assume that it might someday 
be changed from safe to unsafe?

julia
