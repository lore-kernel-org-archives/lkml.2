Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2BCWFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:05:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2BCWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:05:16 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TRgVYD6ZyiEA:10 a=JPAMeckE3gIA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=Br9LfDWDAAAA:8 a=yQdBAQUQAAAA:8 a=ENDg0BzhAAAA:8 a=0kfPXhj2sIOgl_UdjV0A:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Fri, 03 Feb 2012 16:05:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: r8712u: Fix problem when CONFIG_R8712_AP is set
Message-ID: <4f2c5a19.QjadJQo4AjFmGNIm%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When this driver was upgraded to the vendor 20100831 version in
commit 93c55dda092c7 et al,, one listhead initialization was missed.
This broke complete operation of the driver whenever AP mode was
enabled.

This patch fixes https://bugs.archlinux.org/task/27996.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.stable.org>
---

Index: staging/drivers/staging/rtl8712/rtl871x_sta_mgt.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ staging/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -43,6 +43,7 @@ static void _init_stainfo(struct sta_inf
 	_r8712_init_sta_xmit_priv(&psta->sta_xmitpriv);
 	_r8712_init_sta_recv_priv(&psta->sta_recvpriv);
 #ifdef CONFIG_R8712_AP
+	_init_listhead(&psta->asoc_list);
 	_init_listhead(&psta->auth_list);
 #endif
 }
