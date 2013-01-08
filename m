Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab3AHXuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:50:50 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53652 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3AHXha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Suresh Jayaraman <sjayaraman@suse.com>, Steve French <sfrench@us.ibm.com>,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 11/77] cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch
Date: Tue, 8 Jan 2013 18:34:50 -0500
Message-ID: <1357688156-25387-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Jayaraman <sjayaraman@suse.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4708ad6374f07cdfb379c5d4100125e2cfd339d9 in v2.6.32.x stable

The stable release 2.6.32.32 added the upstream commit
12fed00de963433128b5366a21a55808fab2f756. However, one of the hunks of
the original patch seems missing from the stable backport which can be
found here:
   http://permalink.gmane.org/gmane.linux.kernel.stable/5676

This hunk corresponds to the change in is_valid_oplock_break() at
fs/cifs/misc.c.

This patch backports the missing hunk and is against
linux-2.6.32.y stable kernel.

Cc: Steve French <sfrench@us.ibm.com>
Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[PG: I incorrectly dropped the same hunk in v2.6.34.9-152-g0c55f20
 since the code in question was relocated/rewritten in e66673e39a ]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/misc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d147499..ec208e6 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -584,6 +584,9 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				pCifsInode->clientCanCacheAll = false;
 				if (pSMB->OplockLevel == 0)
 					pCifsInode->clientCanCacheRead = false;
+				else if (pSMB->OplockLevel)
+					pCifsInode->clientCanCacheRead = true;
+
 				rc = slow_work_enqueue(&netfile->oplock_break);
 				if (rc) {
 					cERROR(1, ("failed to enqueue oplock "
-- 
1.7.12.1

