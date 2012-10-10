Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab2JJXTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:19:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54484 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757596Ab2JJXAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:00:48 -0400
X-Sasl-enc: jZFBZn0FBoNBYpl4JUAcindV2yFumwTfGdEm8gBrb0IY 1349910047
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 009/122] ARM: 7548/1: include linux/sched.h in syscall.h
Date: Thu, 11 Oct 2012 07:52:55 +0900
Message-Id: <20121010225339.667728798@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wade Farnsworth <wade_farnsworth@mentor.com>

commit 8ef102c6b4bc996ff96ca52b34775fe931ec90c9 upstream.

The syscall tracing patch introduces a compile bug in lttng-modules
when the latter calls syscall_get_nr(), similar to the following:

<path-to-linux>/arch/arm/include/asm/syscall.h:21:2: error: implicit declaration of function 'task_thread_info' [-Werror=implicit-function-declaration]

The issue is that we are using task_thread_info() in the
syscall_get_nr() function in asm/syscall.h, but not explicitly
including sched.h from this file, so we can expect this bug might
surface any time that syscall_get_nr() is called.

Explicitly including sched.h solves the problem.

Signed-off-by: Wade Farnsworth <wade_farnsworth@mentor.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/syscall.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/include/asm/syscall.h
+++ b/arch/arm/include/asm/syscall.h
@@ -8,6 +8,7 @@
 #define _ASM_ARM_SYSCALL_H
 
 #include <linux/err.h>
+#include <linux/sched.h>
 
 extern const unsigned long sys_call_table[];
 


