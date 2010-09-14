Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0INQBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 12:01:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41586 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab0INQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 12:01:26 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] x86: ensure we correctly advertise 32 bit processes in a 64 bit kernel
Date: Tue, 14 Sep 2010 17:00:57 +0100
Message-Id: <1284480057-18120-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284480057-18120-1-git-send-email-apw@canonical.com>
References: <1284480057-18120-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of generic system calls modify their behaviour for 32 bit
processes when executed on a 64 bit kernel.  For example the uname
family return i686 for 32 bit processes but x86_64 for 64 bit processes.
These calls determine which return to use based on the personality,
specifically they check for PER_LINUX32.  x86 does not currently set this
personality type, using an x86 specific thread bit to distinguish.

Ensure we use personality PER_LINUX32 for 32 bit processes.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 arch/x86/kernel/process_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3d9ea53..3793a6a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -518,7 +518,7 @@ void set_personality_ia32(void)
 
 	/* Make sure to be in 32bit mode */
 	set_thread_flag(TIF_IA32);
-	current->personality |= force_personality32;
+	current->personality |= force_personality32 | PER_LINUX32;
 
 	/* Prepare the first "return" to user space */
 	current_thread_info()->status |= TS_COMPAT;
-- 
1.7.0.4

