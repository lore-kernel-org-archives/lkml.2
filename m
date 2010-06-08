Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0FHQ0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 12:26:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38358 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669Ab0FHQ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 12:26:19 -0400
Subject: [RFC PATCH 3/3] Change DEBUG_PAGEALLOC dependency on
 ARCH_SUPPORTS_DEBUG_PAGEALLOC
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Akinobu Mita <akinobu.mita@gmail.com>
Date: Tue, 08 Jun 2010 17:26:09 +0100
Message-ID: <20100608162609.21870.13212.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100608162046.21870.5615.stgit@e102109-lin.cambridge.arm.com>
References: <20100608162046.21870.5615.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2010 16:26:09.0915 (UTC) FILETIME=[4DB704B0:01CB0727]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEBUG_PAGEALLOC currently depends on ARCH_SUPPORTS_DEBUG_PAGEALLOC.
However, it is selected by PAGE_POISONING which depends on
!ARCH_SUPPORTS_DEBUG_PAGEALLOC.

This patch changes the DEBUG_PAGEALLOC entry so that the dependency is
moved to the definition line rather than having an explicit "depends on"
line.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/Kconfig.debug |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index af7cfb4..983375d 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -1,6 +1,6 @@
 config DEBUG_PAGEALLOC
-	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	bool "Debug page memory allocations" if ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	depends on DEBUG_KERNEL
 	depends on !HIBERNATION || !PPC && !SPARC
 	depends on !KMEMCHECK
 	---help---

