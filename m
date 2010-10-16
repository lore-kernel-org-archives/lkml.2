Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0JPKLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 06:11:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37001 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0JPKLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 06:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bMB9gw5RSRWv98XaEi3/p5mnXKlIuowKVnnyhVBXk48t693sMvrhRxLB7QcgKCGNMH
         ylSG5i00qY1P6a/u+iUhAaabZXe0Hj3I99/7O8/TwOd1CtFsKccJIczy8q8o00DFmva3
         lSAYDO8rTWNxiAtL7K3ewAKHYGqOwhOMCX1I4=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 2/3] staging: wlags49_h2: fix format of timeStamp debug output
Date: Sat, 16 Oct 2010 13:11:11 +0300
Message-Id: <20818eaa96630e8d65ffeda902b88ba8df69fbdc.1287223789.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
References: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
In-Reply-To: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
References: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/wlags49_h2/wl_main.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index dd8ed3d..d0b5062 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -3120,8 +3120,17 @@ void wl_process_mailbox( struct wl_private *lp )
 				//DBG_TRACE( DbgInfo, "(%s) lenType     : 0x%04x.\n",
 				//           lp->dev->name, probe_rsp->lenType );
 
-				DBG_TRACE( DbgInfo, "(%s) timeStamp   : %s\n",
-						   lp->dev->name, DbgHwAddr( probe_rsp->timeStamp ));
+				DBG_TRACE(DbgInfo, "(%s) timeStamp   : "
+						"%d.%d.%d.%d.%d.%d.%d.%d\n",
+						lp->dev->name,
+						probe_rsp->timeStamp[0],
+						probe_rsp->timeStamp[1],
+						probe_rsp->timeStamp[2],
+						probe_rsp->timeStamp[3],
+						probe_rsp->timeStamp[4],
+						probe_rsp->timeStamp[5],
+						probe_rsp->timeStamp[6],
+						probe_rsp->timeStamp[7]);
 
 				DBG_TRACE( DbgInfo, "(%s) beaconInt   : 0x%04x.\n",
 						   lp->dev->name, probe_rsp->beaconInterval );
-- 
1.7.2.3

