Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab0D3WCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 18:02:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759030Ab0D3WCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 18:02:31 -0400
Message-ID: <4BDB534A.2000301@redhat.com>
Date: Fri, 30 Apr 2010 18:01:46 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [PATCH] Fix NULL pointer for Xen guests
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <4BDB43CD.3040505@zytor.com>
In-Reply-To: <4BDB43CD.3040505@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/30/2010 04:55 PM, H. Peter Anvin wrote:
> This looks like it should be tagged stable for 2.6.33.  Is that correct?
>
>    

Yes.

P.

> 	-hpa
>
> On 04/27/2010 08:24 AM, Prarit Bhargava wrote:
>    
>> Upstream PV guests fail to boot because of a NULL pointer.  It is possible that
>> xen guests have irq_desc->chip_data = NULL.
>>
>> Test for NULL chip_data pointer before attempting to complete an irq move.
>>
>> Signed-off-by: Prarit Bhargava<prarit@redhat.com>
>> Acked-by: Suresh Siddha<suresh.b.siddha@intel.com>
>>
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 127b871..eb2789c 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
>>   	struct irq_desc *desc = irq_to_desc(irq);
>>   	struct irq_cfg *cfg = desc->chip_data;
>>
>> +	if (!cfg)
>> +		return;
>> +
>>   	__irq_complete_move(&desc, cfg->vector);
>>   }
>>   #else
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>      
>    
