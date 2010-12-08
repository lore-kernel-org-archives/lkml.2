Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0LHPBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:01:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52823 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab0LHPBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:01:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iyC2ZIn3zUHU4CDJdS2S8+ALUUKnElL9p6RhHnInZGtcZ+D3sAwocKy3dyElB0GOwS
         ikplkmwW0BAD62OAVPaQkh9xpuJCahypoHAarCPXuLGZkLO0XKJPBvx2xcV6auGUvYSk
         bCME9wn07bxFid4wv0GMM3tC8olCQoZljk/+c=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, mmarek@suse.cz,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 2/4] x86/of: Add building device tree blob(s) into image.
Date: Wed,  8 Dec 2010 07:01:14 -0800
Message-Id: <abe67e5689fef1d94e57be68ec5ef47a8f13bf8e.1291820034.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1291820033.git.dirk.brandewie@gmail.com>
References: <cover.1291820033.git.dirk.brandewie@gmail.com>
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
index 91fc929..e5f3b7b 100644
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
+	$(call cmd,dtc)
+endif
-- 
1.7.2.3

