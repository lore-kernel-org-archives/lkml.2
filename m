Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0ISMyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:54:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab0ISMyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BicVUYdEkd2Ro8mfwS6YljlJGprnkEgRHtfZGmXGrG2Lpka86Ly3/g6Qul79qeEsuP
         WSfUpwS86fmqu4WnZJMbTeQnfDB44+wIasm5bs7hGeTkF/GuUCq0XkcfaOagQepIKYWL
         l8WTKbcb7oTfg+q1wf1nuIaFsaYV4OobqLpRc=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: spectra: off by one
Date: Sun, 19 Sep 2010 16:54:40 +0400
Message-Id: <1284900881-24243-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

g_pBlockTable has only DeviceInfo.wDataBlockNum elements.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/staging/spectra/flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/spectra/flash.c b/drivers/staging/spectra/flash.c
index 9b5218b..4e6e451 100644
--- a/drivers/staging/spectra/flash.c
+++ b/drivers/staging/spectra/flash.c
@@ -1604,7 +1604,7 @@ static int get_l2_cache_blks(void)
 
 	for (n = 0; n < BLK_NUM_FOR_L2_CACHE; n++) {
 		blk = find_least_worn_blk_for_l2_cache();
-		if (blk > DeviceInfo.wDataBlockNum) {
+		if (blk >= DeviceInfo.wDataBlockNum) {
 			nand_dbg_print(NAND_DBG_WARN,
 				"find_least_worn_blk_for_l2_cache: "
 				"No enough free NAND blocks (n: %d) for L2 Cache!\n", n);
-- 
1.7.0.4

