Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab0D3QuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:50:23 -0400
Received: from daytona.panasas.com ([67.152.220.89]:31605 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757639Ab0D3QuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:50:09 -0400
Message-ID: <4BD96188.2030507@panasas.com>
Date: Thu, 29 Apr 2010 13:38:00 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jens Axboe <Jens.Axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] exofs: Fix "add bdi backing to mount session" fall out
References: <201004282059.o3SKx7hG029846@hera.kernel.org> <4BD95E7A.90402@panasas.com>
In-Reply-To: <4BD95E7A.90402@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Apr 2010 10:38:02.0480 (UTC) FILETIME=[0B4F5F00:01CAE788]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patch: add bdi backing to mount session
	(b3d0ab7e60d1865bb6f6a79a77aaba22f2543236)

Has a bug in the placement of the bdi member at
struct exofs_sb_info. The layout member must be kept
last.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/exofs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index 5437327..22721b2 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -85,6 +85,7 @@ struct exofs_sb_info {
 	u32		s_next_generation;	/* next gen # to use          */
 	atomic_t	s_curr_pending;		/* number of pending commands */
 	uint8_t		s_cred[OSD_CAP_LEN];	/* credential for the fscb    */
+	struct 		backing_dev_info bdi;	/* register our bdi with VFS  */
 
 	struct pnfs_osd_data_map data_map;	/* Default raid to use
 						 * FIXME: Needed ?
@@ -93,7 +94,6 @@ struct exofs_sb_info {
 	struct exofs_layout	layout;		/* Default files layout,
 						 * contains the variable osd_dev
 						 * array. Keep last */
-	struct backing_dev_info bdi;
 	struct osd_dev	*_min_one_dev[1];	/* Place holder for one dev   */
 };
 
-- 
1.6.6.1


