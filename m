Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2DBXPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:15:36 -0400
Received: from claw.goop.org ([74.207.240.146]:48508 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2DBXPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:15:35 -0400
Message-ID: <4F7A3315.501@goop.org>
Date: Mon, 02 Apr 2012 16:15:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Reitmayr <treitmayr@devbase.at>, leigh123linux@googlemail.com,
        Dave Jones <davej@redhat.com>
Subject: [PATCH] Use correct byte-sized register constraint in __xchg_op()
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86-64 can access the low half of any register, but i386 can only do
it with a subset of registers.  'r' causes compilation failures on i386,
but 'q' expresses the constraint properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Reported-by: Leigh Scott <leigh123linux@googlemail.com>
Tested-by: Thomas Reitmayr <treitmayr@devbase.at>

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index b3b7332..bc18d0e 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -43,7 +43,7 @@ extern void __add_wrong_size(void)
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
 			asm volatile (lock #op "b %b0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : "+q" (__ret), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\


