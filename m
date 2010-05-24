Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0EXOhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:37:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57747 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab0EXOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:37:06 -0400
Date: Mon, 24 May 2010 07:36:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, d.hatayama@jp.fujitsu.com
Subject: Re: [PATCH]: Fix userspace warnings in elfcore.h
Message-Id: <20100524073624.b2b1b302.randy.dunlap@oracle.com>
In-Reply-To: <20100524134942.5765.4089.sendpatchset@prarit.bos.redhat.com>
References: <20100524134942.5765.4089.sendpatchset@prarit.bos.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BFA8F05.01F3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 May 2010 09:54:44 -0400 Prarit Bhargava wrote:

> Fixes compile warning:
> 
> /home/rhel6/usr/include/linux/elfcore.h:104: userspace cannot call function or variable defined in the kernel
> /home/rhel6/usr/include/linux/elfcore.h:105: userspace cannot call function or variable defined in the kernel
> /home/rhel6/usr/include/linux/elfcore.h:108: userspace cannot call function or variable defined in the kernel
> /home/rhel6/usr/include/linux/elfcore.h:110: userspace cannot call function or variable defined in the kernel
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Patch was merged last Saturyday:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2faa4cf76e7d229016240b79b50a43d81f458323

> diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
> index e687bc3..26f7486 100644
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
> @@ -167,5 +165,6 @@ elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
>  extern int
>  elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
>  extern size_t elf_core_extra_data_size(void);
> +#endif /* __KERNEL__ */
>  
>  #endif /* _LINUX_ELFCORE_H */
> --



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
