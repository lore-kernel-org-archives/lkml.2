Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2LLKJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:09:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41000 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2LLKJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:09:46 -0500
Message-ID: <50C85807.2000609@ti.com>
Date: Wed, 12 Dec 2012 11:10:15 +0100
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
CC: <linux-kernel@vger.kernel.org>, <r.sricharan@ti.com>,
        <rmk+kernel@arm.linux.org.uk>,
        moderated list:
	ARM PORT <linux-arm-kernel@lists.infradead.org>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH] ARM: decompressor: Flush tlb before swiching domain 0
 to client mode
References: <1355276466-18295-1-git-send-email-arve@android.com>
In-Reply-To: <1355276466-18295-1-git-send-email-arve@android.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2012 02:41 AM, Arve Hjønnevåg wrote:
> If the bootloader used a page table that is incompatible with domain 0
> in client mode, then swithing domain 0 to client mode causes a fault
> if we don't flush the tlb after updating the page table pointer.
>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> ---
>   arch/arm/boot/compressed/head.S |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 90275f0..9c8034c 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -704,6 +704,7 @@ __armv7_mmu_cache_on:
>   		bic     r6, r6, #1 << 31        @ 32-bit translation system
>   		bic     r6, r6, #3 << 0         @ use only ttbr0
>   		mcrne	p15, 0, r3, c2, c0, 0	@ load page table pointer
> +		mcrne	p15, 0, r0, c8, c7, 0	@ flush I,D TLBs
>   		mcrne	p15, 0, r1, c3, c0, 0	@ load domain access control
>   		mcrne   p15, 0, r6, c2, c0, 2   @ load ttb control
>   #endif
>
The TLB's are already flushed few lines above so above patching
shouldn't help if it was really dirty TLB entry issue. I suspect that
your boot-loader clean-up [1] function may not be taking care of
flushing caches which could potetially lead to the issue.

Have you checked that ?

Regards
Santosh

[1] http://www.arm.linux.org.uk/developer/noboot-checklist/
