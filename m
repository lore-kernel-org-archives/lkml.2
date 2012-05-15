Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428Ab2EOCgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:36:11 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53518 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965397Ab2EOCRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 141/179] cifs: fix NULL pointer dereference in cifs_find_smb_ses
Date: Mon, 14 May 2012 22:13:57 -0400
Message-ID: <1337048075-6132-142-git-send-email-paul.gortmaker@windriver.com>
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

commit fc87a40677bbe0937e2ff0642c7e83c9a4813f3d upstream.

cifs_find_smb_ses assumes that the vol->password field is a valid
pointer, but that's only the case if a password was passed in via
the options string. It's possible that one won't be if there is
no mount helper on the box.

Reported-by: diabel <gacek-2004@wp.pl>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4e134a7..0fbc8d2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1609,7 +1609,8 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 				    MAX_USERNAME_SIZE))
 				continue;
 			if (strlen(vol->username) != 0 &&
-			    strncmp(ses->password, vol->password,
+			    strncmp(ses->password,
+				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))
 				continue;
 		}
-- 
1.7.9.6

