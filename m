Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0D1S3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab0D1S3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:29:37 -0400
Message-ID: <4BD87E72.4050609@redhat.com>
Date: Wed, 28 Apr 2010 14:29:06 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [PATCH] Fix NULL pointer for Xen guests
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <20100428112658.4cf11292.akpm@linux-foundation.org>
In-Reply-To: <20100428112658.4cf11292.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/28/2010 02:26 PM, Andrew Morton wrote:
> On Tue, 27 Apr 2010 11:24:42 -0400
> Prarit Bhargava<prarit@redhat.com>  wrote:
>
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
>>      
> I assume this is needed for 2.6.34?
>
> What about 2.6.33.x and earlier?
>    

Hey Andrew,

I actually pinged Chris Wright to see about including this in the 
-stable branches.  I haven't heard anything back so I'll reping him.

P.
