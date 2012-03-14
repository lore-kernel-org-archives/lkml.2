Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030542Ab2CNChT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:37:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52252 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030236Ab2CNChR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:37:17 -0400
X-AuditID: cbfee61b-b7c62ae000000989-45-4f60045baf26
Message-id: <4F600473.1010607@samsung.com>
Date: Wed, 14 Mar 2012 11:37:39 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 03/20] Input: atmel_mxt_ts - verify object size in
 mxt_write_object
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
 <1331640263-18935-4-git-send-email-djkurtz@chromium.org>
 <4F5FF563.7080308@samsung.com>
In-reply-to: <4F5FF563.7080308@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 10:33 AM, Joonyoung Shim wrote:
> On 03/13/2012 09:04 PM, Daniel Kurtz wrote:
>> Don't allow writing past the length of an object.
>>
>> Signed-off-by: Daniel Kurtz<djkurtz@chromium.org>
>> ---
>>   drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c 
>> b/drivers/input/touchscreen/atmel_mxt_ts.c
>> index 0d4d492..e18c698 100644
>> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
>> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
>> @@ -506,7 +506,7 @@ static int mxt_write_object(struct mxt_data *data,
>>       u16 reg;
>>
>>       object = mxt_get_object(data, type);
>> -    if (!object)
>> +    if (!object || offset>= object->size)
>
> The object->size is actual object size - 1.
>
> +    if (!object || offset>  object->size)
>

OK. another patch covers this.

>
>>           return -EINVAL;
>>
>>       reg = object->start_address;
>

