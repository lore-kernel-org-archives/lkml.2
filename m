Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2K0P2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:28:39 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2K0P2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:28:37 -0500
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH] Smack: prevent revoke-subject from failing when unseen label
 is written to it
Date: Tue, 27 Nov 2012 16:28:11 +0100
Message-id: <1354030091-32501-1-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Special file /smack/revoke-subject will silently accept labels that are not
present on the subject label list. Nothing has to be done for such labels,
as there are no rules for them to revoke.

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smackfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 76a5dca..337e32c 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -2035,10 +2035,8 @@ static ssize_t smk_write_revoke_subj(struct file *file, const char __user *buf,
 	}
 
 	skp = smk_find_entry(cp);
-	if (skp == NULL) {
-		rc = -EINVAL;
+	if (skp == NULL)
 		goto free_out;
-	}
 
 	rule_list = &skp->smk_rules;
 	rule_lock = &skp->smk_rules_lock;
-- 
1.7.10.4

