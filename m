Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130Ab0KPJ6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:58:01 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41522 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933098Ab0KPJ57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:57:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OqheozLi8+VmrbFTHrl0OcNcvcwgG40mfLD6BCXT/cbRBzVT4ZuHOWOtZPIrfhYzzF
         Kfk0yARFZYPN4DNO/HaB0aSQJW3/OfTulp3V6yz/+L36UtStp3zwf/wWMgciJqWYnBlk
         yHjVGPl3gipwGQHW6Hj2wcaHiOVFCajaB1QuA=
MIME-Version: 1.0
In-Reply-To: <20101115183443.GE31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-7-git-send-email-catalin.marinas@arm.com>
	<20101115183443.GE31421@n2100.arm.linux.org.uk>
Date: Tue, 16 Nov 2010 09:57:57 +0000
X-Google-Sender-Auth: 7fOTRZeEucFznZpFD1hfQioddG4
Message-ID: <AANLkTi=aWxekxZ-b59JNOjLArygcxOv1o4HwRt4t_xKh@mail.gmail.com>
Subject: Re: [PATCH v2 06/20] ARM: LPAE: Introduce the 3-level page table
 format definitions
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2010 18:34, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Nov 12, 2010 at 06:00:26PM +0000, Catalin Marinas wrote:
>> +#define PMD_TYPE_MASK                (_AT(pmd_t, 3) << 0)
>> +#define PMD_TYPE_FAULT               (_AT(pmd_t, 0) << 0)
>> +#define PMD_TYPE_TABLE               (_AT(pmd_t, 3) << 0)
>> +#define PMD_TYPE_SECT                (_AT(pmd_t, 1) << 0)
>> +#define PMD_BIT4             (_AT(pmd_t, 0))
>> +#define PMD_DOMAIN(x)                (_AT(pmd_t, 0))
>
> It is really not correct to have these constants type'd as pmd_t.
> The idea behind pmd_t et.al. is to detect when normal arithmetic or
> logical operations are performed on page table entries when the
> accessors instead should be used.

OK, I can add pmdval_t (and pgdval_t) and use it for these definitions.

>> diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
>> index 6630620..a62f093 100644
>> --- a/arch/arm/mm/mm.h
>> +++ b/arch/arm/mm/mm.h
>> @@ -16,10 +16,10 @@ static inline pmd_t *pmd_off_k(unsigned long virt)
>>  }
>>
>>  struct mem_type {
>> -     unsigned int prot_pte;
>> -     unsigned int prot_l1;
>> -     unsigned int prot_sect;
>> -     unsigned int domain;
>> +     pgprot_t prot_pte;
>> +     pgprot_t prot_l1;
>> +     pgprot_t prot_sect;
>> +     pgprot_t domain;
>
> Again, this is wrong.  There's an accessor for pgprot_t typed data.  This
> causes code to violate it.

OK, I'll define pgprotval_t and accessors.

-- 
Catalin
