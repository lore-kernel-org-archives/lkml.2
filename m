Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2BFHKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:10:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:50088 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2BFHKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:10:50 -0500
From: Hui Wang <jason77.wang@gmail.com>
To: <mchehab@redhat.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony.luck@intel.com>
Subject: [PATCH 3/3] edac: sb_edac: Fix a wrong value setting for the
Date: Mon, 6 Feb 2012 15:11:01 +0800
Message-ID: <1328512261-19896-4-git-send-email-jason77.wang@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1328512261-19896-3-git-send-email-jason77.wang@gmail.com>
References: <1328512261-19896-1-git-send-email-jason77.wang@gmail.com>
 <1328512261-19896-2-git-send-email-jason77.wang@gmail.com>
 <1328512261-19896-3-git-send-email-jason77.wang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the driver design, the variable limit wants to compare with its
previous value, we should set the value of limit instead of the value
of tmp_mb to the variable prev.

Signed-off-by: Hui Wang <jason77.wang@gmail.com>
---
 drivers/edac/sb_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index f84a515..178093f 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -757,7 +757,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 			(u32)TAD_TGT2(reg),
 			(u32)TAD_TGT3(reg),
 			reg);
-		prv = tmp_mb;
+		prv = limit;
 	}
 
 	/*
-- 
1.7.6

