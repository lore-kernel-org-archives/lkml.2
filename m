Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab1EMXl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:41:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34343 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab1EMXl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to;
        b=gGpEE0g3akNdt7GFD1Jk/Med1ew7/gJcFjod6qpDgHjJXjrs/EG2dFd0Gfk7GTWy2u
         jf0Vb97F68aOXc3N3C+Q2kp1noXiQpWNaA5TD8SMtwSCSf+LSDAHBmUD5jwIP3i3oA50
         MU3/wsyIATAN3aqJ3Hzw+vdhjY4IrBfA+Hna0=
From: mfmooney@gmail.com
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v3] package: Makefile: fix perf target bug
Date: Fri, 13 May 2011 16:41:12 -0700
Message-Id: <b07e7ecdce48bc90a2cf83e8867494dae7cd174f.1305329845.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <4DCD8CE4.4090404@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Specify --git-dir when building perf targets to allow out-of-tree
builds using O=<build-dir>.

The shell command in `git archive' had to be modified to allow proper
file name expansion of the files listed in MANIFEST.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 scripts/package/Makefile |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 1b7eaea..03df8ee 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -118,10 +118,12 @@ perf-tar=perf-$(KERNELVERSION)
 
 quiet_cmd_perf_tar = TAR
       cmd_perf_tar = \
-git archive --prefix=$(perf-tar)/ HEAD^{tree}                       \
-	$$(cat $(srctree)/tools/perf/MANIFEST) -o $(perf-tar).tar;  \
+git --git-dir=$(srctree)/.git archive --prefix=$(perf-tar)/         \
+	HEAD^{tree} $$(cd $(srctree);                               \
+		       echo $$(cat $(srctree)/tools/perf/MANIFEST)) \
+	-o $(perf-tar).tar;                                         \
 mkdir -p $(perf-tar);                                               \
-git rev-parse HEAD > $(perf-tar)/HEAD;                              \
+git --git-dir=$(srctree)/.git rev-parse HEAD > $(perf-tar)/HEAD;    \
 tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \
 rm -r $(perf-tar);                                                  \
 $(if $(findstring tar-src,$@),,                                     \
-- 
1.7.4.4

