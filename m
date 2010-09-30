Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab0I3TCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:02:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42755 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab0I3TCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:02:03 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 2/3] drivers:staging:ti-st: drop the __KERNEL__
Date: Thu, 30 Sep 2010 16:13:29 -0400
Message-Id: <1285877610-3043-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1285877610-3043-2-git-send-email-pavan_savoy@ti.com>
References: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
 <1285877610-3043-2-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

ti_wilink_st.h had the line discipline number which the user-space
daemon refers to, to install and un-install the line discipline upon
request from the shared transport driver via rfkill device.

On moving this line discipline number to standard location of tty.h
drop the __KERNEL__ flag in the header, since the header file would
no longer be used by user-space.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/ti_wilink_st.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ti-st/ti_wilink_st.h b/drivers/staging/ti-st/ti_wilink_st.h
index afb0cc6..2a5acf5 100644
--- a/drivers/staging/ti-st/ti_wilink_st.h
+++ b/drivers/staging/ti-st/ti_wilink_st.h
@@ -25,7 +25,6 @@
 #ifndef TI_WILINK_ST_H
 #define TI_WILINK_ST_H
 
-#ifdef __KERNEL__
 /**
  * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
  *	gpio states for their chip/core enable gpios
@@ -400,5 +399,4 @@ struct gps_event_hdr {
 	u16 plen;
 } __attribute__ ((packed));
 
-#endif /* __KERNEL__ */
 #endif /* TI_WILINK_ST_H */
-- 
1.6.5

