Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab2EAPeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:34:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46910 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab2EAPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:34:34 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jj@chaosbits.net, dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging: "rtl8192e/r8192u" typo change ContiuneDiffCount.
Date: Tue,  1 May 2012 08:34:14 -0700
Message-Id: <1335886454-29502-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

As mentioned by jesper juhl, we should probably change ContiuneDiffCount
to ContinueDiffCount. Below you will find the changes to do so.
I have compile tested this and everything builds with the changes, as for testing on the hardware
I am unable to do.


 drivers/staging/rtl8192e/rtl8192e/rtl_core.h |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c   |   20 ++++++++++----------
 drivers/staging/rtl8192u/r8192U.h            |    2 +-
 drivers/staging/rtl8192u/r8192U_dm.c         |   20 ++++++++++----------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
index cebb748..320d5fc 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
@@ -943,7 +943,7 @@ struct r8192_priv {
 	bool		bfsync_processing;
 	u32		rate_record;
 	u32		rateCountDiffRecord;
-	u32		ContiuneDiffCount;
+	u32		ContinueDiffCount;
 	bool		bswitch_fsync;
 	u8		framesync;
 	u32		framesyncC34;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index 2dfb0f0..481b1e4 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -2615,22 +2615,22 @@ void dm_fsync_timer_callback(unsigned long data)
 				      rate_count_diff;
 			if (DiffNum >=
 			    priv->rtllib->fsync_seconddiff_ratethreshold)
-				priv->ContiuneDiffCount++;
+				priv->ContinueDiffCount++;
 			else
-				priv->ContiuneDiffCount = 0;
+				priv->ContinueDiffCount = 0;
 
-			if (priv->ContiuneDiffCount >= 2) {
+			if (priv->ContinueDiffCount >= 2) {
 				bSwitchFromCountDiff = true;
-				priv->ContiuneDiffCount = 0;
+				priv->ContinueDiffCount = 0;
 			}
 		} else {
-			priv->ContiuneDiffCount = 0;
+			priv->ContinueDiffCount = 0;
 		}
 
 		if (rate_count_diff <=
 		    priv->rtllib->fsync_firstdiff_ratethreshold) {
 			bSwitchFromCountDiff = true;
-			priv->ContiuneDiffCount = 0;
+			priv->ContinueDiffCount = 0;
 		}
 		priv->rate_record = rate_count;
 		priv->rateCountDiffRecord = rate_count_diff;
@@ -2677,10 +2677,10 @@ void dm_fsync_timer_callback(unsigned long data)
 			write_nic_byte(dev, 0xC36, 0x5c);
 			write_nic_byte(dev, 0xC3e, 0x96);
 		}
-		priv->ContiuneDiffCount = 0;
+		priv->ContinueDiffCount = 0;
 		write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c52cd);
 	}
-	RT_TRACE(COMP_HALDM, "ContiuneDiffCount %d\n", priv->ContiuneDiffCount);
+	RT_TRACE(COMP_HALDM, "ContinueDiffCount %d\n", priv->ContinueDiffCount);
 	RT_TRACE(COMP_HALDM, "rateRecord %d rateCount %d, rateCountdiff %d "
 		 "bSwitchFsync %d\n", priv->rate_record, rate_count,
 		 rate_count_diff, priv->bswitch_fsync);
@@ -2723,7 +2723,7 @@ static void dm_EndSWFsync(struct net_device *dev)
 		write_nic_byte(dev, 0xC3e, 0x96);
 	}
 
-	priv->ContiuneDiffCount = 0;
+	priv->ContinueDiffCount = 0;
 	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c52cd);
 }
 
@@ -2735,7 +2735,7 @@ static void dm_StartSWFsync(struct net_device *dev)
 
 	RT_TRACE(COMP_HALDM, "%s\n", __func__);
 	priv->rate_record = 0;
-	priv->ContiuneDiffCount = 0;
+	priv->ContinueDiffCount = 0;
 	priv->rateCountDiffRecord = 0;
 	priv->bswitch_fsync  = false;
 
diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index b4e99f4..57e3383 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -1116,7 +1116,7 @@ typedef struct r8192_priv
 	bool bfsync_processing;	// 500ms Fsync timer is active or not
 	u32 	rate_record;
 	u32 	rateCountDiffRecord;
-	u32	ContiuneDiffCount;
+	u32	ContinueDiffCount;
 	bool bswitch_fsync;
 
 	u8	framesync;
diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index 996e658..cd8dc85 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -3379,28 +3379,28 @@ extern void dm_fsync_timer_callback(unsigned long data)
 			u32 DiffNum = priv->rateCountDiffRecord - rate_count_diff;
 			// Continue count
 			if(DiffNum >= priv->ieee80211->fsync_seconddiff_ratethreshold)
-				priv->ContiuneDiffCount++;
+				priv->ContinueDiffCount++;
 			else
-				priv->ContiuneDiffCount = 0;
+				priv->ContinueDiffCount = 0;
 
 			// Continue count over
-			if(priv->ContiuneDiffCount >=2)
+			if(priv->ContinueDiffCount >=2)
 			{
 				bSwitchFromCountDiff = true;
-				priv->ContiuneDiffCount = 0;
+				priv->ContinueDiffCount = 0;
 			}
 		}
 		else
 		{
 			// Stop the continued count
-			priv->ContiuneDiffCount = 0;
+			priv->ContinueDiffCount = 0;
 		}
 
 		//If Count diff <= FsyncRateCountThreshold
 		if(rate_count_diff <= priv->ieee80211->fsync_firstdiff_ratethreshold)
 		{
 			bSwitchFromCountDiff = true;
-			priv->ContiuneDiffCount = 0;
+			priv->ContinueDiffCount = 0;
 		}
 		priv->rate_record = rate_count;
 		priv->rateCountDiffRecord = rate_count_diff;
@@ -3468,14 +3468,14 @@ extern void dm_fsync_timer_callback(unsigned long data)
 		#endif
 			write_nic_byte(dev, 0xC3e, 0x96);
 		}
-		priv->ContiuneDiffCount = 0;
+		priv->ContinueDiffCount = 0;
 	#ifdef RTL8190P
 		write_nic_dword(dev, rOFDM0_RxDetector2, 0x164052cd);
 	#else
 		write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c52cd);
 	#endif
 	}
-	RT_TRACE(COMP_HALDM, "ContiuneDiffCount %d\n", priv->ContiuneDiffCount);
+	RT_TRACE(COMP_HALDM, "ContinueDiffCount %d\n", priv->ContinueDiffCount);
 	RT_TRACE(COMP_HALDM, "rateRecord %d rateCount %d, rateCountdiff %d bSwitchFsync %d\n", priv->rate_record, rate_count, rate_count_diff , priv->bswitch_fsync);
 }
 
@@ -3507,7 +3507,7 @@ static void dm_EndSWFsync(struct net_device *dev)
 		write_nic_byte(dev, 0xC3e, 0x96);
 	}
 
-	priv->ContiuneDiffCount = 0;
+	priv->ContinueDiffCount = 0;
 #ifndef RTL8190P
 	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c52cd);
 #endif
@@ -3524,7 +3524,7 @@ static void dm_StartSWFsync(struct net_device *dev)
 	// Initial rate record to zero, start to record.
 	priv->rate_record = 0;
 	// Initialize continue diff count to zero, start to record.
-	priv->ContiuneDiffCount = 0;
+	priv->ContinueDiffCount = 0;
 	priv->rateCountDiffRecord = 0;
 	priv->bswitch_fsync  = false;
 
-- 
1.7.5.4

