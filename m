Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0JOMfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:35:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58863 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0JOMfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I46dhHn/+NYUNv3GpWkxpBzf8bc0vaH6C33XV3yRN2GfL1xMok9ZFJ0awD3KDT+WFP
         XACjXWgfJgt+vMACt2gAeuhBMBtjdtZRHL0wBKxdbuU7trn3H2Y3wsBiSXXVflBah4FL
         g3pU8KFSASzq/93JTQHun+GVQmSlF4bt2zR7Y=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 3/7] staging:ft1000: Remove APP_INFO_BLOCK typedef usage.
Date: Fri, 15 Oct 2010 14:13:00 +0200
Message-Id: <1287144784-3359-3-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
References: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |   27 +++++++++++------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 200f3c0..3fce7f6 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -77,19 +77,18 @@ struct dsp_init_msg {
 } __attribute__ ((packed));
 
 
-typedef struct _APP_INFO_BLOCK
-{
-    u32 nTxMsg;                    // DPRAM msg sent to DSP with app_id
-    u32 nRxMsg;                    // DPRAM msg rcv from dsp with app_id
-    u32 nTxMsgReject;              // DPRAM msg rejected due to DSP doorbell set
-    u32 nRxMsgMiss;                // DPRAM msg dropped due to overflow
-    struct fown_struct *fileobject;// Application's file object
-    u16 app_id;                    // Application id
-    int DspBCMsgFlag;
-    int NumOfMsg;                   // number of messages queued up
-    wait_queue_head_t	wait_dpram_msg;
-    struct list_head app_sqlist;   // link list of msgs for applicaton on slow queue
-} APP_INFO_BLOCK, *PAPP_INFO_BLOCK;
+struct app_info_block {
+	u32 nTxMsg;                    // DPRAM msg sent to DSP with app_id
+	u32 nRxMsg;                    // DPRAM msg rcv from dsp with app_id
+	u32 nTxMsgReject;              // DPRAM msg rejected due to DSP doorbell set
+	u32 nRxMsgMiss;                // DPRAM msg dropped due to overflow
+	struct fown_struct *fileobject;// Application's file object
+	u16 app_id;                    // Application id
+	int DspBCMsgFlag;
+	int NumOfMsg;                   // number of messages queued up
+	wait_queue_head_t wait_dpram_msg;
+	struct list_head app_sqlist;   // link list of msgs for applicaton on slow queue
+} __attribute__((packed));
 
 typedef struct _PROV_RECORD {
     struct list_head list;
@@ -582,7 +581,7 @@ typedef struct _FT1000_INFO {
     u16 ProgConStat;
     struct list_head prov_list;
     int appcnt;
-    APP_INFO_BLOCK app_info[MAX_NUM_APP]; //Added by Jim
+	struct app_info_block app_info[MAX_NUM_APP];
     u16 DSPInfoBlklen;
     u16 DrvMsgPend;
     int (*ft1000_reset)(struct net_device *dev);
-- 
1.7.1

