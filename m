Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2KSDyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 22:54:53 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35762 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2KSDyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 22:54:51 -0500
Message-ID: <50A9ADA8.60804@linaro.org>
Date: Mon, 19 Nov 2012 09:25:20 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org, patches@linaro.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 05/14] [media] atmel-isi: Update error check for unsigned
 variables
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org> <1353048646-10935-6-git-send-email-tushar.behera@linaro.org> <Pine.LNX.4.64.1211180014330.30062@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211180014330.30062@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 04:46 AM, Guennadi Liakhovetski wrote:
> On Fri, 16 Nov 2012, Tushar Behera wrote:
> 
>> Checking '< 0' for unsigned variables always returns false. For error
>> codes, use IS_ERR_VALUE() instead.
> 
> Wouldn't just changing "irq" type to "int" also work? I think that would 
> be a more straight-forward solution. If however there are strong arguments 
> against that, I'm fine with this fix too.
> 

By changing irq to signed variable, we would get compilation warning in
subsequent line (request_irq).

> Thanks
> Guennadi
> 
>>
>> CC: Mauro Carvalho Chehab <mchehab@infradead.org>
>> CC: linux-media@vger.kernel.org
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  drivers/media/platform/soc_camera/atmel-isi.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
>> index 6274a91..5bd65df 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -1020,7 +1020,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
>>  	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>>  
>>  	irq = platform_get_irq(pdev, 0);
>> -	if (irq < 0) {
>> +	if (IS_ERR_VALUE(irq)) {
>>  		ret = irq;
>>  		goto err_req_irq;
>>  	}
>> -- 
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 


-- 
Tushar Behera
