Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab2ILXbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:31:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2ILXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:31:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Matt Turner <mattst88@gentoo.org>,
        Mike Frysinger <vapier@gentoo.org>, Michael Cree <mcree@orcon.net.nz>,
        Matt Turner <mattst88@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 022/108] alpha: fix fpu.h usage in userspace
Date: Wed, 12 Sep 2012 16:28:20 -0700
Message-Id: <20120912232452.855440892@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 0be421862b857e61964435ffcaa7499cf77a5e5a upstream.

After commit ec2212088c42 ("Disintegrate asm/system.h for Alpha"), the
fpu.h header which we install for userland started depending on
special_insns.h which is not installed.

However, fpu.h only uses that for __KERNEL__ code, so protect the
inclusion the same way to avoid build breakage in glibc:

  /usr/include/asm/fpu.h:4:31: fatal error: asm/special_insns.h: No such file or directory

Reported-by: Matt Turner <mattst88@gentoo.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Acked-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/alpha/include/asm/fpu.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/alpha/include/asm/fpu.h
+++ b/arch/alpha/include/asm/fpu.h
@@ -1,7 +1,9 @@
 #ifndef __ASM_ALPHA_FPU_H
 #define __ASM_ALPHA_FPU_H
 
+#ifdef __KERNEL__
 #include <asm/special_insns.h>
+#endif
 
 /*
  * Alpha floating-point control register defines:


