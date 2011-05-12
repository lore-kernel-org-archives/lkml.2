Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab1ELSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:25:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325Ab1ELSZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hiikfTBZod3aH+uVXEsCPRzmO+9S2NciHTjQI6Qbs7iEuAVekxV3GGN2i+s7VTqxUB
         XWbpPO4liR5GIFlC1epNrGoUXc5uJHNhDOCbKxRyhFaOFdODlqYAeoo7jNd1aeGysiou
         LxkdI9otlqNg8u5GjHrXMHHah7xglidVWQhEE=
From: mfmooney@gmail.com
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [Resend PATCH] package: Makefile: fix perf target bug
Date: Thu, 12 May 2011 11:25:15 -0700
Message-Id: <1d7d3b31c0da82ce8ce75778922155b7004a8f7e.1305224477.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Specify --git-dir and --work-tree when building perf targets to
allow out-of-tree builds using O=<build-dir>.

The cat command had to be changed to allow proper file name expansion
of the files listed in MANIFEST.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
Hi Michal,

Sorry if you have already received this, but there seems to have been
a problem when it was first sent.

Thanks,
matt

 scripts/package/Makefile |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 1b7eaea..a32dc2d 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -118,10 +118,14 @@ perf-tar=perf-$(KERNELVERSION)
 
 quiet_cmd_perf_tar = TAR
       cmd_perf_tar = \
-git archive --prefix=$(perf-tar)/ HEAD^{tree}                       \
-	$$(cat $(srctree)/tools/perf/MANIFEST) -o $(perf-tar).tar;  \
+git --git-dir=$(srctree)/.git --work-tree=$(srctree)                \
+	archive --prefix=$(perf-tar)/ HEAD^{tree}                   \
+	$(addprefix $(srctree)/,                                    \
+	  $(shell cat $(srctree)/tools/perf/MANIFEST))              \
+	-o $(perf-tar).tar;                                         \
 mkdir -p $(perf-tar);                                               \
-git rev-parse HEAD > $(perf-tar)/HEAD;                              \
+git --git-dir=$(srctree)/.git --work-tree=$(srctree)                \
+	rev-parse HEAD > $(perf-tar)/HEAD;                          \
 tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \
 rm -r $(perf-tar);                                                  \
 $(if $(findstring tar-src,$@),,                                     \
-- 
1.7.4.4

