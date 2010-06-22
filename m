Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab0FVPnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:43:18 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51303 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0FVPnR (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com:0:0>);
	Tue, 22 Jun 2010 11:43:17 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 01/10] cifs: add kernel config option for CIFS Client caching support
Date: Tue, 22 Jun 2010 20:52:38 +0530
Message-Id: <1277220158-3405-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a kernel config option to enable local caching for CIFS.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/Kconfig |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 80f3525..5739fd7 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -131,6 +131,15 @@ config CIFS_DFS_UPCALL
 	    IP addresses) which is needed for implicit mounts of DFS junction
 	    points. If unsure, say N.
 
+config CIFS_FSCACHE
+	  bool "Provide CIFS client caching support (EXPERIMENTAL)"
+	  depends on EXPERIMENTAL
+	  depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
+	  help
+	    Makes CIFS FS-Cache capable. Say Y here if you want your CIFS data
+	    to be cached locally on disk through the general filesystem cache
+	    manager. If unsure, say N.
+
 config CIFS_EXPERIMENTAL
 	  bool "CIFS Experimental Features (EXPERIMENTAL)"
 	  depends on CIFS && EXPERIMENTAL
-- 
1.6.4.2

