Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab1FMJTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:19:48 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:59490 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1FMJTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:19:46 -0400
Subject: Re: [PATCH] unicore32, exec: remove redundant set_fs(USER_DS)
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <1307711463-17752-1-git-send-email-minipli@googlemail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
	 <1307711463-17752-1-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Mon, 13 Jun 2011 17:19:40 +0800
Message-ID: <1307956780.1878.13.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 15:11 +0200, Mathias Krause wrote:
> The address limit is already set in flush_old_exec() so this
> set_fs(USER_DS) is redundant.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>  arch/unicore32/include/asm/processor.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/unicore32/include/asm/processor.h b/arch/unicore32/include/asm/processor.h
> index e11cb07..f0d780a 100644
> --- a/arch/unicore32/include/asm/processor.h
> +++ b/arch/unicore32/include/asm/processor.h
> @@ -53,7 +53,6 @@ struct thread_struct {
>  #define start_thread(regs, pc, sp)					\
>  ({									\
>  	unsigned long *stack = (unsigned long *)sp;			\
> -	set_fs(USER_DS);						\
>  	memset(regs->uregs, 0, sizeof(regs->uregs));			\
>  	regs->UCreg_asr = USER_MODE;					\
>  	regs->UCreg_pc = pc & ~1;	/* pc */                        \

Hi Mathias,
I searched for the code in flush_old_exec(), but I can't find the code
you mentioned. Could you make it more clear?
And, if all fs codes (not only elf and aout) have the similar
implementations, perhaps all arch-specific codes should be manipulated
in the meanwhile.

Also Cc: Arnd Bergmann <arnd@arndb.de>

Thanks & Regards.

Guan Xuetao

