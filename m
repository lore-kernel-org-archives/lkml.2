Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0LFRgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:36:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38872 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0LFRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EyuBXZF1uETutg8+mkPABZUfF3N6WU0PqkrdIP8W7N2Q/Bx8JQV3Jy8LewOCmREGqj
         hirKY53RmX/0gbsMtX+TrbMiwiXcvFvHaQp9WnyHx9eN4UBOU1469qEeBuZQseyQUxjy
         SJBlpR0DIxTS3bT9R8+uY30v8ywrmQM58wk5E=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, mmarek@suse.cz,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 2/4] x86/of: Add building device tree blob(s) into image.
Date: Mon,  6 Dec 2010 09:36:00 -0800
Message-Id: <b5a8dfa4d580d8637132f81317390a535ab98511.1291656753.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1291656753.git.dirk.brandewie@gmail.com>
References: <cover.1291656753.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch adds linking device tree blob into vmlinux. DTB's are
added by adding the blob object name to list of objects to be linked
into the image.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/platform/ce4100/Makefile |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/ce4100/Makefile b/arch/x86/platform/ce4100/Makefile
index 91fc929..3b49187 100644
--- a/arch/x86/platform/ce4100/Makefile
+++ b/arch/x86/platform/ce4100/Makefile
@@ -1 +1,11 @@
 obj-$(CONFIG_X86_INTEL_CE)	+= ce4100.o
+clean-files := *dtb.S
+
+ifdef CONFIG_X86_OF
+###
+# device tree blob
+obj-$(CONFIG_X86_INTEL_CE) += ce4100.dtb.o
+
+$(obj)/%.dtb: $(src)/%.dts
+	$(call if_changed,dtc)
+endif
-- 
1.7.2.3

