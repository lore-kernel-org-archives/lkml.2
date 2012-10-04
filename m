Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946266Ab2JDV0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:26:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56720 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946250Ab2JDV0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:26:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 52/52] SCSI: scsi_dh_alua: Enable STPG for unavailable ports
Date: Thu,  4 Oct 2012 14:21:43 -0700
Message-Id: <20121004210641.919146687@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/device_handler/scsi_dh_alua.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -583,8 +583,7 @@ static int alua_rtpg(struct scsi_device
 		h->state = TPGS_STATE_STANDBY;
 		break;
 	case TPGS_STATE_OFFLINE:
-	case TPGS_STATE_UNAVAILABLE:
-		/* Path unusable for unavailable/offline */
+		/* Path unusable */
 		err = SCSI_DH_DEV_OFFLINED;
 		break;
 	default:


