Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946040Ab2KOA7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:59:55 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:55890 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932984Ab2KOA7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:59:53 -0500
Message-ID: <50A43E5E.9040905@xenotime.net>
Date: Wed, 14 Nov 2012 16:59:10 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org
Subject: [PATCH 1/2] asm-generic: add __WARN() to bug.h
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
In-Reply-To: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Add __WARN() macro for the case of CONFIG_BUG is not enabled.
This fixes a build error in mm/balloon_compaction.c.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
Cc: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org
---
 include/asm-generic/bug.h |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20121114.orig/include/asm-generic/bug.h
+++ linux-next-20121114/include/asm-generic/bug.h
@@ -129,6 +129,10 @@ extern void warn_slowpath_null(const cha
 })
 #endif
 
+#ifndef __WARN
+#define __WARN()	do {} while (0)
+#endif
+
 #define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
 
 #endif
