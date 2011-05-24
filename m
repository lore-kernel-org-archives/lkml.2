Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab1EXXyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:54:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab1EXXx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=A1TWCvZ2typ54ghPoeW9s0p4APDVEEcCh/g/ICow0b2UxZyde60wJeEMlGaVPh6qmZ
         1+lYcG6ri0KTQUPMMQvg==
Date: Tue, 24 May 2011 16:53:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [patch 5/6] slab: avoid compiling SLAB_CACHE_DMA without DMA
 support
In-Reply-To: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105241652460.29780@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_ZONE_DMA is disabled, SLAB_CACHE_DMA is a no-op.  Avoid
compiling support for it on such a configuration.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slab.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -153,14 +153,18 @@
 #if DEBUG
 # define CREATE_MASK	(SLAB_RED_ZONE | \
 			 SLAB_POISON | SLAB_HWCACHE_ALIGN | \
+# ifdef CONFIG_ZONE_DMA
 			 SLAB_CACHE_DMA | \
+# endif
 			 SLAB_STORE_USER | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
 			 SLAB_DEBUG_OBJECTS | SLAB_NOLEAKTRACE | SLAB_NOTRACK)
 #else
 # define CREATE_MASK	(SLAB_HWCACHE_ALIGN | \
+# ifdef CONFIG_ZONE_DMA
 			 SLAB_CACHE_DMA | \
+# endif
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
 			 SLAB_DEBUG_OBJECTS | SLAB_NOLEAKTRACE | SLAB_NOTRACK)
