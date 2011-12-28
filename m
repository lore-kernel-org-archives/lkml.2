Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1L1D4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 22:56:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57915 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab1L1D4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 22:56:49 -0500
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
Cc: <jaxboe@fusionio.com>, <hch@lst.de>, <tj@kernel.org>
Subject: [PATCH] Documentation: drop stale I/O barrier descriptions
Date: Wed, 28 Dec 2011 11:53:36 +0800
Message-Id: <1325044416-12580-1-git-send-email-liubo2009@cn.fujitsu.com>
X-Mailer: git-send-email 1.6.5.2
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-28 11:55:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-28 11:55:59,
	Serialize complete at 2011-12-28 11:55:59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for double mails, missing to cc LKML...
===

Since we've applied writeback_cache_control.txt and removed barrier.txt,
drop the related descriptions in biodoc.txt.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 Documentation/block/biodoc.txt |   21 ++-------------------
 1 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index e418dc0..2ce818f 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -48,8 +48,7 @@ Description of Contents:
 	- Highmem I/O support
 	- I/O scheduler modularization
   1.2 Tuning based on high level requirements/capabilities
-	1.2.1 I/O Barriers
-	1.2.2 Request Priority/Latency
+	1.2.1 Request Priority/Latency
   1.3 Direct access/bypass to lower layers for diagnostics and special
       device operations
 	1.3.1 Pre-built commands
@@ -261,23 +260,7 @@ unused). As far as user applications are concerned they would need an
 additional mechanism either via open flags or ioctls, or some other upper
 level mechanism to communicate such settings to block.
 
-1.2.1 I/O Barriers
-
-There is a way to enforce strict ordering for i/os through barriers.
-All requests before a barrier point must be serviced before the barrier
-request and any other requests arriving after the barrier will not be
-serviced until after the barrier has completed. This is useful for higher
-level control on write ordering, e.g flushing a log of committed updates
-to disk before the corresponding updates themselves.
-
-A flag in the bio structure, BIO_BARRIER is used to identify a barrier i/o.
-The generic i/o scheduler would make sure that it places the barrier request and
-all other requests coming after it after all the previous requests in the
-queue. Barriers may be implemented in different ways depending on the
-driver. For more details regarding I/O barriers, please read barrier.txt
-in this directory.
-
-1.2.2 Request Priority/Latency
+1.2.1 Request Priority/Latency
 
 Todo/Under discussion:
 Arjan's proposed request priority scheme allows higher levels some broad
-- 
1.6.5.2

