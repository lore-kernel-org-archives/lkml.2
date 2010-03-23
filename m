Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab0CWAcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:32:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0CWAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:14 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, cluster-devel@redhat.com
Subject: [PATCH 10/18] gfs2: Provide config option for enabling trace points
Date: Tue, 23 Mar 2010 01:32:12 +0100
Message-Id: <1269304340-25372-11-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: cluster-devel@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/Kconfig      |    8 ++++++++
 fs/gfs2/trace_gfs2.h |    2 ++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 4dcddf8..872ced2 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -38,3 +38,11 @@ config GFS2_FS_LOCKING_DLM
 	  Most users of GFS2 will require this. It provides the locking
 	  interface between GFS2 and the DLM, which is required to use GFS2
 	  in a cluster environment.
+
+config GFS2_TRACER
+	bool "GFS2 tracing"
+	depends on GFS2_FS && EVENT_TRACING
+	help
+	  Provide trace points in block allocation functions, locking, and
+	  journaling code.
+
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 148d55c..5f4faf3 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM gfs2
+#define TRACE_CONFIG CONFIG_GFS2_TRACER
 
 #if !defined(_TRACE_GFS2_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_GFS2_H
-- 
1.6.4.2

