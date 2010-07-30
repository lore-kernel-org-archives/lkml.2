Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab0G3Mtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 08:49:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44665 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab0G3Mt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 08:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iEkITeRHcOgj2sCWxOiXGV7lSGWeylMLxyVbD9M7bOXCP+f40gAACoD9/JLV13boWH
         mOVlldAXJhdVo+OHtMio30t7Ye0kNDlftbNQPrNJ00nToyhflM8qhMrzuWZJRigJ5lQx
         lPHrxppPsTacBwEo+eq32ExGjoSnTZRyOh30U=
Message-ID: <4C52CA55.4000204@gmail.com>
Date: Fri, 30 Jul 2010 14:49:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: wharms@bfs.de
CC: Kulikov Vasiliy <segooon@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/9] staging: otus: check kmalloc() return value
References: <1280488080-20777-1-git-send-email-segooon@gmail.com> <4C52C614.4030803@bfs.de>
In-Reply-To: <4C52C614.4030803@bfs.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2010 02:31 PM, walter harms wrote:
> 
> 
> Kulikov Vasiliy schrieb:
>> kmalloc() may fail, if so return error from zfwUsbSubmitControl().
>>
>> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
>> ---
>>  drivers/staging/otus/wrap_usb.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/staging/otus/wrap_usb.c b/drivers/staging/otus/wrap_usb.c
>> index 93459ca..9f04047 100644
>> --- a/drivers/staging/otus/wrap_usb.c
>> +++ b/drivers/staging/otus/wrap_usb.c
>> @@ -104,6 +104,11 @@ u32_t zfwUsbSubmitControl(zdev_t *dev, u8_t req, u16_t value, u16_t index,
>>  
>>  	if (size > 0) {
>>  		buf = kmalloc(size, GFP_KERNEL);
>> +		if (buf == NULL) {
>> +			pr_err("zfwUsbSubmitControl() failed, "
>> +				  "kmalloc() returned NULL\n");
>> +			return 1;
>> +		}
>>  		memcpy(buf, (u8_t *)data, size);
>>  	} else
>>  		buf = NULL;
> 
> 
> We had a memdup() somewhere had'nt we ?

Yes, but it is not what he is changing. (Patches welcome.)

The patch is OK, except try to avoid function names in printks next
time. Function names are constantly changing, but developers tend not to
change printk strings. (%s + __func__)

regards,
-- 
js
