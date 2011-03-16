Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1CPRLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:11:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1CPRLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:11:21 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] dlm: increase default hash table sizes
Date: Wed, 16 Mar 2011 11:42:02 -0500
Message-Id: <1300293723-29693-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make all three hash tables a consistent size of 1024
rather than 1024, 512, 256.  All three tables, for
resources, locks, and lock dir entries, will generally
be filled to the same order of magnitude.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/config.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index b54bca0..0d329ff 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -977,9 +977,9 @@ int dlm_our_addr(struct sockaddr_storage *addr, int num)
 /* Config file defaults */
 #define DEFAULT_TCP_PORT       21064
 #define DEFAULT_BUFFER_SIZE     4096
-#define DEFAULT_RSBTBL_SIZE      256
+#define DEFAULT_RSBTBL_SIZE     1024
 #define DEFAULT_LKBTBL_SIZE     1024
-#define DEFAULT_DIRTBL_SIZE      512
+#define DEFAULT_DIRTBL_SIZE     1024
 #define DEFAULT_RECOVER_TIMER      5
 #define DEFAULT_TOSS_SECS         10
 #define DEFAULT_SCAN_SECS          5
-- 
1.7.1.1

