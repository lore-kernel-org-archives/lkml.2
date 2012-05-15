Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430Ab2EOCfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:35:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:49822 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965409Ab2EOCR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 142/179] cifs: check for NULL session password
Date: Mon, 14 May 2012 22:13:58 -0400
Message-ID: <1337048075-6132-143-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 24e6cf92fde1f140d8eb0bf7cd24c2c78149b6b2 upstream.

It's possible for a cifsSesInfo struct to have a NULL password, so we
need to check for that prior to running strncmp on it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/connect.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0fbc8d2..f31ad2d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1609,6 +1609,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 				    MAX_USERNAME_SIZE))
 				continue;
 			if (strlen(vol->username) != 0 &&
+			    ses->password != NULL &&
 			    strncmp(ses->password,
 				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))
-- 
1.7.9.6

