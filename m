Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0ITAF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 20:05:56 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:60113 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0ITAFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 20:05:55 -0400
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Sep 2010 20:05:55 EDT
Date: Mon, 20 Sep 2010 01:55:26 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ARM: (trivial) fix format warning in arch/arm/mm/init.c
Message-ID: <20100919235526.GA31892@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/mnt/src/linux-git/arch/arm/mm/init.c: In function ‘mem_init’:
/mnt/src/linux-git/arch/arm/mm/init.c:548:4: warning: format ‘%4d’ expects type ‘int’, but argument 22 has type ‘long int’
/mnt/src/linux-git/arch/arm/mm/init.c:548:4: warning: format ‘%4d’ expects type ‘int’, but argument 25 has type ‘long int’
/mnt/src/linux-git/arch/arm/mm/init.c:548:4: warning: format ‘%4d’ expects type ‘int’, but argument 28 has type ‘long int’

(with gcc-4.5.1)

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 arch/arm/mm/init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Patch against current linux.git (after 2.6.36-rc4).


diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 7185b00..009797d 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -521,9 +521,9 @@ void __init mem_init(void)
 			"    pkmap   : 0x%08lx - 0x%08lx   (%4ld MB)\n"
 #endif
 			"    modules : 0x%08lx - 0x%08lx   (%4ld MB)\n"
-			"      .init : 0x%p" " - 0x%p" "   (%4d kB)\n"
-			"      .text : 0x%p" " - 0x%p" "   (%4d kB)\n"
-			"      .data : 0x%p" " - 0x%p" "   (%4d kB)\n",
+			"      .init : 0x%p" " - 0x%p" "   (%4ld kB)\n"
+			"      .text : 0x%p" " - 0x%p" "   (%4ld kB)\n"
+			"      .data : 0x%p" " - 0x%p" "   (%4ld kB)\n",
 
 			MLK(UL(CONFIG_VECTORS_BASE), UL(CONFIG_VECTORS_BASE) +
 				(PAGE_SIZE)),
-- 
1.7.1

