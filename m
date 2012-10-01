Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2JAW7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:30 -0400
Received: from 1wt.eu ([62.212.114.60]:34955 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405Ab2JAW70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:26 -0400
Message-Id: <20121001225157.695817800@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:51:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 002/180] Fix sparc build with newer tools.
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David Miller <davem@davemloft.net>

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/sparc/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/Makefile b/arch/sparc/Makefile
index 113225b..0538555 100644
--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -31,7 +31,7 @@ UTS_MACHINE    := sparc
 
 #KBUILD_CFLAGS += -g -pipe -fcall-used-g5 -fcall-used-g7
 KBUILD_CFLAGS += -m32 -pipe -mno-fpu -fcall-used-g5 -fcall-used-g7
-KBUILD_AFLAGS += -m32
+KBUILD_AFLAGS += -m32 -Wa,-Av8
 
 #LDFLAGS_vmlinux = -N -Ttext 0xf0004000
 #  Since 2.5.40, the first stage is left not btfix-ed.
-- 
1.7.2.1.45.g54fbc



