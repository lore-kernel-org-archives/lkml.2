Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab0EYWPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:15:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab0EYWPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:15:05 -0400
Message-ID: <4BFC4ABC.9010209@redhat.com>
Date: Tue, 25 May 2010 18:10:04 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, david.altobelli@hp.com,
       "Camuso, Tony" <Tony.Camuso@hp.com>
Subject: Re: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup
References: <20100522004615.25451.83108.sendpatchset@prarit.bos.redhat.com> <20100525144937.e0726ec2.akpm@linux-foundation.org>
In-Reply-To: <20100525144937.e0726ec2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/25/2010 05:49 PM, Andrew Morton wrote:
> On Fri, 21 May 2010 20:50:41 -0400
> Prarit Bhargava<prarit@redhat.com>  wrote:
>
>    
>> Fixes warning:
>>
>> drivers/misc/hpilo.c: In function ___ilo_ccb_setup___:
>> drivers/misc/hpilo.c:274: warning: cast to pointer from integer of different size
>>
>> Signed-off-by: Prarit Bhargava<prarit@redhat.com>
>>
>> diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
>> index 98ad012..b07a541 100644
>> --- a/drivers/misc/hpilo.c
>> +++ b/drivers/misc/hpilo.c
>> @@ -272,7 +272,7 @@ static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
>>   		return -ENOMEM;
>>
>>   	dma_va = (char *)data->dma_va;
>> -	dma_pa = (char *)data->dma_pa;
>> +	dma_pa = (char *)(&data->dma_pa);
>>
>>   	memset(dma_va, 0, data->dma_size);
>>      
> Seems very wrong - writes to *dmp_pa will now scribble over the `struct
> ccb_data'.
>
> Probably local variable dma_pa should have type dma_addr_t.
>    

Ugh ... I even passed this by a colleague at HP :/.  I'll fix it up and 
repost.

P.

