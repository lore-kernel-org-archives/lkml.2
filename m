Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab0J1LZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0J1LZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:25:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] Fix install_process_keyring error handling
To: torvalds@osdl.org, akpm@linux-foundation.com
From: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Oct 2010 12:24:24 +0100
Message-ID: <20101028112424.3372.63923.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fix incorrect error check that returns 1 for error
instead of the expected error code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
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

