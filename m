Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab2EJVLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:11:06 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:55189 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758243Ab2EJVJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:09:56 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-parisc@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: [PATCH 1/5] parisc: add missing includes in asm/spinlock.h
Date: Thu, 10 May 2012 22:57:11 +0200
Message-ID: <1723943.8iulFKmgJs@donald.sf-tec.de>
User-Agent: KMail/4.8.3 (Linux/3.2.9-13-desktop; KDE/4.8.3; i686; ; )
In-Reply-To: <4430485.xEvkeJU8MB@donald.sf-tec.de>
References: <4430485.xEvkeJU8MB@donald.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This leads to this errors:

In file included from /home/buildbot/repos/linux/arch/parisc/include/asm/atomic.h:20:0,
                 from /home/buildbot/repos/linux/include/linux/atomic.h:4,
                 from /home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h:56,
                 from /home/buildbot/repos/linux/include/linux/bitops.h:22,
                 from /home/buildbot/repos/linux/include/linux/kernel.h:19,
                 from /home/buildbot/repos/linux/include/linux/sched.h:55,
                 from /home/buildbot/repos/linux/arch/parisc/kernel/asm-offsets.c:31:
/home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h: In function ‘arch_spin_is_locked’:
/home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h:9:2: error: implicit declaration of function ‘__ldcw_align’ [-Werror=implicit-function-declaration]
/home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h:9:29: warning: initialization makes pointer from integer without a cast [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h: In function ‘arch_spin_lock_flags’:
/home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h:22:2: error: implicit declaration of function ‘mb’ [-Werror=implicit-function-declaration]
/home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h:23:4: warning: assignment makes pointer from integer without a cast [enabled by default]
/home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h:24:2: error: implicit declaration of function ‘__ldcw’ [-Werror=implicit-function-declaration]

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 arch/parisc/include/asm/spinlock.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/parisc/include/asm/spinlock.h b/arch/parisc/include/asm/spinlock.h
index 804aa28..3516e0b 100644
--- a/arch/parisc/include/asm/spinlock.h
+++ b/arch/parisc/include/asm/spinlock.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_SPINLOCK_H
 #define __ASM_SPINLOCK_H
 
+#include <asm/barrier.h>
+#include <asm/ldcw.h>
 #include <asm/processor.h>
 #include <asm/spinlock_types.h>
 
-- 
1.7.9.2


