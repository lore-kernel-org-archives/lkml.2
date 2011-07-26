Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1GZVGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:06:43 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47465 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1GZVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:06:41 -0400
MIME-Version: 1.0
In-Reply-To: <1310462166-31469-14-git-send-email-tj@kernel.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
	<1310462166-31469-14-git-send-email-tj@kernel.org>
Date: Tue, 26 Jul 2011 14:06:40 -0700
Message-ID: <CAE9FiQU3+ceB+uDY6q2WyBvaTsJr-v9sRF7DDr_omNMf49o3Kg@mail.gmail.com>
Subject: Re: [PATCH 13/13] memblock, x86: Replace memblock_x86_reserve/free_range()
 with generic ones
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 2:16 AM, Tejun Heo <tj@kernel.org> wrote:
> Other than sanity check and debug message, the x86 specific version of
> memblock reserve/free functions are simple wrappers around the generic
> versions - memblock_reserve/free().
>
> This patch adds debug messages with caller identification to the
> generic versions and replaces x86 specific ones and kills them.
> arch/x86/include/asm/memblock.h and arch/x86/mm/memblock.c are empty
> after this change and removed.
>
...
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 5636308..6e76c19 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -94,7 +94,7 @@ static u32 __init allocate_aperture(void)
>                                addr, aper_size>>10);
>                return 0;
>        }
> -       memblock_x86_reserve_range(addr, addr + aper_size, "aperture64");
> +       memblock_reserve(addr, aper_size);

Wonder if we have a new function like

__memblock_reserve(addr, size, name)

in mm/memblock.c

so could keep string for debug purpose instead of using _RET_IP_.

with that, we can figure out what is in exact reserved position with boot log.

Thanks

Yinghai
