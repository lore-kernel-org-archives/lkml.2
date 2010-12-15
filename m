Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0LOXk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:40:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37582 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753046Ab0LOXk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:40:57 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/FS58pHY7FA/QgN2Vsuixgv0fS/5yPiDYGsSHHrS
	BLf7kT0VSPjUNs
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH v2] include/linux: Add missing include / fix build failure
Date: Thu, 16 Dec 2010 00:40:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.4.5; x86_64; ; )
Cc: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org
References: <201012152204.18881.PeterHuewe@gmx.de> <20101216103141.6f0a418c.sfr@canb.auug.org.au>
In-Reply-To: <20101216103141.6f0a418c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012160040.54313.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure[1-2] by adding the missing asm/memory.h
include needed for arch_is_coherent().

Error message:
In file included from include/linux/list_bl.h:5,
                 from include/linux/rculist_bl.h:7,
                 from include/linux/dcache.h:7,
                 from include/linux/fs.h:381,
                 from arch/arm/mm/mmap.c:4:
include/linux/bit_spinlock.h: In function 'bit_spin_unlock':
include/linux/bit_spinlock.h:61: error: implicit declaration of function 
'arch_is_coherent'

KernelVersion: linux-next-20101215
Used configs: hackkit_defconfig (arm), ep93xx_defconfig (arm)

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/3651495/
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/3651425/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
v2:
moved additional information in the commit message.

 include/linux/bit_spinlock.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index e612575..053fad7 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/preempt.h>
 #include <asm/atomic.h>
+#include <asm/memory.h>
 
 /*
  *  bit-based spin_lock()
-- 
1.7.2.2

