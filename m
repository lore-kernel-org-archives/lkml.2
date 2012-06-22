Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067Ab2FVKej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:34:39 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4943 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762023Ab2FVKei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:34:38 -0400
Message-ID: <1340361276.1773.79.camel@x61.thuisdomein>
Subject: [PATCH] h8300: remove never used asm/shm.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 22 Jun 2012 12:34:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 22 Jun 2012 10:34:36.0810 (UTC) FILETIME=[9EFE5EA0:01CD5062]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

h8300's asm/shm.h header has been part of the tree ever since h8300
support got added in v2.5.68. (It started as /include/asm-h8300/shm.h
and moved to its current location a few years ago. Note that it is an
almost verbatim copy of m68k's asm/shm.h. See, for instance, the
reference to CONFIG_SUN3, which is only relevant for m68k.) It seems it
was never used: no file ever included it and nothing used the macros it
defines.

This header can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested by using various git commands on the (history of the) tree.

1) There's an almost identical patch for m68k's asm/shm.h header.

 arch/h8300/include/asm/shm.h |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)
 delete mode 100644 arch/h8300/include/asm/shm.h

diff --git a/arch/h8300/include/asm/shm.h b/arch/h8300/include/asm/shm.h
deleted file mode 100644
index ed6623c..0000000
--- a/arch/h8300/include/asm/shm.h
+++ /dev/null
@@ -1,31 +0,0 @@
-#ifndef _H8300_SHM_H
-#define _H8300_SHM_H
-
-
-/* format of page table entries that correspond to shared memory pages
-   currently out in swap space (see also mm/swap.c):
-   bits 0-1 (PAGE_PRESENT) is  = 0
-   bits 8..2 (SWP_TYPE) are = SHM_SWP_TYPE
-   bits 31..9 are used like this:
-   bits 15..9 (SHM_ID) the id of the shared memory segment
-   bits 30..16 (SHM_IDX) the index of the page within the shared memory segment
-                    (actually only bits 25..16 get used since SHMMAX is so low)
-   bit 31 (SHM_READ_ONLY) flag whether the page belongs to a read-only attach
-*/
-/* on the m68k both bits 0 and 1 must be zero */
-/* format on the sun3 is similar, but bits 30, 31 are set to zero and all
-   others are reduced by 2. --m */
-
-#ifndef CONFIG_SUN3
-#define SHM_ID_SHIFT	9
-#else
-#define SHM_ID_SHIFT	7
-#endif
-#define _SHM_ID_BITS	7
-#define SHM_ID_MASK	((1<<_SHM_ID_BITS)-1)
-
-#define SHM_IDX_SHIFT	(SHM_ID_SHIFT+_SHM_ID_BITS)
-#define _SHM_IDX_BITS	15
-#define SHM_IDX_MASK	((1<<_SHM_IDX_BITS)-1)
-
-#endif /* _H8300_SHM_H */
-- 
1.7.7.6

