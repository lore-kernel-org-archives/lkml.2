Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0L2Xap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:30:45 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35566 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab0L2Xam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:30:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gbMZI+2wHyTfnOzbVy4ZjNU+DCkUf3igVwgvpegs/QXXzR6C9dY8MQYAGV17AucPCS
         5VJ8qRN4ppkHFiS5tsn9zh+eMsZEgac8hbpYdIfb+cspP8V9OhN3XPNGJF2fd/8Pz4zw
         AG1/hnxh0g87ZTdEfoCQ6ogjbFduIVzhch2ak=
MIME-Version: 1.0
In-Reply-To: <4D1BBEB7.3010901@zytor.com>
References: <4D0C072D.1040201@kernel.org>
	<4D19320B.7030007@kernel.org>
	<4D1933BA.8000508@kernel.org>
	<4D1BBEB7.3010901@zytor.com>
Date: Wed, 29 Dec 2010 15:30:41 -0800
X-Google-Sender-Auth: u1sCk0BD4ai7jAEhpwApzN_pQFA
Message-ID: <AANLkTineB4n7mjotECPK_VsHvP9xGt=SMJ-GSC_6nZAZ@mail.gmail.com>
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

On Wed, Dec 29, 2010 at 3:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/27/2010 04:47 PM, Yinghai Lu wrote:
>>
>> Move it into head file. to prepare use it in other files.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/include/asm/page_types.h |    5 +++++
>>  arch/x86/kernel/setup.c           |    9 ---------
>>  2 files changed, 5 insertions(+), 9 deletions(-)
>>
>> Index: linux-2.6/arch/x86/include/asm/page_types.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/page_types.h
>> +++ linux-2.6/arch/x86/include/asm/page_types.h
>> @@ -45,6 +45,11 @@ extern int devmem_is_allowed(unsigned lo
>>  extern unsigned long max_low_pfn_mapped;
>>  extern unsigned long max_pfn_mapped;
>>
>> +static inline u64 get_max_mapped(void)
>> +{
>> +     return (u64)max_pfn_mapped<<PAGE_SHIFT;
>> +}
>> +
>>  extern unsigned long init_memory_mapping(unsigned long start,
>>                                        unsigned long end);
>>
>
> This is broken.  <asm/page_types.h> doesn't include <linux/types.h>
> which is required for the u64 type -- a simple compile test would have
> told you this.

compile test fail on 32 bit?

> Furthermore, it seems to me that it would make more
> sense for this to be phys_addr_t instead of u64; would you agree?

yes.
