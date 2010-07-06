Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0GFS30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:29:26 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37586 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0GFS3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:29:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZUenOy2CwTHmp74XKRwz2BuEdnbkxw+BGFDag6Vpj89W/SLdL9XXlp4tL6ySPo4TV9
         43mry2vojR3pWza107Hk2D+ZJarlUqtI1pvWzgxwaI/GujtpYRV935+fTyqURYuBceXO
         lxSTS/DbfDupjN0eL8TNheW05xlSAssj1TVMw=
Message-ID: <4C337628.7080006@gmail.com>
Date: Tue, 06 Jul 2010 11:30:00 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Sergey V." <sftp.mtuci@gmail.com>
CC: minyard@acm.org, akpm@linux-foundation.org,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jillsmitt@linuxcenter.kz
Subject: Re: [PATCH v2]ipmi:ipmi_si_intf.c Fix warning: variable 'addr_space'
 set but not used
References: <1278436544-6091-1-git-send-email-justinmattock@gmail.com> <201007062205.30616.sftp.mtuci@gmail.com>
In-Reply-To: <201007062205.30616.sftp.mtuci@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hello Justin.
>
> [...]
>> @@ -2021,10 +2020,6 @@ static __devinit int try_init_spmi(struct SPMITable
> *spmi)
>>   	}
>>
>>   	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
>> -		addr_space = IPMI_MEM_ADDR_SPACE;
>> -	else
>> -		addr_space = IPMI_IO_ADDR_SPACE;
>> -
>>   	info = kzalloc(sizeof(*info), GFP_KERNEL);
>>   	if (!info) {
>>   		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
>
> This looks like after applying this patch 'info = ...' will be part of
> if statement (without indent before 'info = ...')
>
> 	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
> 		info = kzalloc(sizeof(*info), GFP_KERNEL);
>
> It's correct?
>
> Thanks
>

the original patch I dont think this is correct. a bit confusing with 
the if(!info) at the bottom of this.
here's an updated version if it looks to be correct I'll resend if not 
I'll redu:


---
  drivers/char/ipmi/ipmi_si_intf.c |    7 -------
  1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c 
b/drivers/char/ipmi/ipmi_si_intf.c
index 094bdc3..ef03ecd 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2013,19 +2013,12 @@ struct SPMITable {
  static __devinit int try_init_spmi(struct SPMITable *spmi)
  {
  	struct smi_info  *info;
-	u8 		 addr_space;

  	if (spmi->IPMIlegacy != 1) {
  		printk(KERN_INFO PFX "Bad SPMI legacy %d\n", spmi->IPMIlegacy);
  		return -ENODEV;
  	}

-	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		addr_space = IPMI_MEM_ADDR_SPACE;
-	else
-		addr_space = IPMI_IO_ADDR_SPACE;
-
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
  	if (!info) {
  		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
  		return -ENOMEM;
-- 1.7.1.rc1.21.gf3bd6

Thanks for the info on this..

Justin P. Mattock
