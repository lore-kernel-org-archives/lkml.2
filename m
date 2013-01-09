Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244Ab3AIVY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:24:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:42613 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933442Ab3AIUjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Diego Calleja <diegocg@gmail.com>, Ping Cheng <pinglinux@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 057/123] Input: wacom - fix touch support for Bamboo Fun CTH-461
Date: Wed,  9 Jan 2013 12:34:56 -0800
Message-Id: <20130109201505.886227815@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Calleja <diegocg@gmail.com>

commit e12b3cecf221644ccab64d7c30a6df58b7630cb0 upstream.

Commit f393ee2b814e3291c12565000210b3cf10aa5c1d forgot to add the
touch_max property for Wacom Bamboo Fun CTH-461/S, ID 056a:00d2.

This broke the touch functionality for that device. This patch,
(done with help of Ping Cheng), adds the correct value and makes
touch work again.

Signed-off-by: Diego Calleja <diegocg@gmail.com>
Reviewed-by: Ping Cheng <pinglinux@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/tablet/wacom_wac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -2034,7 +2034,8 @@ static const struct wacom_features wacom
 	  .touch_max = 2 };
 static const struct wacom_features wacom_features_0xD2 =
 	{ "Wacom Bamboo Craft",   WACOM_PKGLEN_BBFUN,     14720,  9200, 1023,
-	  31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
+	  31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES,
+	  .touch_max = 2 };
 static const struct wacom_features wacom_features_0xD3 =
 	{ "Wacom Bamboo 2FG 6x8", WACOM_PKGLEN_BBFUN,     21648, 13700, 1023,
 	  31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES,


