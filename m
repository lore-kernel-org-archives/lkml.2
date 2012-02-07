Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2BGO0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:26:51 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34154 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2BGO0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:26:48 -0500
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/6] MCE, AMD: Correct some MC0 error types
Date: Tue,  7 Feb 2012 15:26:02 +0100
Message-Id: <1328624767-7956-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1328624767-7956-1-git-send-email-bp@amd64.org>
References: <1328624767-7956-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Use "System Read Data Error" as a more general name for MC0 bus errors
on F15h and update some error definitions.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/edac/mce_amd.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index bd926ea..0ee1c0a 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -255,10 +255,9 @@ static bool f15h_dc_mce(u16 ec, u8 xec)
 	} else if (BUS_ERROR(ec)) {
 
 		if (!xec)
-			pr_cont("during system linefill.\n");
+			pr_cont("System Read Data Error.\n");
 		else
-			pr_cont(" Internal %s condition.\n",
-				((xec == 1) ? "livelock" : "deadlock"));
+			pr_cont(" Internal error condition type %d.\n", xec);
 	} else
 		ret = false;
 
-- 
1.7.8.rc0

