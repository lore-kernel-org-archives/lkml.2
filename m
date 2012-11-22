Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2KVSmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:42:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47419 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab2KVSku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:50 -0500
Message-ID: <50AD6C4A.4030809@gmail.com>
Date: Thu, 22 Nov 2012 01:05:30 +0100
From: Cyril Roelandt <tipecaml@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] acpi_system_write_wakeup_device(): fix error check for
 unsigned variable.
References: <1353117263-6957-1-git-send-email-tipecaml@gmail.com> <1732852.VDXGV3Ao2T@vostro.rjw.lan>
In-Reply-To: <1732852.VDXGV3Ao2T@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 01:44 AM, Rafael J. Wysocki wrote:
> On Saturday, November 17, 2012 02:54:23 AM Cyril Roelandt wrote:
>> The LEN variable is unsigned, therefore checking whether it is less than 0 is
>> useless.
>>
>> Signed-off-by: Cyril Roelandt<tipecaml@gmail.com>
>> ---
>>   drivers/acpi/proc.c |    2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
>> index 27adb09..37871a7 100644
>> --- a/drivers/acpi/proc.c
>> +++ b/drivers/acpi/proc.c
>> @@ -366,8 +366,6 @@ acpi_system_write_wakeup_device(struct file *file,
>>
>>   	if (len>  4)
>>   		len = 4;
>> -	if (len<  0)
>> -		return -EFAULT;
>
> I would prefer to check if count<  0 instead.
>


count has type size_t, so it is also an unsigned variable. I think that 
acpi_system_write_wakeup_device really cannot be called with a "count" 
parameter that is less than 0.

WBR,
Cyril Roelandt.
