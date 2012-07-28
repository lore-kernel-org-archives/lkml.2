Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2G1JJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 05:09:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39014 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2G1JJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 05:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <1341203670-17544-1-git-send-email-roy.qing.li@gmail.com>
References: <1341203670-17544-1-git-send-email-roy.qing.li@gmail.com>
Date: Sat, 28 Jul 2012 17:08:59 +0800
Message-ID: <CAJFZqHxBE6wc2hJd=mKfx9D59S73qxJZFvbfqgmLkWZvtR7f_A@mail.gmail.com>
Subject: Re: [PATCH] MIPS: fix tc_id calculation
From: RongQing Li <roy.qing.li@gmail.com>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any advice

2012/7/2  <roy.qing.li@gmail.com>:
> From: RongQing.Li <roy.qing.li@gmail.com>
>
> Now the tc_id is:
>   (read_c0_tcbind() >> TCBIND_CURTC_SHIFT) & TCBIND_CURTC;
> After substitute macro:
>   (read_c0_tcbind() >> 21) & ((0xff) << 21)
> It should be:
>   (read_c0_tcbind() & ((0xff)<< 21)) >>21
>
> Signed-off-by: RongQing.Li <roy.qing.li@gmail.com>
> ---
>  arch/mips/kernel/smp-cmp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
> index e7e03ec..afc379c 100644
> --- a/arch/mips/kernel/smp-cmp.c
> +++ b/arch/mips/kernel/smp-cmp.c
> @@ -102,7 +102,7 @@ static void cmp_init_secondary(void)
>         c->vpe_id = (read_c0_tcbind() >> TCBIND_CURVPE_SHIFT) & TCBIND_CURVPE;
>  #endif
>  #ifdef CONFIG_MIPS_MT_SMTC
> -       c->tc_id  = (read_c0_tcbind() >> TCBIND_CURTC_SHIFT) & TCBIND_CURTC;
> +       c->tc_id  = (read_c0_tcbind() & TCBIND_CURTC) >> TCBIND_CURTC_SHIFT;
>  #endif
>  }
>
> --
> 1.7.1
>
