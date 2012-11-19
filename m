Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2KSFbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:21 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33522 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KSFbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:18 -0500
X-Originating-IP: 217.70.178.141
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 35/58] x86: arch/x86/kernel/asm-offsets.c: Add prototype for dummy function common
Date: Sun, 18 Nov 2012 21:28:14 -0800
Message-Id: <1353302917-13995-36-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/asm-offsets.c defines an intentionally unused function
common, just to slurp out the generated assembly and obtain the values
for some constants.  Add a prototype of this function, to satisfy GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

arch/x86/kernel/asm-offsets.c:30:6: warning: no previous prototype for ‘common’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/asm-offsets.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 2861082..bae77e4 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -27,6 +27,8 @@
 # include "asm-offsets_64.c"
 #endif
 
+void common(void);
+
 void common(void) {
 	BLANK();
 	OFFSET(TI_flags, thread_info, flags);
-- 
1.7.10.4

