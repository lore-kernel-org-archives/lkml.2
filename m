Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab2KEEql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 23:46:41 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56280 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2KEEqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 23:46:40 -0500
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "harvey.yang" <harvey.huawei.yang@gmail.com>
Subject: [PATCH 1/1] staging: usbip: remove an unnecessary lock in usbip_event_happened. The variable "happened" is local. So I think there is no need to lock here.
Date: Mon,  5 Nov 2012 12:50:26 +0800
Message-Id: <1352091026-5441-1-git-send-email-huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: harvey.yang <harvey.huawei.yang@gmail.com>


Signed-off-by: harvey.yang <harvey.huawei.yang@gmail.com>
---
 drivers/staging/usbip/usbip_event.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
index d332a34..668f8e0 100644
--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -116,10 +116,8 @@ int usbip_event_happened(struct usbip_device *ud)
 {
 	int happened = 0;
 
-	spin_lock(&ud->lock);
 	if (ud->event != 0)
 		happened = 1;
-	spin_unlock(&ud->lock);
 
 	return happened;
 }
-- 
1.7.1

