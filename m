Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966002Ab2B1T0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:26:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab2B1T0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:26:22 -0500
Date: Tue, 28 Feb 2012 11:23:51 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-55f9709cd07c9d33e30b575ee1b3bfd0aeaa3760@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, matt.fleming@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, matt.fleming@intel.com
In-Reply-To: <1330436245-24875-3-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-3-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, relocs: Don't open code put_unaligned_le32()
Git-Commit-ID: 55f9709cd07c9d33e30b575ee1b3bfd0aeaa3760
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 28 Feb 2012 11:24:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55f9709cd07c9d33e30b575ee1b3bfd0aeaa3760
Gitweb:     http://git.kernel.org/tip/55f9709cd07c9d33e30b575ee1b3bfd0aeaa3760
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Tue, 28 Feb 2012 13:37:21 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 28 Feb 2012 10:22:55 -0800

x86, relocs: Don't open code put_unaligned_le32()

Use the new headers in tools/include instead of rolling our own
put_unaligned_le32() implementation.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-3-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
