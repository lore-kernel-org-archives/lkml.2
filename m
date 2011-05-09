Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1EIUiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:38:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49108 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1EIUiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aCdOvm4aAGYD2QgTdWtWxbVuosp3y9TL8RoyZvV+ZnUo5OcrfBFs9Cpi8pERhrHjqJ
         xzWBPHtiMi7kCKLhArBXI3xz6DK2iPx38+AP5ZONO1A59Q1nGUYQLBTAh6Z+gAXlBq/B
         uUYeO8viAyPQEzyMLSNN6/wb3+w6mwEyoqY/s=
Message-ID: <4DC85081.9090105@gmail.com>
Date: Mon, 09 May 2011 22:37:21 +0200
From: Vladimir Motyka <vladimir.motyka@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: cjb@laptop.org, kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mmc/card/block.c: fix potential null dereference
 'idata'
References: <4DC7F4AB.90607@gmail.com> <Pine.LNX.4.64.1105091631400.15483@pc-004.diku.dk> <4DC802C0.9040302@gmail.com> <Pine.LNX.4.64.1105091713080.15483@pc-004.diku.dk> <4DC8117C.7060200@gmail.com> <Pine.LNX.4.64.1105091811320.15483@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1105091811320.15483@pc-004.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 06:12 PM, Julia Lawall wrote:
> I guess there is also a point at which idata has been successfully 
> allocated but idata->buf has not.
> 
> julia
> 
Yes there is. Thank You for pointing out.

Vladimir Motyka

> On Mon, 9 May 2011, Vladimir Motyka wrote:
> 
>> When allocation of idata fails there was a null dereference.
>>
>> Signed-off-by: Vladimir Motyka <vladimir.motyka@gmail.com>
>> ---
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index 407836d..a03cdc6 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -237,7 +237,7 @@ static struct mmc_blk_ioc_data
>> *mmc_blk_ioctl_copy_from_user(
>>  	idata = kzalloc(sizeof(*idata), GFP_KERNEL);
>>  	if (!idata) {
>>  		err = -ENOMEM;
>> -		goto copy_err;
>> +		goto alloc_err;
>>  	}
>>
>>  	if (copy_from_user(&idata->ic, user, sizeof(idata->ic))) {
>> @@ -268,8 +268,8 @@ static struct mmc_blk_ioc_data
>> *mmc_blk_ioctl_copy_from_user(
>>  copy_err:
>>  	kfree(idata->buf);
>>  	kfree(idata);
>> +alloc_err:
>>  	return ERR_PTR(err);
>> -
>>  }
>>
>>  static int mmc_blk_ioctl_cmd(struct block_device *bdev,
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

