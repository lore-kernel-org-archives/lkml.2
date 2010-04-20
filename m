Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0DTKGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:06:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49540 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab0DTKGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:06:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i2shMn5k0uQdNIUWEHExeIb2GgY0sgyFuQn12uivvJZCUo8DKEpaI3h96+bShfXlak
         LfwrsTVyg6jqVYMT70bdxtwsvRosyoQ0tOj97J/eR+wJHnKW3iYyF0J8hZPEkQSNT/IS
         /v5MoUZyTY/cDLN/pegC91jS+eb5T3o3EpPgc=
Date: Tue, 20 Apr 2010 18:09:49 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 3/5] uml: Fix warning due to missing task_struct
 declaration
Message-ID: <20100420100949.GB5317@cr0.nay.redhat.com>
References: <cover.1271713955.git.jan.kiszka@web.de>
 <1d97cd7761a1eae73923b1adda4c6915a0647bb3.1271713955.git.jan.kiszka@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d97cd7761a1eae73923b1adda4c6915a0647bb3.1271713955.git.jan.kiszka@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 11:53:06PM +0200, Jan Kiszka wrote:
>We can't pull in linux/sched.h, so just declare the struct.
>

Did you meet any build error? If yes, please include it.

Thanks.



>Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>---
> arch/um/sys-i386/asm/elf.h   |    2 ++
> arch/um/sys-x86_64/asm/elf.h |    2 ++
> 2 files changed, 4 insertions(+), 0 deletions(-)
>
>diff --git a/arch/um/sys-i386/asm/elf.h b/arch/um/sys-i386/asm/elf.h
>index e64cd41..a979a22 100644
>--- a/arch/um/sys-i386/asm/elf.h
>+++ b/arch/um/sys-i386/asm/elf.h
>@@ -75,6 +75,8 @@ typedef struct user_i387_struct elf_fpregset_t;
> 	pr_reg[16] = PT_REGS_SS(regs);		\
> } while (0);
> 
>+struct task_struct;
>+
> extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
> 
> #define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
>diff --git a/arch/um/sys-x86_64/asm/elf.h b/arch/um/sys-x86_64/asm/elf.h
>index 49655c8..d760967 100644
>--- a/arch/um/sys-x86_64/asm/elf.h
>+++ b/arch/um/sys-x86_64/asm/elf.h
>@@ -95,6 +95,8 @@ typedef struct user_i387_struct elf_fpregset_t;
> 	(pr_reg)[25] = 0;					\
> 	(pr_reg)[26] = 0;
> 
>+struct task_struct;
>+
> extern int elf_core_copy_fpregs(struct task_struct *t, elf_fpregset_t *fpu);
> 
> #define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
>-- 
>1.6.0.2
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
