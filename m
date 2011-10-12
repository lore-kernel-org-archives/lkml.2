Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1JLVTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:19:42 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:32824 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1JLVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:19:41 -0400
Subject: [PATCH] [TRIVIAL] isdn: hisax: Fix typo 'HISAX_DE_AOC'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 23:19:32 +0200
Message-ID: <1318454372.8345.11.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That should probably be 'CONFIG_DE_AOC'.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This is just the most obvious way to reconcile an unused Kconfig symbol
(DE_AOC) and an unknown macro (HISAX_DE_AOC). But it's basically just
educated guesswork. Entirely untested too. Added maintainer and netdev,
since this might be stretching the definition of a trivial patch.

 drivers/isdn/hisax/l3dss1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
index b0d9ab1..6a8acf6 100644
--- a/drivers/isdn/hisax/l3dss1.c
+++ b/drivers/isdn/hisax/l3dss1.c
@@ -353,7 +353,7 @@ l3dss1_parse_facility(struct PStack *st, struct l3_process *pc,
 			         { l3dss1_dummy_invoke(st, cr, id, ident, p, nlen);
                                    return;
                                  } 
-#ifdef HISAX_DE_AOC
+#ifdef CONFIG_DE_AOC
 			{
 
 #define FOO1(s,a,b) \
@@ -422,9 +422,9 @@ l3dss1_parse_facility(struct PStack *st, struct l3_process *pc,
 #undef FOO1
 
 			}
-#else  /* not HISAX_DE_AOC */
+#else  /* not CONFIG_DE_AOC */
                         l3_debug(st, "invoke break");
-#endif /* not HISAX_DE_AOC */
+#endif /* not CONFIG_DE_AOC */
 			break;
 		case 2:	/* return result */
 			 /* if no process available handle separately */ 
-- 
1.7.4.4



