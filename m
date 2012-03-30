Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935384Ab2C3VIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:08:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935372Ab2C3VIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:08:37 -0400
Message-Id: <20120330195737.350456989@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:59:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 106/108] compat: use sys_sendfile64() implementation for sendfile syscall
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 1631fcea8399da5e80a80084b3b8c5bfd99d21e7 upstream.

<asm-generic/unistd.h> was set up to use sys_sendfile() for the 32-bit
compat API instead of sys_sendfile64(), but in fact the right thing to
do is to use sys_sendfile64() in all cases.  The 32-bit sendfile64() API
in glibc uses the sendfile64 syscall, so it has to be capable of doing
full 64-bit operations.  But the sys_sendfile() kernel implementation
has a MAX_NON_LFS test in it which explicitly limits the offset to 2^32.
So, we need to use the sys_sendfile64() implementation in the kernel
for this case.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/unistd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -218,7 +218,7 @@ __SC_COMP(__NR_pwritev, sys_pwritev, com
 
 /* fs/sendfile.c */
 #define __NR3264_sendfile 71
-__SC_3264(__NR3264_sendfile, sys_sendfile64, sys_sendfile)
+__SYSCALL(__NR3264_sendfile, sys_sendfile64)
 
 /* fs/select.c */
 #define __NR_pselect6 72


