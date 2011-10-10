Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1JJL35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:29:57 -0400
Received: from mga06.intel.com ([134.134.136.21]:8584 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753645Ab1JJL3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:29:55 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] Smack: fix for /smack/access output, use string instead of byte
Date: Mon, 10 Oct 2011 14:29:28 +0300
Message-Id: <1318246168-26660-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small fix for the output of access SmackFS file. Use string
is instead of byte. Makes it easier to extend API if it is
needed.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 security/smack/smackfs.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 54f6e18..5498c4a 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -1497,6 +1497,7 @@ static ssize_t smk_write_access(struct file *file, const char __user *buf,
 {
 	struct smack_rule rule;
 	char *data;
+	int res;
 
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
@@ -1508,8 +1509,10 @@ static ssize_t smk_write_access(struct file *file, const char __user *buf,
 	if (count < SMK_LOADLEN || smk_parse_rule(data, &rule))
 		return -EINVAL;
 
-	data[0] = smk_access(rule.smk_subject, rule.smk_object,
-			     rule.smk_access, NULL) == 0;
+	res = smk_access(rule.smk_subject, rule.smk_object, rule.smk_access,
+			  NULL);
+	data[0] = res == 0 ? '1' : '0';
+	data[1] = '\0';
 
 	simple_transaction_set(file, 1);
 	return SMK_LOADLEN;
-- 
1.7.4.1

