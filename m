Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1EEJ1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:27:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34225 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1EEJ1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IgGItS/ZA/DpJC1yOV3QpMFBdRorIh4FSZnSnSt7Dq9KQOaWXSAhZQipmey6ik7DKB
         gZjE58IbMzEK42QzTN+fVY/QkpKElqOH5o2mjR2xrUfSuzGZRnZPQyKWstpVr+s7hm8L
         tO5cGu2JLFF98ngvDRo3t90LmDTWs58X6bZDw=
MIME-Version: 1.0
In-Reply-To: <1304585518-9665-3-git-send-email-sanbai@taobao.com>
References: <1304585518-9665-1-git-send-email-sanbai@taobao.com>
	<1304585518-9665-3-git-send-email-sanbai@taobao.com>
Date: Thu, 5 May 2011 17:27:30 +0800
Message-ID: <BANLkTi=hmP_cC8pbPPVaV6q=USkHihg42g@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: change incorrect 'extern' keyword to 'static'
From: Yong Zhang <yong.zhang0@gmail.com>
To: Robin Dong <hao.bigrat@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 4:51 PM, Robin Dong <hao.bigrat@gmail.com> wrote:
> Change function memblock_memory_can_coalesce from 'extern' to 'static' to
> match the memblock_* series function.
>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  mm/memblock.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 400dc62..9570c43 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -292,7 +292,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type)
>        return 0;
>  }
>
> -extern int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
> +static int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,

I guess you will get build error as
"error: static declaration of ‘***’ follows non-static declaration".

No?

Thanks,
Yong

>                                          phys_addr_t addr2, phys_addr_t size2)
>  {
>        return 1;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
