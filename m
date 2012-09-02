Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2IBPUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 11:20:10 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:34647 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108Ab2IBPUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 11:20:06 -0400
Message-ID: <5043791C.4050202@metafoo.de>
Date: Sun, 02 Sep 2012 17:19:56 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: Damien Cassou <damien.cassou@lifl.fr>, kernel-janitors@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/video/jz4740_fb.c: use devm_ functions
References: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr> <1344008414-2894-3-git-send-email-damien.cassou@lifl.fr> <5036955F.6000806@gmx.de>
In-Reply-To: <5036955F.6000806@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 10:41 PM, Florian Tobias Schandinat wrote:
> On 08/03/2012 03:40 PM, Damien Cassou wrote:
>> From: Damien Cassou <damien.cassou@lifl.fr>
>>
>> The various devm_ functions allocate memory that is released when a driver
>> detaches. This patch uses these functions for data that is allocated in the
>> probe function of a platform device and is only freed in the remove function.
>>
>> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>
> 
> Applied.
> 
> 
> Thanks,
> 
> Florian Tobias Schandinat
> 
>>
>> ---
>>  drivers/video/jz4740_fb.c |   22 ++++++----------------
>>  1 file changed, 6 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/video/jz4740_fb.c b/drivers/video/jz4740_fb.c
>> index de36693..7669770 100644
>> --- a/drivers/video/jz4740_fb.c
>> +++ b/drivers/video/jz4740_fb.c
>> @@ -659,25 +659,25 @@ static int __devinit jzfb_probe(struct platform_device *pdev)
>>  	jzfb->pdata = pdata;
>>  	jzfb->mem = mem;
>>
>> -	jzfb->ldclk = clk_get(&pdev->dev, "lcd");
>> +	jzfb->ldclk = devm_clk_get(&pdev->dev, "lcd");

I guess I'm a bit late, but we do not have devm_clk_get on jz4740 (yet), so
this patch breaks linking for this driver in next. I'll to to have this added
for the next release, but if I do not succeed we'll have to revert part of this
patch.

Also the driver does not include #include <linux/io.h>, since it is required
for devm_ioremap compilation is also broken. This one is easy to fix though,
will send a follow-up patch.

- Lars
