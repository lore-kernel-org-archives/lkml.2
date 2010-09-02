Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0IBTrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:47:55 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:44628 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab0IBTry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:47:54 -0400
Date: Thu, 2 Sep 2010 12:47:52 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] fsldma: fix missing header include
Message-ID: <20100902194752.GA24861@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 02 Sep 2010 12:47:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slab.h header is required to use the kmalloc() family of functions.
Due to recent kernel changes, this header must be directly included by
code that calls into the memory allocator.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---

Without this patch, any code which includes this header fails to build.

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

