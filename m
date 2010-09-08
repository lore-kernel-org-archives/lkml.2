Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab0IHQlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:41:40 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:44230 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab0IHQlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:41:36 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 1/5] fsldma: fix missing header include
Date: Wed,  8 Sep 2010 09:41:18 -0700
Message-Id: <1283964082-30133-2-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283964082-30133-1-git-send-email-iws@ovro.caltech.edu>
References: <1283964082-30133-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 08 Sep 2010 09:41:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slab.h header is required to use the kmalloc() family of functions.
Due to recent kernel changes, this header must be directly included by
code that calls into the memory allocator.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 arch/powerpc/include/asm/fsldma.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/fsldma.h b/arch/powerpc/include/asm/fsldma.h
index a67aeed..debc5ed 100644
--- a/arch/powerpc/include/asm/fsldma.h
+++ b/arch/powerpc/include/asm/fsldma.h
@@ -11,6 +11,7 @@
 #ifndef __ARCH_POWERPC_ASM_FSLDMA_H__
 #define __ARCH_POWERPC_ASM_FSLDMA_H__
 
+#include <linux/slab.h>
 #include <linux/dmaengine.h>
 
 /*
-- 
1.7.1

