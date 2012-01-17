Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab2AQFw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 00:52:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36940 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2AQFw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 00:52:57 -0500
Message-ID: <1326779572.2564.47.camel@edumazet-laptop>
Subject: [PATCH] mips: remove custom BUILD_BUG()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>
Date: Tue, 17 Jan 2012 06:52:52 +0100
In-Reply-To: <1322092017-21471-2-git-send-email-ddaney.cavm@gmail.com>
References: <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com>
	 <1322092017-21471-2-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1399ff86f2a2b (kernel.h: add BUILD_BUG() macro) broke mips build

In file included from /opt/src/linux/arch/mips/include/asm/io.h:16:0,
                 from /opt/src/linux/arch/mips/include/asm/page.h:54,
                 from include/linux/serial.h:16,
                 from include/linux/serial_core.h:23,
                 from include/linux/serial_8250.h:14,
                 from arch/mips/mti-malta/malta-platform.c:25:
include/linux/kernel.h:717:0: error: "BUILD_BUG" redefined [-Werror]
/opt/src/linux/arch/mips/include/asm/page.h:43:0: note: this is the
location of the previous definition
cc1: all warnings being treated as errors

Remove the conflicting mips macro.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/page.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index d417909..da9bd7d 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -39,9 +39,6 @@
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 #else /* !CONFIG_HUGETLB_PAGE */
-# ifndef BUILD_BUG
-#  define BUILD_BUG() do { extern void __build_bug(void); __build_bug(); } while (0)
-# endif
 #define HPAGE_SHIFT	({BUILD_BUG(); 0; })
 #define HPAGE_SIZE	({BUILD_BUG(); 0; })
 #define HPAGE_MASK	({BUILD_BUG(); 0; })


