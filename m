Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2HOUgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:36:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:36397 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab2HOTtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 018/165] fcaps: clear the same personality flags as suid when fcaps are used
Date: Wed, 15 Aug 2012 15:46:02 -0400
Message-ID: <1345060109-9187-19-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d52fc5dde171f030170a6cb78034d166b13c9445 upstream.

If a process increases permissions using fcaps all of the dangerous
personality flags which are cleared for suid apps should also be cleared.
Thus programs given priviledge with fcaps will continue to have address space
randomization enabled even if the parent tried to disable it to make it
easier to attack.

Signed-off-by: Eric Paris <eparis@redhat.com>
Reviewed-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 security/commoncap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/commoncap.c b/security/commoncap.c
index 3927418..c325d38 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -466,6 +466,11 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 	}
 skip:
 
+	/* if we have fs caps, clear dangerous personality flags */
+	if (!cap_issubset(new->cap_permitted, old->cap_permitted))
+		bprm->per_clear |= PER_CLEAR_ON_SETID;
+
+
 	/* Don't let someone trace a set[ug]id/setpcap binary with the revised
 	 * credentials unless they have the appropriate permit
 	 */
-- 
1.7.12.rc2

