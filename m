Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1CHEA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 23:00:27 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:10681 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1CHEAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 23:00:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhcGAAc5dU2rR7Ht/2dsb2JhbACYT44HdKIZi0iHZC+IYIViBIUdhxWGYA
X-IronPort-AV: E=Sophos;i="4.62,282,1297036800"; 
   d="scan'208";a="274543742"
From: Vinay Sawal <vinaysawal@gmail.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Vinay Sawal <vinaysawal@gmail.com>
Subject: [PATCH] FC: cifs: Initialized an uninitialized variable
Date: Mon,  7 Mar 2011 20:00:09 -0800
Message-Id: <1299556809-16194-1-git-send-email-vinaysawal@gmail.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed a compile time warning by initializing an uninitialized variable.

Signed-off-by: Vinay Sawal <vinaysawal@gmail.com>
---
 fs/cifs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e964b1c..a9e5901 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1819,7 +1819,7 @@ static ssize_t
 cifs_iovec_read(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	int rc;
+	int rc = -EFAULT;
 	int xid;
 	ssize_t total_read;
 	unsigned int bytes_read = 0;
-- 
1.6.2.4

