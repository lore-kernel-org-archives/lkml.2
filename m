Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1CEXud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 18:50:33 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18477 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1CEXuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 18:50:32 -0500
Date: Sun, 6 Mar 2011 00:49:58 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Eric Paris <eparis@redhat.com>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH][RFC] CC_OPTIMIZE_FOR_SIZE should default to N
Message-ID: <alpine.LNX.2.00.1103060044110.6297@swampdragon.chaosbits.net>
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
index be788c0..7e16268 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -886,12 +886,12 @@ endif
 
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
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

