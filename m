Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab2JNOxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:53:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46654 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932270Ab2JNOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:48 -0400
Message-Id: <20121014143541.050528990@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 053/147] [SCSI] scsi_dh_alua: Enable STPG for unavailable ports
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit e47f8976d8e573928824a06748f7bc82c58d747f upstream.

A quote from SPC-4: "While in the unavailable primary target port
asymmetric access state, the device server shall support those of
the following commands that it supports while in the active/optimized
state: [ ... ] d) SET TARGET PORT GROUPS; [ ... ]". Hence enable
sending STPG to a target port group that is in the unavailable state.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 08d80a6..6f4d8e6 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -641,8 +641,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 		h->state = TPGS_STATE_STANDBY;
 		break;
 	case TPGS_STATE_OFFLINE:
-	case TPGS_STATE_UNAVAILABLE:
-		/* Path unusable for unavailable/offline */
+		/* Path unusable */
 		err = SCSI_DH_DEV_OFFLINED;
 		break;
 	default:


