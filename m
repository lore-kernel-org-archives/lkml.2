Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1CUUIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:08:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18646 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1CUUIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:08:34 -0400
Date: Mon, 21 Mar 2011 21:08:24 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Eric Paris <eparis@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        linux-kbuild@vger.kernel.org
Subject: PATCH][RFC][resend] CC_OPTIMIZE_FOR_SIZE should default to N
Message-ID: <alpine.LNX.2.00.1103212105490.15815@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe that the majority of systems we are built on want a -O2 compiled 
kernel. Optimizing for size (-Os) is mainly benneficial for embedded 
systems and systems with very small CPU caches (correct me if I'm wrong).
So it seems wrong to me that CC_OPTIMIZE_FOR_SIZE defaults to 'y' and 
recommends saying 'Y' if unsure. I believe it should default to 'n' and 
recommend that if unsure. People who bennefit from -Os know who they are 
and can enable the option if needed/wanted - the majority shouldn't 
select this. Right?

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 56240e7..0d63dfa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -903,12 +903,12 @@ endif
 
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size"
-	default y
+	default n
 	help
 	  Enabling this option will pass "-Os" instead of "-O2" to gcc
 	  resulting in a smaller kernel.
 
-	  If unsure, say Y.
+	  If unsure, say N.
 
 config SYSCTL
 	bool


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

