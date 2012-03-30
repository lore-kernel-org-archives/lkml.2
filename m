Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2C3GAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 02:00:33 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:14787 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2C3GA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 02:00:26 -0400
From: <gerg@uclinux.org>
To: <dhowells@redhat.com>
CC: linux-m68k@vger.kernel.org, uclinux-dev@uclinux.org, geert@linux-m68k.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH] m68k: include asm/cmpxchg.h in our m68k atomic.h
Date: Fri, 30 Mar 2012 15:52:09 +1000
Message-ID: <1333086729-14263-1-git-send-email-gerg@uclinux.org>
X-Mailer: git-send-email 1.5.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Ungerer <gerg@uclinux.org>

After commit 9ffc93f203c18a70623f21950f1dd473c9ec48cd ("Remove all

  CC      init/main.o
In file included from include/linux/mm.h:15:0,
                 from include/linux/ring_buffer.h:5,
                 from include/linux/ftrace_event.h:4,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:78,
                 from init/main.c:16:
include/linux/debug_locks.h: In function ‘__debug_locks_off’:
include/linux/debug_locks.h:16:2: error: implicit declaration of function ‘xchg’

There is no indirect inclusions of the new asm/cmpxchg.h for m68k here.
Looking at most other architectures they include asm/cmpxchg.h in their
asm/atomic.h. M68k currently does not do this. Including this in atomic.h
fixes all m68k build problems.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/atomic.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 336e617..f4e32de 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/irqflags.h>
+#include <asm/cmpxchg.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
-- 
1.7.0.4

