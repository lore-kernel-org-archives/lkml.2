Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0GFUSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 16:18:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62335 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0GFUSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 16:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qj6TGffx+NL0Ri0Nb859Kfb4bIj92XWoj3qAPLHFObGONm2K+Mw9wD/BABtTmK1AS8
         HXBdn38bz+N6/2SvX8WvtIPeJ9hJ5N63L95DWz7rWeyPcqhPWkxNOaUpzI/E/5ZJN2JS
         xJm7DC+BMbarni1klwtdyJfdQt2GR6OMn8hTA=
Message-ID: <4C338FA8.7020707@gmail.com>
Date: Tue, 06 Jul 2010 13:18:48 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Sergey V." <sftp.mtuci@gmail.com>
CC: minyard@acm.org, akpm@linux-foundation.org,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jillsmitt@linuxcenter.kz
Subject: Re: [PATCH v2]ipmi:ipmi_si_intf.c Fix warning: variable 'addr_space'
 set but not used
References: <1278436544-6091-1-git-send-email-justinmattock@gmail.com> <201007062205.30616.sftp.mtuci@gmail.com> <4C337628.7080006@gmail.com> <201007070014.36816.sftp.mtuci@gmail.com>
In-Reply-To: <201007070014.36816.sftp.mtuci@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 01:14 PM, Sergey V. wrote:
> On Tuesday 06 of July 2010 22:30:00 Justin P. Mattock wrote:
>>
>>> Hello Justin.
>>>
>>> [...]
>>>> @@ -2021,10 +2020,6 @@ static __devinit int try_init_spmi(struct SPMITable
>>> *spmi)
>>>>    	}
>>>>
>>>>    	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
>>>> -		addr_space = IPMI_MEM_ADDR_SPACE;
>>>> -	else
>>>> -		addr_space = IPMI_IO_ADDR_SPACE;
>>>> -
>>>>    	info = kzalloc(sizeof(*info), GFP_KERNEL);
>>>>    	if (!info) {
>>>>    		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
>>>
>>> This looks like after applying this patch 'info = ...' will be part of
>>> if statement (without indent before 'info = ...')
>>>
>>> 	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
>>> 		info = kzalloc(sizeof(*info), GFP_KERNEL);
>>>
>>> It's correct?
>>>
>>> Thanks
>>>
>>
>> the original patch I dont think this is correct. a bit confusing with
>> the if(!info) at the bottom of this.
>> here's an updated version if it looks to be correct I'll resend if not
>> I'll redu:
>>
>>
>> ---
>>    drivers/char/ipmi/ipmi_si_intf.c |    7 -------
>>    1 files changed, 0 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
>> b/drivers/char/ipmi/ipmi_si_intf.c
>> index 094bdc3..ef03ecd 100644
>> --- a/drivers/char/ipmi/ipmi_si_intf.c
>> +++ b/drivers/char/ipmi/ipmi_si_intf.c
>> @@ -2013,19 +2013,12 @@ struct SPMITable {
>>    static __devinit int try_init_spmi(struct SPMITable *spmi)
>>    {
>>    	struct smi_info  *info;
>> -	u8 		 addr_space;
>>
>>    	if (spmi->IPMIlegacy != 1) {
>>    		printk(KERN_INFO PFX "Bad SPMI legacy %d\n", spmi->IPMIlegacy);
>>    		return -ENODEV;
>>    	}
>>
>> -	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
>> -		addr_space = IPMI_MEM_ADDR_SPACE;
>> -	else
>> -		addr_space = IPMI_IO_ADDR_SPACE;
>> -
>> -	info = kzalloc(sizeof(*info), GFP_KERNEL);
>>    	if (!info) {
>>    		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
>>    		return -ENOMEM;
>> -- 1.7.1.rc1.21.gf3bd6
>>
>> Thanks for the info on this..
>>
>> Justin P. Mattock
>>
>
> Sorry, but I think that new patch is not correct.
>
> Why do you delete this row "info = kzalloc(sizeof(*info), GFP_KERNEL)"?
> There is the only one unused variable `addr_space`, so I think it should
> be removed, that's all.
>
> The following code is correct and not need to be changed:
>
> 	info = kzalloc(sizeof(*info), GFP_KERNEL);
> 	if (!info) {
> 		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
>
> Please see below my patch.
> Thanks.
>
> ---
> Fix compile warning
> drivers/char/ipmi/ipmi_si_intf.c: In function 'try_init_spmi':
> drivers/char/ipmi/ipmi_si_intf.c:2016:8: warning: variable 'addr_space' set but
> not used
>
> Signed-off-by: Sergey V.<sftp.mtuci@gmail.com>
> ---
>   drivers/char/ipmi/ipmi_si_intf.c |    6 ------
>   1 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
> b/drivers/char/ipmi/ipmi_si_intf.c
> index 094bdc3..1f5f025 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -2013,18 +2013,12 @@ struct SPMITable {
>   static __devinit int try_init_spmi(struct SPMITable *spmi)
>   {
>   	struct smi_info  *info;
> -	u8 		 addr_space;
>
>   	if (spmi->IPMIlegacy != 1) {
>   		printk(KERN_INFO PFX "Bad SPMI legacy %d\n", spmi->IPMIlegacy);
>   		return -ENODEV;
>   	}
>
> -	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
> -		addr_space = IPMI_MEM_ADDR_SPACE;
> -	else
> -		addr_space = IPMI_IO_ADDR_SPACE;
> -
>   	info = kzalloc(sizeof(*info), GFP_KERNEL);
>   	if (!info) {
>   		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");


well if everybody agrees with your change then all good...

Justin P. Mattock
