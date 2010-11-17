Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab0KQPk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:40:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50184 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574Ab0KQPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:40:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 15/20] ARM: LPAE: use phys_addr_t instead of unsigned long for physical addresses
Date: Wed, 17 Nov 2010 16:40:47 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com> <201011171218.13910.arnd@arndb.de> <AANLkTik39iqXsLJiJ7cWwweO2VBoJ0Y4ymwKqx7X5ziA@mail.gmail.com>
In-Reply-To: <AANLkTik39iqXsLJiJ7cWwweO2VBoJ0Y4ymwKqx7X5ziA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011171640.47639.arnd@arndb.de>
X-Provags-ID: V02:K0:IL7uZShh4VueBI1A0KMdkUbSnjDVkuz0bkVC7XtkJPj
 b6ojmJfFWqot5RddNGh8nbtJ1XYKrzBxRLruC8Uubnf7zPxFB5
 qbR0obs8yPWHf8uyxZsBbuH8wHlZfGH6jSOyq+QnX3E3/0cUyj
 vtT6NsG4SisdZ+Qssr2C7uBT1j1qymIHP9hXB3KCTE9iWWigRm
 uRPS4ysusEnFEreJFdCwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 November 2010, Catalin Marinas wrote:
> That's what I plan to add, though it may be better to push as a
> separate patch to fix compiler warnings now. I don't know when the
> LPAE patches would go in.
> 
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -189,7 +189,7 @@
>   * translation for translating DMA addresses.  Use the driver
>   * DMA support - see dma-mapping.h.
>   */
> -static inline phys_addr_t virt_to_phys(void *x)
> +static inline phys_addr_t virt_to_phys(const volatile void *x)
>  {
>         return __virt_to_phys((unsigned long)(x));
>  }

The only impact of this patch is reducing compiler warnings, it should
not add any. Since the patch is correct and independent of the other
changes, it still sounds like a good idea to push it into -next now.

	Arnd
