Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0EVDkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 23:40:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44518 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0EVDkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 23:40:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] linux/elfcore.h: hide kernel functions
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100522031650.D564B49A4D@magilla.sf.frob.com>
References: <20100522031650.D564B49A4D@magilla.sf.frob.com>
Message-Id: <20100522123923.1E83.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat, 22 May 2010 12:40:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The declarations for elf_core_extra_phdrs() et al got added on the
> wrong side of #ifdef __KERNEL__ in linux/elfcore.h so they leak into
> the user header copy and we get a warning at build time about it.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Ah, good. this one kill annoying warnings.
Thanks.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
>  include/linux/elfcore.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
> index e687bc3..394a3e0 100644
> --- a/include/linux/elfcore.h
> +++ b/include/linux/elfcore.h
> @@ -150,8 +150,6 @@ static inline int elf_core_copy_task_xfpregs(struct task_struct *t, elf_fpxregse
>  }
>  #endif
>  
> -#endif /* __KERNEL__ */
> -
>  /*
>   * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
>   * extra segments containing the gate DSO contents.  Dumping its
> @@ -168,4 +166,6 @@ extern int
>  elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
>  extern size_t elf_core_extra_data_size(void);
>  
> +#endif /* __KERNEL__ */
> +
>  #endif /* _LINUX_ELFCORE_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



