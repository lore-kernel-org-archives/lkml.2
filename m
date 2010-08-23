Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab0HWAhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 20:37:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab0HWAhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 20:37:25 -0400
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Andreas Dilger <adilger@dilger.ca>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/4] fanotify: resize pid and reorder structure
Date: Sun, 22 Aug 2010 20:37:09 -0400
Message-Id: <1282523830-27751-3-git-send-email-eparis@redhat.com>
In-Reply-To: <1282523830-27751-2-git-send-email-eparis@redhat.com>
References: <1282523830-27751-1-git-send-email-eparis@redhat.com>
 <1282523830-27751-2-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>

resize pid and reorder the fanotify_event_metadata so it is naturally
aligned and we can work towards dropping the packed attributed

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 include/linux/fanotify.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 9854356..0535461 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -70,9 +70,9 @@
 struct fanotify_event_metadata {
 	__u32 event_len;
 	__u32 vers;
-	__s32 fd;
 	__u64 mask;
-	__s64 pid;
+	__s32 fd;
+	__s32 pid;
 } __attribute__ ((packed));
 
 struct fanotify_response {
-- 
1.6.5.3

