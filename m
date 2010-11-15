Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab0KOSa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:30:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60090 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479Ab0KOSa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:30:57 -0500
Date: Mon, 15 Nov 2010 18:30:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/20] ARM: LPAE: Introduce L_PTE_NOEXEC and
	L_PTE_NOWRITE
Message-ID: <20101115183014.GD31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-6-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289584840-18097-6-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:00:25PM +0000, Catalin Marinas wrote:
> The LPAE page table format needs to explicitly disable execution or
> write permissions on a page by setting the corresponding bits (similar
> to the classic page table format with Access Flag enabled). This patch
> introduces null definitions for the 2-level format and the actual noexec
> and nowrite bits for the LPAE format. It also changes several PTE
> maintenance macros and masks.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm/include/asm/pgtable-2level.h |    2 +
>  arch/arm/include/asm/pgtable.h        |   44 +++++++++++++++++++++------------
>  arch/arm/mm/mmu.c                     |    6 ++--
>  3 files changed, 33 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
> index 36bdef7..4e21166 100644
> --- a/arch/arm/include/asm/pgtable-2level.h
> +++ b/arch/arm/include/asm/pgtable-2level.h
> @@ -128,6 +128,8 @@
>  #define L_PTE_USER		(1 << 8)
>  #define L_PTE_EXEC		(1 << 9)
>  #define L_PTE_SHARED		(1 << 10)	/* shared(v6), coherent(xsc3) */
> +#define L_PTE_NOEXEC		(0)
> +#define L_PTE_NOWRITE		(0)

Let's not make this more complicated than it has to be.  If we need the
inverse of WRITE and EXEC, then that's what we should change everyone to,
not invent a new system to work along side the old system.

We're already inverting the write bit for the vast majority of processors,
and exec has always been inverted by the ARMv6 and v7 code.
