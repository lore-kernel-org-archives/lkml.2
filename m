Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2HUQDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:03:04 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:40587 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab2HUQDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:03:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,802,1336348800"; 
   d="scan'208";a="14110784"
Message-ID: <5033AE12.20609@citrix.com>
Date: Tue, 21 Aug 2012 16:49:38 +0100
From: Attilio Rao <attilio.rao@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 2/5] XEN: Remove the base argument from x86_init.paging.pagetable_setup_start
 PVOPS
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com> <1345511646-12427-3-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208211740340.2856@ionos>
In-Reply-To: <alpine.LFD.2.02.1208211740340.2856@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/12 16:41, Thomas Gleixner wrote:
> On Tue, 21 Aug 2012, Attilio Rao wrote:
>    
>> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
>> index 1019156..7999cef 100644
>> --- a/arch/x86/mm/init_32.c
>> +++ b/arch/x86/mm/init_32.c
>> @@ -445,14 +445,17 @@ static inline void permanent_kmaps_init(pgd_t *pgd_base)
>>   }
>>   #endif /* CONFIG_HIGHMEM */
>>
>> -void __init native_pagetable_setup_start(pgd_t *base)
>> +void __init native_pagetable_setup_start(void)
>>   {
>>   	unsigned long pfn, va;
>> +	pgd_t *base;
>>   	pgd_t *pgd;
>>      
> 	pgd_t *pgd, *base = swapper_pg_dir;
>
> Please. No need to add 5 lines just for this.
>
>    

I honestly thought it was cleaner -- what is exactly your preferred 
choice? Just use swapper_pg_dir directly in the 2 places needing it?

Attilio
