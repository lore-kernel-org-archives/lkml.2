Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2G1LqI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 07:46:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:36578 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab2G1LqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 07:46:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="188490764"
Date: Sat, 28 Jul 2012 19:45:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] floppy: remove duplicated flag FD_RAW_NEED_DISK
Message-ID: <20120728114559.GA12184@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coccinelle warning (without behavior change):

drivers/block/floppy.c:2518:32-48: duplicated argument to & or |

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 553f43a..0fcbe14 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2516,8 +2516,7 @@ static int make_raw_rw_request(void)
 	set_fdc((long)current_req->rq_disk->private_data);
 
 	raw_cmd = &default_raw_cmd;
-	raw_cmd->flags = FD_RAW_SPIN | FD_RAW_NEED_DISK | FD_RAW_NEED_DISK |
-	    FD_RAW_NEED_SEEK;
+	raw_cmd->flags = FD_RAW_SPIN | FD_RAW_NEED_DISK | FD_RAW_NEED_SEEK;
 	raw_cmd->cmd_count = NR_RW;
 	if (rq_data_dir(current_req) == READ) {
 		raw_cmd->flags |= FD_RAW_READ;
