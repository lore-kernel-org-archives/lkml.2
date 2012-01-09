Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2AIA73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:59:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:39649 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab2AIA72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:59:28 -0500
Message-ID: <4F0A3C08.1020801@windriver.com>
Date: Mon, 9 Jan 2012 08:59:52 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kmemleak/module: only scan the existed data section
References: <1325059891-20540-1-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1325059891-20540-1-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tiejun Chen wrote:
> We should only scan the sections containing data and it's size is not
> zero as well.

Catalin,

Could you take a look at this?

Thanks
Tiejun

> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
> ---
>  kernel/module.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 12cfa2b..0b93c30 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2045,6 +2045,8 @@ static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
>  		if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
>  		    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
>  			continue;
> +		if (sechdrs[i].sh_size == 0)
> +			continue;
>  
>  		kmemleak_scan_area((void *)sechdrs[i].sh_addr,
>  				   sechdrs[i].sh_size, GFP_KERNEL);

