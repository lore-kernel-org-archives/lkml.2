Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0L2XhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:37:19 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54860 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0L2XhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:37:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kBs/R2hglCe+UU1wUSxpJfs6PCCxHBad2ktxo6mrbWKjOap/AFJAHQZVh1oD2uxk0T
         lxLpX9puYbKVgi2867lD1XcA1zc0opbEfDns4xak0XdujV8NXpE1w/0wGBtG0DMvu+Cv
         S7mIOtHuFXTa4t1hmg3inYKDbSm8iUugg1D/Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTineB4n7mjotECPK_VsHvP9xGt=SMJ-GSC_6nZAZ@mail.gmail.com>
References: <4D0C072D.1040201@kernel.org>
	<4D19320B.7030007@kernel.org>
	<4D1933BA.8000508@kernel.org>
	<4D1BBEB7.3010901@zytor.com>
	<AANLkTineB4n7mjotECPK_VsHvP9xGt=SMJ-GSC_6nZAZ@mail.gmail.com>
Date: Wed, 29 Dec 2010 15:37:16 -0800
X-Google-Sender-Auth: uPGGXjBf2wf73OcApEJnstqu1TE
Message-ID: <AANLkTi=NU1UM3N6bbPSqqS+7UbvTY6YDNyn2s4tKURMY@mail.gmail.com>
Subject: Re: [PATCH 1/6] x86: Change get_max_mapped() to inline
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 3:30 PM, Yinghai Lu <yinghai@kernel.org> wrote:

>>> Index: linux-2.6/arch/x86/include/asm/page_types.h
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/include/asm/page_types.h
>>> +++ linux-2.6/arch/x86/include/asm/page_types.h
>>> @@ -45,6 +45,11 @@ extern int devmem_is_allowed(unsigned lo
>>>  extern unsigned long max_low_pfn_mapped;
>>>  extern unsigned long max_pfn_mapped;
>>>
>>> +static inline u64 get_max_mapped(void)
>>> +{
>>> +     return (u64)max_pfn_mapped<<PAGE_SHIFT;
>>> +}
>>> +
>>>  extern unsigned long init_memory_mapping(unsigned long start,
>>>                                        unsigned long end);
>>>
>>
>
>> Furthermore, it seems to me that it would make more
>> sense for this to be phys_addr_t instead of u64; would you agree?
>
> yes.

or could just use unsigned long instead.

on 32bit it will be under 4g
on 64bit unsigned long  is 64bit already.

Thanks

Yinghai
