Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0KNKNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 05:13:40 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59122 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab0KNKNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 05:13:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=K/sb3GMxhteaJ4D26ZhLTh3G5XVsttFxIo9fFBl9BNvFnTsColGM+7DjaQR0XMK/Jr
         u6NyTo6hv+UTbFkB1G4V9oUiGdBz5rG1rGp+DWjIA5Tt7dJ1oGoHkoInBJlS1BWG83D+
         QzsJGGrfyOTCsL6DY3k6hzI6xbyNupphmsihE=
MIME-Version: 1.0
In-Reply-To: <1289584840-18097-9-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-9-git-send-email-catalin.marinas@arm.com>
Date: Sun, 14 Nov 2010 10:13:38 +0000
X-Google-Sender-Auth: mG55dbDMm6GYVjpEMpXOS_f2FJg
Message-ID: <AANLkTinnJZwiiuX4747WSmrjm7j9JhG_CGugqnK1jWEF@mail.gmail.com>
Subject: Re: [PATCH v2 08/20] ARM: LPAE: MMU setup for the 3-level page table format
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2010 18:00, Catalin Marinas <catalin.marinas@arm.com> wrote:
> This patch adds the MMU initialisation for the LPAE page table format.
> The swapper_pg_dir size with LPAE is 5 rather than 4 pages. The
> __v7_setup function configures the TTBRx split based on the PAGE_OFFSET
> and sets the corresponding TTB control and MAIRx bits (similar to
> PRRR/NMRR for TEX remapping). The 36-bit mappings (supersections) and
> a few other memory types in mmu.c are conditionally compiled.
[...]
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -45,11 +46,20 @@
>  #error KERNEL_RAM_VADDR must start at 0xXXXX8000
>  #endif
>
> +#ifdef CONFIG_ARM_LPAE
> +       /* LPAE requires an additional page for the PGD */
> +#define PG_DIR_SIZE    0x5000
> +#define PTE_WORDS      3
> +#else
> +#define PG_DIR_SIZE    0x4000
> +#define PTE_WORDS      2
> +#endif

This should have been called PTE_ORDER, the PTE_WORDS naming is misleading.

-- 
Catalin
