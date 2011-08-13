Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1HMOOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:14:32 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:44255 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1HMOOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <1313240299-24712-1-git-send-email-anarsoul@gmail.com>
References: <201108131556.27301.anarsoul@gmail.com>
	<1313240299-24712-1-git-send-email-anarsoul@gmail.com>
Date: Sat, 13 Aug 2011 15:14:30 +0100
X-Google-Sender-Auth: _0RiwHWPOnrVBAj4X9pLZwICCuw
Message-ID: <CAHkRjk4p1kqwKGiW_XRFU0aap98QkvRGRs0hwsBR4CcfM5RKqA@mail.gmail.com>
Subject: Re: [PATCH] Fix non-LPAE boot regression.
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 August 2011, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> It was introduced by  407f8b4cb07cbc5c1c7cc386f231224e2524ccea
> ARM: LPAE: MMU setup for the 3-level page table format
>
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> ---
>  arch/arm/kernel/head.S |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 0bdafc4..5add5f5 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -206,7 +206,7 @@ __create_page_tables:
>  1:     orr     r3, r7, r5, lsl #SECTION_SHIFT  @ flags + kernel base
>         str     r3, [r4, r5, lsl #PMD_ORDER]    @ identity mapping
>         cmp     r5, r6
> -       addlo   r5, r5, #SECTION_SHIFT >> 20    @ next section
> +       addlo   r5, r5, #1                      @ next section
>         blo     1b

Thanks for this. The original code was indeed broken but I think the
fix should be to use SECTION_SIZE instead of SHIFT. I'll have a look
on Monday.

-- 
Catalin
