Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0DTKHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:07:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61981 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0DTKHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V0ysOKYmUF1wmhMKaclaCWDiZudlzbkTxS2hgzlhlmNIz8nBhZyhcav/YD7YOfAhQs
         W4t/0aoUcLYJnWkSCLKPY0c7Ut7AKuVeanG61X9imWBJM3stHhHmgjrLBWcqvMqJklQ1
         uwML0qwWdVRIJ6luJUM6RxsSiU+mSLOXNJD58=
Date: Tue, 20 Apr 2010 18:10:56 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 4/5] uml: i386: Avoid redefinition of NR_syscalls
Message-ID: <20100420101056.GC5317@cr0.nay.redhat.com>
References: <cover.1271713955.git.jan.kiszka@web.de>
 <3e07ad1a38e88a22d7298deb88a8f3962b101998.1271713955.git.jan.kiszka@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e07ad1a38e88a22d7298deb88a8f3962b101998.1271713955.git.jan.kiszka@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 11:53:07PM +0200, Jan Kiszka wrote:
>The i386 subarch happens to pull in original NR_syscalls. Maybe we can
>make that work for all host arch, but for now just avoid the clash by
>using an all-upper-case name.
>

Where?


>Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>---
> arch/um/kernel/skas/syscall.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscall.c
>index 4e3b820..f5173e1 100644
>--- a/arch/um/kernel/skas/syscall.c
>+++ b/arch/um/kernel/skas/syscall.c
>@@ -10,7 +10,7 @@
> #include "sysdep/syscalls.h"
> 
> extern int syscall_table_size;
>-#define NR_syscalls (syscall_table_size / sizeof(void *))
>+#define NR_SYSCALLS (syscall_table_size / sizeof(void *))
> 
> void handle_syscall(struct uml_pt_regs *r)
> {
>@@ -30,7 +30,7 @@ void handle_syscall(struct uml_pt_regs *r)
> 	 * in case it's a compiler bug.
> 	 */
> 	syscall = UPT_SYSCALL_NR(r);
>-	if ((syscall >= NR_syscalls) || (syscall < 0))
>+	if ((syscall >= NR_SYSCALLS) || (syscall < 0))
> 		result = -ENOSYS;
> 	else result = EXECUTE_SYSCALL(syscall, regs);
> 
>-- 
>1.6.0.2
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
