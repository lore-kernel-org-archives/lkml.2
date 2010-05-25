Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab0EYWiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:38:00 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35325 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab0EYWh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:37:58 -0400
From: "Camuso, Tony" <Tony.Camuso@hp.com>
To: Prarit Bhargava <prarit@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "Altobelli, David" <david.altobelli@hp.com>
Date: Tue, 25 May 2010 22:35:58 +0000
Subject: RE: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup
Thread-Topic: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup
Thread-Index: Acr8V6YZ1+OjuNAFRMCTa4oNqB2qUAAArsGQ
Message-ID: <B9407FD6893A644D9D6B72C30268E7A938681FF444@GVW0538EXC.americas.hpqcorp.net>
References: <20100522004615.25451.83108.sendpatchset@prarit.bos.redhat.com>
 <20100525144937.e0726ec2.akpm@linux-foundation.org>
 <4BFC4ABC.9010209@redhat.com>
In-Reply-To: <4BFC4ABC.9010209@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess it would have helped if I asked David what the code did, first. 
":|



-----Original Message-----
From: Prarit Bhargava [mailto:prarit@redhat.com] 
Sent: Tuesday, May 25, 2010 6:10 PM
To: Andrew Morton
Cc: linux-kernel@vger.kernel.org; stable@kernel.org; Altobelli, David; Camuso, Tony
Subject: Re: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup



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

