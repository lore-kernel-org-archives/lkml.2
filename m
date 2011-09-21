Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab1IUEpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 00:45:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40897 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab1IUEpg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 00:45:36 -0400
Subject: [PATCH] x86-32: Fix alignment of alternative instruction entries
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andres Salomon <dilinger@queued.net>,
        Andy Lutomirski <luto@mit.edu>, Arnaud Lacombe <lacombar@gmail.com>
Date: Wed, 21 Sep 2011 05:45:13 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1316580313.4122.21.camel@deadeye>
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The altinstruction_entry macro was originally used only on x86-64,
and assumed 64-bit pointers and alignment.

Commit b4ca46e4e82a0a5976fe5eab85be585d75f8202f ("x86-32: Fix boot
with CONFIG_X86_INVD_BUG") introduced a use of the macro on x86-32.
Before this, the 64-bit pointers had been replaced by 32-bit offsets,
so it worked - in at least one case.  However, the alignment is still
wrong for x86-32, which can result in zero-padding between entries and
a BUG in apply_alternatives.

Reported-by: Andres Salomon <dilinger@queued.net>
References: http://bugs.debian.org/640964
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/alternative-asm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 4554cc6..d00dc2a 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -16,7 +16,7 @@
 #endif
 
 .macro altinstruction_entry orig alt feature orig_len alt_len
-	.align 8
+	_ASM_ALIGN
 	.long \orig - .
 	.long \alt - .
 	.word \feature
-- 
1.7.5.4


