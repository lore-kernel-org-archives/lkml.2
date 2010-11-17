Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842Ab0KQP2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:28:38 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54965 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab0KQP2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:28:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n0OT3+ZlVw2njLVGhaGy2danYuQRIIYeW39lfC1BkKtP6RpN5B0A37OkbsM2uLxaHk
         /dLd2fuuyyNvxv6db4pLaCFfvSLht56eeAhSYaSXPF7iwqgqrGFNVsyYYuiWpr2waNAe
         8TFWWVkN1hYwNfU1P/5WXA6nYH+DkIG0UkQk8=
MIME-Version: 1.0
In-Reply-To: <201011171218.13910.arnd@arndb.de>
References: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com>
	<20101116193335.GD21926@n2100.arm.linux.org.uk>
	<AANLkTinDGk2HPg7py9nzsqmM3_AbSG_GJJYwsiMr+wQL@mail.gmail.com>
	<201011171218.13910.arnd@arndb.de>
Date: Wed, 17 Nov 2010 15:28:33 +0000
X-Google-Sender-Auth: JWYcJiKKLdiSzFhpp8LacggPUv0
Message-ID: <AANLkTik39iqXsLJiJ7cWwweO2VBoJ0Y4ymwKqx7X5ziA@mail.gmail.com>
Subject: Re: [PATCH v3 15/20] ARM: LPAE: use phys_addr_t instead of unsigned
 long for physical addresses
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 November 2010 11:18, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 17 November 2010, Catalin Marinas wrote:
>> >
>> > It may make sense to mark it const volatile, as that's the most
>> > permissive set of attributes possible (iow, it'll accept any pointer
>> > without warning.)  However, might be an idea to check what other
>> > arches do.
>>
>> The majority of architectures use volatile and a few add both const
>> and volatile.
>>
>> I usually use the generic headers as reference for function prototypes
>> and that's just using volatile without a const (cc'ing Arnd for any
>> view on this).
>
> const volatile sounds right here, I can also change the generic header
> if we agree to do the same in arm.

That's what I plan to add, though it may be better to push as a
separate patch to fix compiler warnings now. I don't know when the
LPAE patches would go in.

--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -189,7 +189,7 @@
  * translation for translating DMA addresses.  Use the driver
  * DMA support - see dma-mapping.h.
  */
-static inline phys_addr_t virt_to_phys(void *x)
+static inline phys_addr_t virt_to_phys(const volatile void *x)
 {
 	return __virt_to_phys((unsigned long)(x));
 }

-- 
Catalin
