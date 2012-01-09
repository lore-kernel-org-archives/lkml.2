Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2AIMFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 07:05:24 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59849 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2AIMFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 07:05:22 -0500
MIME-Version: 1.0
In-Reply-To: <1325059891-20540-1-git-send-email-tiejun.chen@windriver.com>
References: <1325059891-20540-1-git-send-email-tiejun.chen@windriver.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 9 Jan 2012 12:05:01 +0000
X-Google-Sender-Auth: J35c9yiKRYhtB3I5RDKmhvz7sjs
Message-ID: <CAHkRjk5fuubEQaq2CD1cGE=W+Lf6svE6fN8KyDrY6=i3-=b_RA@mail.gmail.com>
Subject: Re: [PATCH 1/1] kmemleak/module: only scan the existed data section
To: Tiejun Chen <tiejun.chen@windriver.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 December 2011 08:11, Tiejun Chen <tiejun.chen@windriver.com> wrote:
> We should only scan the sections containing data and it's size is not
> zero as well.
>
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  kernel/module.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 12cfa2b..0b93c30 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2045,6 +2045,8 @@ static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
>                if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
>                    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
>                        continue;
> +               if (sechdrs[i].sh_size == 0)
> +                       continue;
>
>                kmemleak_scan_area((void *)sechdrs[i].sh_addr,
>                                   sechdrs[i].sh_size, GFP_KERNEL);

I would rather move this check to kmemleak.c. But why would it be
needed? Performance? A zero-size area shouldn't be scanned anyway.

-- 
Catalin
