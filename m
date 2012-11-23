Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2KWMJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:09:44 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56728 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab2KWMIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:08:51 -0500
From: James Hogan <james.hogan@imgtec.com>
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Joe Perches" <joe@perches.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        "Mike Frysinger" <vapier@gentoo.org>
Subject: [PATCH 2/2] modsign: add symbol prefix to certificate list
Date: Fri, 23 Nov 2012 12:08:16 +0000
Message-ID: <1353672496-10789-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1353672496-10789-1-git-send-email-james.hogan@imgtec.com>
References: <1353672496-10789-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_11_23_12_08_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the arch symbol prefix (if applicable) to the asm definition of
modsign_certificate_list and modsign_certificate_list_end. This uses the
recently defined SYMBOL_PREFIX which is derived from
CONFIG_SYMBOL_PREFIX.

This fixes the build of module signing on the blackfin and metag
architectures.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 kernel/modsign_pubkey.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
index 4646eb2..767e559 100644
--- a/kernel/modsign_pubkey.c
+++ b/kernel/modsign_pubkey.c
@@ -21,10 +21,10 @@ struct key *modsign_keyring;
 extern __initdata const u8 modsign_certificate_list[];
 extern __initdata const u8 modsign_certificate_list_end[];
 asm(".section .init.data,\"aw\"\n"
-    "modsign_certificate_list:\n"
+    SYMBOL_PREFIX "modsign_certificate_list:\n"
     ".incbin \"signing_key.x509\"\n"
     ".incbin \"extra_certificates\"\n"
-    "modsign_certificate_list_end:"
+    SYMBOL_PREFIX "modsign_certificate_list_end:"
     );
 
 /*
-- 
1.7.7.6


