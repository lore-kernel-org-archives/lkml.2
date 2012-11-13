Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2KMHpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:45:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63749 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2KMHpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:45:08 -0500
Date: Mon, 12 Nov 2012 23:45:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-mips@linux-mips.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] mips, arc: fix build failure
In-Reply-To: <20121113170046.48e2c790d5c6c1e5f51c593d@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1211122342570.29609@chino.kir.corp.google.com>
References: <20121113170046.48e2c790d5c6c1e5f51c593d@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a cross-compiler to fix another issue, the following build error 
occurred for mips defconfig:

arch/mips/fw/arc/misc.c: In function 'ArcHalt':
arch/mips/fw/arc/misc.c:25:2: error: implicit declaration of function 'local_irq_disable'

Fix it up by including irqflags.h.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/mips/fw/arc/misc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/fw/arc/misc.c b/arch/mips/fw/arc/misc.c
--- a/arch/mips/fw/arc/misc.c
+++ b/arch/mips/fw/arc/misc.c
@@ -11,6 +11,7 @@
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/irqflags.h>
 
 #include <asm/bcache.h>
 
