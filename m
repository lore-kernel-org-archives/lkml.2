Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2IEGtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 02:49:22 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36742 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2IEGtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 02:49:15 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 14:49:15 +0800
Message-ID: <CAPgLHd9knKyh2VkUL4D8TWvCZ0nHzMXvQ6Rn7zdkmaXsbcq9OQ@mail.gmail.com>
Subject: [PATCH] staging: gdm72xx: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/gdm72xx/gdm_usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index d48d49c..04820ce 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -180,8 +180,7 @@ static struct usb_rx *get_rx_struct(struct rx_cxt *rx)
 	}
 
 	r = list_entry(rx->free_list.next, struct usb_rx, list);
-	list_del(&r->list);
-	list_add_tail(&r->list, &rx->used_list);
+	list_move_tail(&r->list, &rx->used_list);
 
 	return r;
 }


