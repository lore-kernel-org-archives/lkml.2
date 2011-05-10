Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1EJWxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:53:37 -0400
Received: from [69.28.251.93] ([69.28.251.93]:51609 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab1EJWxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:53:36 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: <linux-kbuild@vger.kernel.org>, <stable@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] kbuild: Fix GNU make v3.80 compatibility
Date: Tue, 10 May 2011 15:47:16 -0700
Message-Id: <612917f85f003cc05dbd3420ec718bc4@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/Changes, the kernel should be buildable with
GNU make 3.80+.  Commit 88d7be031f9f975bb3f50a0b5ef3796a671e7edf (kbuild:
Use a single clean rule for kernel and external modules) introduced the
"$(or" construct, which requires make 3.81.  This causes "make clean" to
malfunction when it is used with external modules.

Replace "$(or" with an equivalent "$(if" expression, to restore backward
compatibility.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Cc: stable@kernel.org
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 41ea6fb..d593b12 100644
--- a/Makefile
+++ b/Makefile
@@ -1374,7 +1374,7 @@ endif # KBUILD_EXTMOD
 clean: $(clean-dirs)
 	$(call cmd,rmdirs)
 	$(call cmd,rmfiles)
-	@find $(or $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
+	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
-- 
1.7.5

