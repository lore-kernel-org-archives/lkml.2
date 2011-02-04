Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1BDBiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 20:38:10 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:60429
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab1BDBiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 20:38:09 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: x86@kernel.org
Cc: Kamal Mostafa <kamal@canonical.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: "mem=nopentium ignored" warning when not supported
Date: Thu,  3 Feb 2011 17:38:05 -0800
Message-Id: <1296783486-23033-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296783486-23033-1-git-send-email-kamal@canonical.com>
References: <1296783486-23033-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit warning when "mem=nopentium" is specified on any arch other
than x86_32 (the only that arch supports it).

BugLink: http://bugs.launchpad.net/bugs/553464
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/e820.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 55a59d8..0429ad0 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -847,12 +847,16 @@ static int __init parse_memopt(char *p)
 	if (!p)
 		return -EINVAL;
 
-#ifdef CONFIG_X86_32
 	if (!strcmp(p, "nopentium")) {
+#ifdef CONFIG_X86_32
 		setup_clear_cpu_cap(X86_FEATURE_PSE);
 		return 0;
-	}
+#else
+		printk(KERN_WARNING
+			"mem=nopentium ignored! (only supported on x86_32)\n");
+		return -EINVAL;
 #endif
+	}
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
-- 
1.7.1

