Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0JKG5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 02:57:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61828 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0JKG5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 02:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fDIQitEtANeeqDpC8Hui1TksJ+QKI9FX82TNeGkdwtFT74hol2F5EGuVuQQ62uLDMX
         XIH/pEYyNJsoKufej6fnAN6P3SGa/xKtUWoQUN6fS9eVUqxccb02wtqetO5YEQBKU1EF
         ebs93NYZqM/apSdfGsz5rsrpOOKhtrej26eGI=
MIME-Version: 1.0
In-Reply-To: <87aamm3si1.fsf@basil.nowhere.org>
References: <4CB1EBA2.8090409@gmail.com>
	<87aamm3si1.fsf@basil.nowhere.org>
Date: Mon, 11 Oct 2010 08:57:45 +0200
Message-ID: <AANLkTimGC_0W-=nSeoti6DLh5XNxvGwU6jqoGUkuOKPx@mail.gmail.com>
Subject: Re: [PATCH 14(16] pramfs: memory protection
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/10 Andi Kleen <andi@firstfloor.org>:
> Marco Stornelli <marco.stornelli@gmail.com> writes:
>> +
>> +     do {
>> +             pgd = pgd_offset(&init_mm, address);
>> +             if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
>> +                     goto out;
>> +
>> +             pud = pud_offset(pgd, address);
>> +             if (pud_none(*pud) || unlikely(pud_bad(*pud)))
>> +                     goto out;
>> +
>> +             pmd = pmd_offset(pud, address);
>> +             if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
>> +                     goto out;
>> +
>> +             ptep = pte_offset_kernel(pmd, addr);
>> +             pte = *ptep;
>> +             if (pte_present(pte)) {
>
> This won't work at all on x86 because you don't handle large
> pages.

On x86 works because I tested. Maybe there's a particular
configuration with large pages. Sincerly I'm only an "user", so if
you/Linus or others want to change it or rewrite it, for me it's ok.
The pte manipulation are a bit out of scope for a fs, so I let the
things to the mm experts.
