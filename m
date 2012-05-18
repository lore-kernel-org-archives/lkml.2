Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab2ERQlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618Ab2ERQdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH EDAC v26 66/66] edac_mc: check for allocation failure in edac_mc_alloc()
Date: Fri, 18 May 2012 13:32:53 -0300
Message-Id: <1337358773-6919-67-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

Add a check here for if kzalloc() failed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 0dfda4c..42937ae 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -354,6 +354,8 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 		}
 
 		dimm = kzalloc(sizeof(**mci->dimms), GFP_KERNEL);
+		if (!dimm)
+			goto error;
 		mci->dimms[off] = dimm;
 		dimm->mci = mci;
 
-- 
1.7.8

