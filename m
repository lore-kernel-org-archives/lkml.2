Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0KNOJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 09:09:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37566 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab0KNOJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 09:09:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fDMhZ7ThemzqFOY0II06gWwjwpn3CqD9F1pbqWFT5kR8ROSafU0WdnZ/TBjN5iLy/H
         9K20BldqeQ/QhttGBfsW7QMSwqaDVkKyR48NOITOaw7giOgLYOj1Empzc9OSoa6DCz4S
         TiPlLYOg1cAulOjAzH6F6xq1cTo04jyu7NbQI=
MIME-Version: 1.0
In-Reply-To: <20101114131941.GA10871@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-4-git-send-email-catalin.marinas@arm.com>
	<20101114131941.GA10871@n2100.arm.linux.org.uk>
Date: Sun, 14 Nov 2010 14:09:48 +0000
X-Google-Sender-Auth: c9-ui_0SAsDR6j5H-ZmLbju3tWE
Message-ID: <AANLkTimtSUNrO0wZBfyJJ+OJQCDLkXSOiUuzOD+ubv6O@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long for
 32-bit ptes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 14, 2010, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Nov 12, 2010 at 06:00:23PM +0000, Catalin Marinas wrote:
>> From: Will Deacon <will.deacon@arm.com>
>>
>> When using 2-level paging, pte_t and pmd_t are typedefs for
>> unsigned long but phys_addr_t is a typedef for u32.
>>
>> This patch uses u32 for the page table entry types when
>> phys_addr_t is not 64-bit, allowing the same conversion
>> specifier to be used for physical addresses and page table
>> entries regardless of LPAE.
>
> However, code which prints the value of page table entries assumes that
> they are unsigned long, and places where we store the raw pte value also
> uses 'unsigned long'.
>
> If we're going to make this change, we need to change more places than
> this patch covers.  grep for pte_val to help find those places.

Patch 19/20 introduces a common macro for formatting but we should
probably order the patches a bit to avoid problems if anyone is
bisecting  in the middle of the series.


-- 
Catalin
