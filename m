Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3AHXrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:47:42 -0500
Received: from ozlabs.org ([203.10.76.45]:59822 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab3AHXrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:47:37 -0500
Date: Wed, 9 Jan 2013 10:47:36 +1100
From: Anton Blanchard <anton@samba.org>
To: eparis@redhat.com, viro@zeniv.linux.org.uk, benh@kernel.crashing.org,
        paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/4] powerpc: Remove static branch prediction in 64bit
 traced syscall path
Message-ID: <20130109104736.063d143b@kryten>
In-Reply-To: <20130109104617.74e995a5@kryten>
References: <20130109104617.74e995a5@kryten>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some distros enable auditing by default which forces us through the
syscall trace path. Remove the static branch prediction in our 64bit
syscall handler and let the hardware do the prediction.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/arch/powerpc/kernel/entry_64.S
===================================================================
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -149,7 +149,7 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_SPLP
 	CURRENT_THREAD_INFO(r11, r1)
 	ld	r10,TI_FLAGS(r11)
 	andi.	r11,r10,_TIF_SYSCALL_T_OR_A
-	bne-	syscall_dotrace
+	bne	syscall_dotrace
 .Lsyscall_dotrace_cont:
 	cmpldi	0,r0,NR_syscalls
 	bge-	syscall_enosys
