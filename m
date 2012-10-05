Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2JEHf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:35:56 -0400
Received: from ozlabs.org ([203.10.76.45]:43600 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab2JEHfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:35:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-security-module@vger.kernel.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: Re: [PATCH 4/4] add finit_module syscall to asm-generic
In-Reply-To: <1349382154-9804-5-git-send-email-keescook@chromium.org>
References: <1349382154-9804-1-git-send-email-keescook@chromium.org> <1349382154-9804-5-git-send-email-keescook@chromium.org>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 05 Oct 2012 13:26:50 +0930
Message-ID: <87626p1shp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> This adds the finit_module syscall to the generic syscall list.

This does ppc.  Ben, please Ack.

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: powerpc: add finit_module syscall.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 8408387..d0b27f8 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -356,3 +356,4 @@ COMPAT_SYS_SPU(sendmmsg)
 SYSCALL_SPU(setns)
 COMPAT_SYS(process_vm_readv)
 COMPAT_SYS(process_vm_writev)
+SYSCALL(finit_module)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index c683fa3..3d588bb 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -375,10 +375,11 @@
 #define __NR_setns		350
 #define __NR_process_vm_readv	351
 #define __NR_process_vm_writev	352
+#define __NR_finit_module	353
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		353
+#define __NR_syscalls		354
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
