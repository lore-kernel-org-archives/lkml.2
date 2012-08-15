Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab2HOTwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:52:20 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63078 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab2HOTwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dave Jones <davej@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 129/165] kbuild: Disable -Wunused-but-set-variable for gcc 4.6.0
Date: Wed, 15 Aug 2012 15:47:53 -0400
Message-ID: <1345060109-9187-130-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit af0e5d565d2fffcd97d1e2d89669d627cc04e8b8 upstream.

Disable the new -Wunused-but-set-variable that was added in gcc 4.6.0
It produces more false positives than useful warnings.

This can still be enabled using W=1

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Makefile               | 4 ++++
 scripts/Makefile.build | 1 +
 2 files changed, 5 insertions(+)

diff --git a/Makefile b/Makefile
index 25a8f63..e9fafd0 100644
--- a/Makefile
+++ b/Makefile
@@ -547,6 +547,10 @@ ifndef CONFIG_CC_STACKPROTECTOR
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 endif
 
+# This warning generated too much noise in a regular build.
+# Use make W=1 to enable this warning (see scripts/Makefile.build)
+KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index f9a413b..4e82824 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -66,6 +66,7 @@ warning-1 += -Wmissing-format-attribute
 warning-1 += -Wmissing-prototypes
 warning-1 += -Wold-style-definition
 warning-1 += $(call cc-option, -Wmissing-include-dirs)
+warning-1 += $(call cc-option, -Wunused-but-set-variable)
 
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
-- 
1.7.12.rc2

