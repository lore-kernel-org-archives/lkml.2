Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061Ab0KPJOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:14:55 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33707 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab0KPJOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:14:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cbzJjpMukUw968HaxT2ZLmQkO8nLvLTIU+l94H6vLrUs8o6Nihn0GVseR9fkOfgnkK
         SfK3FQXohYsLa4W2vSy1HeYi0R/cbO0Ju+g6y60FutriYYngls0f/Mh8nPRZBAGzG5JA
         19bfxkelVALs1oKQ5is83F0dkHD5pcUfkoiDE=
MIME-Version: 1.0
In-Reply-To: <20101115233129.GG31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-3-git-send-email-catalin.marinas@arm.com>
	<20101115233129.GG31421@n2100.arm.linux.org.uk>
Date: Tue, 16 Nov 2010 09:14:52 +0000
X-Google-Sender-Auth: sAzOsx_RcinH3VfWX5CEMwY1VC4
Message-ID: <AANLkTikrz+yM6idm-aij10vsKZMVSOBfZSdeEJbDRwiC@mail.gmail.com>
Subject: Re: [PATCH v2 02/20] ARM: LPAE: Factor out 2-level page table
 definitions into separate files
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2010 23:31, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Nov 12, 2010 at 06:00:22PM +0000, Catalin Marinas wrote:
>> This patch moves page table definitions from asm/page.h, asm/pgtable.h
>> and asm/ptgable-hwdef.h into corresponding *-2level* files.
>
> This also introduces pteval_t.  It would be useful to have the
> introduction of pteval_t as a separate patch, which not only
> introduces the typedef, but also makes use of it.

I can do this. I missed this while splitting my initial big diff.

>> +#ifndef _ASM_PGTABLE_2LEVEL_TYPES_H
>> +#define _ASM_PGTABLE_2LEVEL_TYPES_H
>> +
>> +#undef STRICT_MM_TYPECHECKS
>> +
>> +typedef unsigned long pteval_t;
>> +
>> +#ifdef STRICT_MM_TYPECHECKS
>> +/*
>> + * These are used to make use of C type-checking..
>> + */
>> +typedef struct { unsigned long pte; } pte_t;
>
> This should become:
>
> typedef struct { pteval_t pte; } pte_t;
>
> L_PTE_* can then be declared using linux/const.h stuff to typedef them
> to pteval_t.

I already do this for LPAE but can be done for the 2-level definitions
for consistency.

BTW, do you think it's worth adding STRICT_MM_TYPECHECKS for LPAE as
well? It would probably spot some issues.

> shared_pte_mask also needs to be pteval_t.

That's done in the 3rd version of the series.

> As far as the __p*_error() functions, these should probably be passed
> the pte/pmd/pgd value itself, rather than first passing them through
> __pte_val() et.al.
>
> Of couse, I now have patches for this and my other points... will sort
> them out into a series in the next few days.

Thanks.

-- 
Catalin
