Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab2EURwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:52:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:61908 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933300Ab2EURwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:52:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="146513412"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] x86, relocs: build clean fix
Date: Mon, 21 May 2012 20:51:24 +0300
Message-Id: <1337622684-6834-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

relocs was not cleaned up when "make clean" is issued. This
patch fixes the issue.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 94e91e4..b1c611e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -206,6 +206,7 @@ archclean:
 	$(Q)rm -rf $(objtree)/arch/i386
 	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=$(boot)
+	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
-- 
1.7.9.5

