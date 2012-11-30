Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769296Ab2K3T30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:29:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:58186 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992602Ab2K3S4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 01/56] UBIFS: fix compilation warning
Date: Fri, 30 Nov 2012 10:54:53 -0800
Message-Id: <20121130185118.463118862@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

commit 782759b9f5f5223e0962af60c3457c912fab755f upstream.

Fix the following compilation warning:

fs/ubifs/dir.c: In function 'ubifs_rename':
fs/ubifs/dir.c:972:15: warning: 'saved_nlink' may be used uninitialized
in this function

Use the 'uninitialized_var()' macro to get rid of this false-positive.

Artem: massaged the patch a bit.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -977,7 +977,7 @@ static int ubifs_rename(struct inode *ol
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1,
 			.dirtied_ino_d = ALIGN(old_inode_ui->data_len, 8) };
 	struct timespec time;
-	unsigned int saved_nlink;
+	unsigned int uninitialized_var(saved_nlink);
 
 	/*
 	 * Budget request settings: deletion direntry, new direntry, removing


