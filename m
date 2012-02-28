Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab2B1Nig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:38:36 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56888 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757214Ab2B1Nhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:37:31 -0500
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [RFC][PATCH 2/6] x86, relocs: Don't open code put_unaligned_le32()
Date: Tue, 28 Feb 2012 13:37:21 +0000
Message-Id: <1330436245-24875-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Use the new headers in tools/include instead of rolling our own
put_unaligned_le32() implementation.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/relocs.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index 89bbf4e..d3c0b02 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -10,6 +10,7 @@
 #define USE_BSD
 #include <endian.h>
 #include <regex.h>
+#include <tools/le_byteshift.h>
 
 static void die(char *fmt, ...);
 
@@ -605,10 +606,7 @@ static void emit_relocs(int as_text)
 		fwrite("\0\0\0\0", 4, 1, stdout);
 		/* Now print each relocation */
 		for (i = 0; i < reloc_count; i++) {
-			buf[0] = (relocs[i] >>  0) & 0xff;
-			buf[1] = (relocs[i] >>  8) & 0xff;
-			buf[2] = (relocs[i] >> 16) & 0xff;
-			buf[3] = (relocs[i] >> 24) & 0xff;
+			put_unaligned_le32(relocs[i], buf);
 			fwrite(buf, 4, 1, stdout);
 		}
 	}
-- 
1.7.4.4

