Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2HSDAT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:3185 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab2HSC50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415460"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 58/74] lto, workaround: Work around LTO compiler problem in atheros driver
Date: Sat, 18 Aug 2012 19:56:54 -0700
Message-Id: <1345345030-22211-59-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Making these symbols visible works around a gcc 4.7 LTO compiler
problem with missing symbols.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
index ea2a6cf..83c579a 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
@@ -51,7 +51,7 @@ struct radar_types {
 }
 
 /* radar types as defined by ETSI EN-301-893 v1.5.1 */
-static const struct radar_detector_specs etsi_radar_ref_types_v15[] = {
+__visible const struct radar_detector_specs etsi_radar_ref_types_v15[] = {
 	ETSI_PATTERN(0,  0,  1,  700,  700, 1, 18),
 	ETSI_PATTERN(1,  0,  5,  200, 1000, 1, 10),
 	ETSI_PATTERN(2,  0, 15,  200, 1600, 1, 15),
-- 
1.7.7.6

