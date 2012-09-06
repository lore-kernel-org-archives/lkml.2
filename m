Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab2IFEgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 00:36:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40019 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2IFEgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 00:36:49 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 12:36:49 +0800
Message-ID: <CAPgLHd9rrd2smE9vFO+re7EpMT6_6JBbD7VrU=yx9_3mnR28Ww@mail.gmail.com>
Subject: [PATCH] staging: gdm72xx: use list_move instead of list_del/list_add
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move() instead of list_del() + list_add().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/gdm72xx/gdm_usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index d48d49c..b74442f 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -189,8 +189,7 @@ static struct usb_rx *get_rx_struct(struct rx_cxt *rx)
 /* Before this function is called, spin lock should be locked. */
 static void put_rx_struct(struct rx_cxt *rx, struct usb_rx *r)
 {
-	list_del(&r->list);
-	list_add(&r->list, &rx->free_list);
+	list_move(&r->list, &rx->free_list);
 }
 
 static int init_usb(struct usbwm_dev *udev)

