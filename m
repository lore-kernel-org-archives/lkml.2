Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2KSUCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:02:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33673 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab2KSUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:02:15 -0500
Date: Mon, 19 Nov 2012 12:01:39 -0800
From: tip-bot for Alexander Duyck <alexander.h.duyck@intel.com>
Message-ID: <tip-bbee3aec3472fc2ca10b6b1020aec84567ea25ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alexander.h.duyck@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alexander.h.duyck@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20121119182927.3655.7641.stgit@ahduyck-cp1.jf.intel.com>
References: <20121119182927.3655.7641.stgit@ahduyck-cp1.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86:
  Fix warning about cast from pointer to integer of different size
Git-Commit-ID: bbee3aec3472fc2ca10b6b1020aec84567ea25ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 19 Nov 2012 12:02:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbee3aec3472fc2ca10b6b1020aec84567ea25ce
Gitweb:     http://git.kernel.org/tip/bbee3aec3472fc2ca10b6b1020aec84567ea25ce
Author:     Alexander Duyck <alexander.h.duyck@intel.com>
AuthorDate: Mon, 19 Nov 2012 10:31:37 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Nov 2012 10:45:19 -0800

x86: Fix warning about cast from pointer to integer of different size

This patch fixes a warning reported by the kbuild test robot where we were
casting a pointer to a physical address which represents an integer of a
different size.  Per the suggestion of Peter Anvin I am replacing it and one
other spot where I made a similar cast with an unsigned long.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Link: http://lkml.kernel.org/r/20121119182927.3655.7641.stgit@ahduyck-cp1.jf.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head32.c | 2 +-
 arch/x86/kernel/head64.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index f15db0c..e175548 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -31,7 +31,7 @@ static void __init i386_default_early_setup(void)
 void __init i386_start_kernel(void)
 {
 	memblock_reserve(__pa_symbol(_text),
-			 (phys_addr_t)__bss_stop - (phys_addr_t)_text);
+			 (unsigned long)__bss_stop - (unsigned long)_text);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 42f5df1..7b215a5 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -98,7 +98,7 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	copy_bootdata(__va(real_mode_data));
 
 	memblock_reserve(__pa_symbol(_text),
-			 (phys_addr_t)__bss_stop - (phys_addr_t)_text);
+			 (unsigned long)__bss_stop - (unsigned long)_text);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
