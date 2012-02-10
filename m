Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2BJAE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:04:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717Ab2BJABj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 22/31] amd64_edac: convert it to use the MCE log tracepoint where applicable
Date: Thu,  9 Feb 2012 22:01:21 -0200
Message-Id: <1328832090-9166-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all families supported by amd64_edac use MCE for errors.
Whenever mcelog is used, pass it to EDAC core, in order to generate
the mixed MCE/memory trace events.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 1b374b5..aa7ecbb 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1904,7 +1904,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 				     -1, -1, -1,
 				     EDAC_MOD_STR,
 				     "HW has no ERROR_ADDRESS available",
-				     NULL);
+				     m);
 		return;
 	}
 
@@ -1933,7 +1933,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 				     -1, -1, -1,
 				     EDAC_MOD_STR,
 				     "HW has no ERROR_ADDRESS available",
-				     NULL);
+				     m);
 		return;
 	}
 
@@ -1952,7 +1952,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 				     page, offset, 0,
 				     -1, -1, -1,
 				     EDAC_MOD_STR,
-				     "ERROR ADDRESS NOT mapped to a MC", NULL);
+				     "ERROR ADDRESS NOT mapped to a MC", m);
 		return;
 	}
 
@@ -1967,12 +1967,12 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 				     -1, -1, -1,
 				     EDAC_MOD_STR,
 				     "ERROR ADDRESS NOT mapped to CS",
-				     NULL);
+				     m);
 	} else {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
 				     csrow, -1, -1,
-				     EDAC_MOD_STR, "", NULL);
+				     EDAC_MOD_STR, "", m);
 	}
 }
 
-- 
1.7.8

