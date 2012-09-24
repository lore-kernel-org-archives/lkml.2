Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab2IXFai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 01:30:38 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59188 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2IXFag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 01:30:36 -0400
Message-ID: <1348464626.2475.13.camel@ThinkPad-T420>
Subject: [PATCH scsi] Add NULL checking of return value from
 scsi_cmd_to_driver()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 13:30:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12092405-0260-0000-0000-000001E33C09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just noticed that after commit 919f797, it is possible that 
scsi_cmd_to_driver() returns NULL. This patch adds the NULL checking for drv 
returned from the above function. 

Maybe it is not possible at run time, but from the code itself, we'd better
have this check?  

This patch actually is a delta of my previous patch 
[https://lkml.org/lkml/2012/4/11/814] and commit 919f797

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2936b44..b9dd7f0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -832,7 +832,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		int old_good_bytes = good_bytes;
 		drv = scsi_cmd_to_driver(cmd);
-		if (drv->done)
+		if (drv && drv->done)
 			good_bytes = drv->done(cmd);
 		/*
 		 * USB may not give sense identifying bad sector and


