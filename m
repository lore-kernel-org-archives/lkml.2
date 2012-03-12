Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2CLAs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:48:58 -0400
Received: from 1wt.eu ([62.212.114.60]:63029 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab2CLAsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:12 -0400
Message-Id: <20120312002046.001935869@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:20:46 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [ 01/12] compat: Re-add missing asm/compat.h include to fix compile breakage on s390
In-Reply-To: <feb44625a10a45049eddf27890e95d54@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

For kernels < 3.0 the backport of 048cd4e51d24ebf7f3552226d03c769d6ad91658
"compat: fix compile breakage on s390" will break compilation...

Re-add a single #include <asm/compat.h> in order to fix this.

This patch is _not_ necessary for upstream, only for stable kernels
which include the "build fix" mentioned above.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 0b2573a..358e545 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -57,6 +57,7 @@
 #include <asm/ptrace.h>
 #include <asm/sections.h>
 #include <asm/ebcdic.h>
+#include <asm/compat.h>
 #include <asm/kvm_virtio.h>
 
 long psw_kernel_bits	= (PSW_BASE_BITS | PSW_MASK_DAT | PSW_ASC_PRIMARY |
-- 
1.7.2.1.45.g54fbc



