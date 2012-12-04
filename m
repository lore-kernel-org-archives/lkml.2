Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab2LDKTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:19:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab2LDKTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:19:17 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, rusty@ozlabs.org
Subject: [PATCH 3/3] MODSIGN: Drop ccache hack
Date: Tue,  4 Dec 2012 11:18:41 +0100
Message-Id: <1354616321-13520-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354616321-13520-1-git-send-email-mmarek@suse.cz>
References: <1354616321-13520-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __TIME__ macro is not needed anymore, because the pubkey is included
in a separate .S file.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 kernel/modsign_pubkey.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
index 045504f..df27eca 100644
--- a/kernel/modsign_pubkey.c
+++ b/kernel/modsign_pubkey.c
@@ -22,12 +22,6 @@ extern __initdata const u8 modsign_certificate_list[];
 extern __initdata const u8 modsign_certificate_list_end[];
 
 /*
- * We need to make sure ccache doesn't cache the .o file as it doesn't notice
- * if modsign.pub changes.
- */
-static __initdata const char annoy_ccache[] = __TIME__ "foo";
-
-/*
  * Load the compiled-in keys
  */
 static __init int module_verify_init(void)
-- 
1.7.10.4

