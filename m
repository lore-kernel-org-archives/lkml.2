Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab0JYWcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:32:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38759 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab0JYWcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:32:15 -0400
From: Andi Kleen <andi@firstfloor.org>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, keyrings@linux-nfs.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Fix install_process_keyring error handling
Date: Tue, 26 Oct 2010 00:31:58 +0200
Message-Id: <1288045918-25233-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fix incorrect error check that returns 1 for error
instead of the expected error code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 security/keys/process_keys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index f8e7251..504bdd2 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -207,7 +207,7 @@ static int install_process_keyring(void)
 	ret = install_process_keyring_to_cred(new);
 	if (ret < 0) {
 		abort_creds(new);
-		return ret != -EEXIST ?: 0;
+		return ret != -EEXIST ? ret : 0;
 	}
 
 	return commit_creds(new);
-- 
1.7.1

