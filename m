Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946055Ab2KOBAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:00:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:44908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946024Ab2KOBAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:00:07 -0500
Message-ID: <50A43E64.3040709@infradead.org>
Date: Wed, 14 Nov 2012 16:59:16 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] mm: balloon_compaction.c needs asm-generic/bug.h
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
In-Reply-To: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build when CONFIG_BUG is not enabled by adding header file
<asm-generic/bug.h>:

mm/balloon_compaction.c: In function 'balloon_page_putback':
mm/balloon_compaction.c:243:3: error: implicit declaration of function '__WARN'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Rafael Aquini <aquini@redhat.com>
---
 mm/balloon_compaction.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20121114.orig/mm/balloon_compaction.c
+++ linux-next-20121114/mm/balloon_compaction.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/balloon_compaction.h>
+#include <asm-generic/bug.h>
 
 /*
  * balloon_devinfo_alloc - allocates a balloon device information descriptor.
