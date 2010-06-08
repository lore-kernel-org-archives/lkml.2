Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0FHRhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:37:48 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:48351 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab0FHRhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:37:46 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org, "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 05/10] KConfig: Add KConfig entries for Labeled NFS
Date: Tue,  8 Jun 2010 12:22:51 -0400
Message-Id: <1276014176-20315-6-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276014176-20315-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1276014176-20315-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two entries into the fs/KConfig file. The first entry
NFS_V4_SECURITY_LABEL enables security label support for the NFSv4 client while
the second entry NFSD_V4_SECURITY_LABEL enables security labeling support on
the server side.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfs/Kconfig  |   16 ++++++++++++++++
 fs/nfsd/Kconfig |   13 +++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index a43d07e..67b158c 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -83,6 +83,22 @@ config NFS_V4_1
 
 	  Unless you're an NFS developer, say N.
 
+config NFS_V4_SECURITY_LABEL
+	bool "Provide Security Label support for NFSv4 client"
+	depends on NFS_V4 && SECURITY
+	help
+
+	Say Y here if you want enable fine-grained security label attribute
+	support for NFS version 4.  Security labels allow security modules like
+	SELinux and Smack to label files to facilitate enforcement of their policies.
+	Without this an NFSv4 mount will have the same label on each file.
+
+	If you do not wish to enable fine-grained security labels SELinux or
+	Smack policies on NFSv4 files, say N.
+
+
+	  If unsure, say N.
+
 config ROOT_NFS
 	bool "Root file system on NFS"
 	depends on NFS_FS=y && IP_PNP
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 503b9da..3a282f8 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -79,3 +79,16 @@ config NFSD_V4
 	  available from http://linux-nfs.org/.
 
 	  If unsure, say N.
+
+config NFSD_V4_SECURITY_LABEL
+	bool "Provide Security Label support for NFSv4 server"
+	depends on NFSD_V4 && SECURITY
+	help
+
+	Say Y here if you want enable fine-grained security label attribute
+	support for NFS version 4.  Security labels allow security modules like
+	SELinux and Smack to label files to facilitate enforcement of their policies.
+	Without this an NFSv4 mount will have the same label on each file.
+
+	If you do not wish to enable fine-grained security labels SELinux or
+	Smack policies on NFSv4 files, say N.
-- 
1.6.2.5

