Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524Ab2CPXj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:39:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946206Ab2CPXjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:19 -0400
Message-Id: <20120316233450.307345243@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 34/38] sparc32: Add -Av8 to assembler command line.
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit e0adb9902fb338a9fe634c3c2a3e474075c733ba upstream.

Newer version of binutils are more strict about specifying the
correct options to enable certain classes of instructions.

The sparc32 build is done for v7 in order to support sun4c systems
which lack hardware integer multiply and divide instructions.

So we have to pass -Av8 when building the assembler routines that
use these instructions and get patched into the kernel when we find
out that we have a v8 capable cpu.

Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -31,7 +31,7 @@ UTS_MACHINE    := sparc
 
 #KBUILD_CFLAGS += -g -pipe -fcall-used-g5 -fcall-used-g7
 KBUILD_CFLAGS += -m32 -pipe -mno-fpu -fcall-used-g5 -fcall-used-g7
-KBUILD_AFLAGS += -m32
+KBUILD_AFLAGS += -m32 -Wa,-Av8
 
 #LDFLAGS_vmlinux = -N -Ttext 0xf0004000
 #  Since 2.5.40, the first stage is left not btfix-ed.


