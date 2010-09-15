Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0IOVvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:51:33 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:49615 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0IOVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:51:31 -0400
Subject: [PATCH] drivers/video/via/ioctl.c: prevent reading uninitialized
 stack memory
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: JosephChan@via.com.tw, ScottFang@viatech.com.cn
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 17:44:19 -0400
Message-ID: <1284587059.6275.101.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VIAFB_GET_INFO device ioctl allows unprivileged users to read 1968
bytes of uninitialized stack memory, because the "reserved" member of
the viafb_ioctl_info struct declared on the stack is not altered or
zeroed before being copied back to the user.  This patch takes care of
it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/drivers/video/via/ioctl.c	2010-08-26 19:47:12.000000000 -0400
+++ linux-2.6.35.4/drivers/video/via/ioctl.c	2010-09-15 11:53:29.997375748 -0400
@@ -25,6 +25,8 @@ int viafb_ioctl_get_viafb_info(u_long ar
 {
 	struct viafb_ioctl_info viainfo;
 
+	memset(&viainfo, 0, sizeof(struct viafb_ioctl));
+
 	viainfo.viafb_id = VIAID;
 	viainfo.vendor_id = PCI_VIA_VENDOR_ID;
 



