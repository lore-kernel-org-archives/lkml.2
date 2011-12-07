Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab1LGRER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:04:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523Ab1LGREH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:04:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:56:02 2011
Message-Id: <20111207165602.151282904@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:54:54 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@us.ibm.com>,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Suresh Jayaraman <sjayaraman@suse.com>
Subject: [21/27] cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Suresh Jayaraman <sjayaraman@suse.com>

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

---
 fs/cifs/misc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -584,6 +584,9 @@ is_valid_oplock_break(struct smb_hdr *bu
 				pCifsInode->clientCanCacheAll = false;
 				if (pSMB->OplockLevel == 0)
 					pCifsInode->clientCanCacheRead = false;
+				else if (pSMB->OplockLevel)
+					pCifsInode->clientCanCacheRead = true;
+
 				rc = slow_work_enqueue(&netfile->oplock_break);
 				if (rc) {
 					cERROR(1, ("failed to enqueue oplock "


