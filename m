Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab1EXXyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:54:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55801 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab1EXXyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=uDCzPVsZIlq+9B/8/0Cs9EZlLP3bjCnc6I2G7FpwfgkUSX/2ME8naomyohwv6eByjb
         0WX/IEP/m2LXePZRpGvg==
Date: Tue, 24 May 2011 16:53:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [patch 6/6] slab: only define SLAB_CACHE_DMA for CONFIG_ZONE_DMA
In-Reply-To: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105241653180.29780@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only define SLAB_CACHE_DMA support if CONFIG_ZONE_DMA is enabled.  This
catches build errors when used on an invalid configuration.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/slab.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -20,7 +20,9 @@
 #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
-#define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
+#ifdef CONFIG_ZONE_DMA
+# define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
+#endif
 #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
 #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
 /*
