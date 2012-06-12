Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab2FLNZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:25:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab2FLNXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:23:41 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 1/5] amd64_edac: Don't pass driver name as an error parameter
Date: Tue, 12 Jun 2012 10:23:27 -0300
Message-Id: <075f30901e32feefd3641e6c5537611fd7e27b59.1339507095.git.mchehab@redhat.com>
In-Reply-To: <cover.1339507094.git.mchehab@redhat.com>
References: <cover.1339507094.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EDAC driver name doesn't help to handle EDAC errors. So,
remove it from the EDAC error messages, preserving only the
error_message.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b475295..811d3e8 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1049,8 +1049,8 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offset, syndrome,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "failed to map error addr to a node",
+				     "",
 				     NULL);
 		return;
 	}
@@ -1061,8 +1061,8 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offset, syndrome,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "failed to map error addr to a csrow",
+				     "",
 				     NULL);
 		return;
 	}
@@ -1082,8 +1082,8 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 					     page, offset, syndrome,
 					     csrow, -1, -1,
-					     EDAC_MOD_STR,
 					     "unknown syndrome - possible error reporting race",
+					     "",
 					     NULL);
 			return;
 		}
@@ -1102,7 +1102,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
 			     page, offset, syndrome,
 			     csrow, channel, -1,
-			     EDAC_MOD_STR, "", NULL);
+			     "", "", NULL);
 }
 
 static int ddr2_cs_size(unsigned i, bool dct_width)
@@ -1614,8 +1614,8 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offset, syndrome,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "failed to map error addr to a csrow",
+				     "",
 				     NULL);
 		return;
 	}
@@ -1631,7 +1631,7 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 			     page, offset, syndrome,
 			     csrow, chan, -1,
-			     EDAC_MOD_STR, "", NULL);
+			     "", "", NULL);
 }
 
 /*
@@ -1916,8 +1916,8 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     0, 0, 0,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "HW has no ERROR_ADDRESS available",
+				     "",
 				     NULL);
 		return;
 	}
@@ -1945,8 +1945,8 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     0, 0, 0,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "HW has no ERROR_ADDRESS available",
+				     "",
 				     NULL);
 		return;
 	}
@@ -1965,8 +1965,9 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
-				     "ERROR ADDRESS NOT mapped to a MC", NULL);
+				     "ERROR ADDRESS NOT mapped to a MC",
+				     "",
+				     NULL);
 		return;
 	}
 
@@ -1979,14 +1980,14 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "ERROR ADDRESS NOT mapped to CS",
+				     "",
 				     NULL);
 	} else {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
 				     csrow, -1, -1,
-				     EDAC_MOD_STR, "", NULL);
+				     "", "", NULL);
 	}
 }
 
-- 
1.7.10.2

