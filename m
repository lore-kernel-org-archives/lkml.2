Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1CUKTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:19:37 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44306 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1CUKTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:32 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 2/9] [media] vp702x: rename struct vp702x_state -> vp702x_adapter_state
Date: Mon, 21 Mar 2011 11:19:07 +0100
Message-Id: <1300702754-16376-3-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300702754-16376-1-git-send-email-florian@mickler.org>
References: <1300702754-16376-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a state struct for the dvb_usb_device.
In order to reduce confusion we rename the vp702x_state struct.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp702x.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 4c9939f..25536f9 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -23,7 +23,7 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DV
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-struct vp702x_state {
+struct vp702x_adapter_state {
 	int pid_filter_count;
 	int pid_filter_can_bypass;
 	u8  pid_filter_state;
@@ -126,7 +126,7 @@ static int vp702x_set_pld_state(struct dvb_usb_adapter *adap, u8 state)
 
 static int vp702x_set_pid(struct dvb_usb_adapter *adap, u16 pid, u8 id, int onoff)
 {
-	struct vp702x_state *st = adap->priv;
+	struct vp702x_adapter_state *st = adap->priv;
 	u8 buf[16] = { 0 };
 
 	if (onoff)
@@ -147,7 +147,7 @@ static int vp702x_set_pid(struct dvb_usb_adapter *adap, u16 pid, u8 id, int onof
 
 static int vp702x_init_pid_filter(struct dvb_usb_adapter *adap)
 {
-	struct vp702x_state *st = adap->priv;
+	struct vp702x_adapter_state *st = adap->priv;
 	int i;
 	u8 b[10] = { 0 };
 
@@ -279,7 +279,7 @@ static struct dvb_usb_device_properties vp702x_properties = {
 					}
 				}
 			},
-			.size_of_priv     = sizeof(struct vp702x_state),
+			.size_of_priv     = sizeof(struct vp702x_adapter_state),
 		}
 	},
 	.read_mac_address = vp702x_read_mac_addr,
-- 
1.7.4.1

