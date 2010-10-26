Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab0JZKVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:21:41 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60730 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab0JZKSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:17 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/14] drivers/staging: delete double assignment
Date: Tue, 26 Oct 2010 12:25:30 +0200
Message-Id: <1288088743-3725-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.  In three of the cases,
the two assignments are identical.  In the case of the file
rt2860/common/cmm_aes.c, the assigned variable i is never used, so both
assignments are dropped.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c     |    1 -
 drivers/staging/hv/hv_utils.c                        |    3 ---
 drivers/staging/rt2860/common/cmm_aes.c              |    2 --
 drivers/staging/westbridge/astoria/api/src/cyasusb.c |    1 -
 4 files changed, 7 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 87a6487..20d5098 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -286,7 +286,6 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
     pid = kernel_thread (exec_mknod, (void *)info, 0);
 
     // initialize application information
-    info->appcnt = 0;
 
 //    if (ft1000_flarion_cnt == 0) {
 //
diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index 702a478..a99e900 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -212,9 +212,6 @@ static void heartbeat_onchannelcallback(void *context)
 			   recvlen, requestid);
 
 		icmsghdrp = (struct icmsg_hdr *)&buf[
-			sizeof(struct vmbuspipe_hdr)];
-
-		icmsghdrp = (struct icmsg_hdr *)&buf[
 				sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
diff --git a/drivers/staging/rt2860/common/cmm_aes.c b/drivers/staging/rt2860/common/cmm_aes.c
index 1d159ff..a99879b 100644
--- a/drivers/staging/rt2860/common/cmm_aes.c
+++ b/drivers/staging/rt2860/common/cmm_aes.c
@@ -330,8 +330,6 @@ void construct_mic_iv(unsigned char *mic_iv,
 	for (i = 8; i < 14; i++)
 		mic_iv[i] = pn_vector[13 - i];	/* mic_iv[8:13] = PN[5:0] */
 #endif
-	i = (payload_length / 256);
-	i = (payload_length % 256);
 	mic_iv[14] = (unsigned char)(payload_length / 256);
 	mic_iv[15] = (unsigned char)(payload_length % 256);
 
diff --git a/drivers/staging/westbridge/astoria/api/src/cyasusb.c b/drivers/staging/westbridge/astoria/api/src/cyasusb.c
index 5a21970..7777d9a 100644
--- a/drivers/staging/westbridge/astoria/api/src/cyasusb.c
+++ b/drivers/staging/westbridge/astoria/api/src/cyasusb.c
@@ -1417,7 +1417,6 @@ cy_as_usb_set_enum_config(cy_as_device_handle handle,
 	 */
 	bus_mask   = 0;
 	media_mask = 0;
-	media_mask = 0;
 	for (bus = 0; bus < CY_AS_MAX_BUSES; bus++) {
 		for (device = 0; device < CY_AS_MAX_STORAGE_DEVICES; device++) {
 			if (config_p->devices_to_enumerate[bus][device] ==

