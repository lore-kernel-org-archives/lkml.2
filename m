Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1L0OqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:46:15 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:13047 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347Ab1L0OqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:46:13 -0500
X-IronPort-AV: E=Sophos;i="4.71,415,1320620400"; 
   d="scan'208";a="136990967"
Date: Tue, 27 Dec 2011 15:46:10 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] drivers/mtd/nand/txx9ndfmc.c: use
 devm_request_and_ioremap
In-Reply-To: <1324997145.1165.88.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.02.1112271545480.1838@localhost6.localdomain6>
References: <1324994491-21828-1-git-send-email-julia@diku.dk>  <1324994491-21828-7-git-send-email-julia@diku.dk> <1324997145.1165.88.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011, Artem Bityutskiy wrote:

> On Tue, 2011-12-27 at 15:01 +0100, Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> Reimplement a call to devm_request_mem_region followed by a call to ioremap
>> or ioremap_nocache by a call to devm_request_and_ioremap.
>>
>> The semantic patch that makes this transformation is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @nm@
>> expression myname;
>> identifier i;
>> @@
>>
>> struct platform_driver i = { .driver = { .name = myname } };
>>
>> @@
>> expression dev,res,size;
>> expression nm.myname;
>> @@
>>
>> -if (!devm_request_mem_region(dev, res->start, size,
>> -                              \(res->name\|dev_name(dev)\|myname\))) {
>> -   ...
>> -   return ...;
>> -}
>> ... when != res->start
>> (
>> -devm_ioremap(dev,res->start,size)
>> +devm_request_and_ioremap(dev,res)
>> |
>> -devm_ioremap_nocache(dev,res->start,size)
>> +devm_request_and_ioremap(dev,res)
>> )
>> ... when any
>>     when != res->start
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> Pushed to l2-mtd-2.6.git, thanks!
>
> I think this semantic patch is also useful and deserves to be added to
> scripts/coccinelle. In general, it would be great if you sumbitted
> useful spatches there for inclusion.

OK, I will add this one as well.

julia
