Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1HCFdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 01:33:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab1HCFdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 01:33:40 -0400
Message-ID: <4E38DDAF.4070602@redhat.com>
Date: Wed, 03 Aug 2011 07:33:35 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Red Hat/3.1.11-2.el6_1 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] xen: off by one error in xen/setup.c
References: <1312278325-4246-1-git-send-email-imammedo@redhat.com> <1312278325-4246-2-git-send-email-imammedo@redhat.com> <20110802170710.GS11133@dumpdata.com>
In-Reply-To: <20110802170710.GS11133@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 07:07 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Aug 02, 2011 at 11:45:23AM +0200, Igor Mammedov wrote:
>> Do not try to initialize pfn beyond of available address space.
>>
>> Signed-off-by: Igor Mammedov<imammedo@redhat.com>
>> ---
>>   arch/x86/xen/setup.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
>> index 60aeeb5..2221b05 100644
>> --- a/arch/x86/xen/setup.c
>> +++ b/arch/x86/xen/setup.c
>> @@ -69,7 +69,7 @@ static void __init xen_add_extra_mem(unsigned long pages)
>>
>>   	xen_max_p2m_pfn = PFN_DOWN(extra_start + size);
>>
>> -	for (pfn = PFN_DOWN(extra_start); pfn<= xen_max_p2m_pfn; pfn++)
>> +	for (pfn = PFN_DOWN(extra_start); pfn<  xen_max_p2m_pfn; ++pfn)
>>   		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
>
> Did this actually break anything?

Not really, but for the sake of correctness and as cleanup it's good idea.

>
>>   }
>>
>> --
>> 1.7.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Thanks,
  Igor
