Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2ETI3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 04:29:18 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.1.3]:50860 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043Ab2ETI3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 04:29:08 -0400
X-Greylist: delayed 66756 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2012 04:29:07 EDT
From: Andrew Bird <ajb@spheresystems.co.uk>
To: bjorn@mork.no
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 1/3] USB: qmi_wwan: Make forced int 4 whitelist generic
Date: Sun, 20 May 2012 09:28:36 +0100
Message-Id: <1337502518-1444-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.5.4
X-Originating-Smarthost03-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the forced interface 4 whitelist to use the generic shared
binder instead of the Gobi specific one. Certain ZTE devices
(K3520-Z & K3765-Z) don't work with the Gobi version, but function
quite happily with the generic. This has been tested with the following
devices:
K3520-Z
K3565-Z
K3765-Z
K4505-Z
It hasn't been tested with the ZTE MF820D, which is the only other
device that uses this whitelist at present. Although Bjorn doesn't
expect any problems, any testing with that device would be appreciated.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/net/usb/qmi_wwan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d316503b..62a1a43 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -357,9 +357,9 @@ static const struct driver_info	qmi_wwan_gobi = {
 
 /* ZTE suck at making USB descriptors */
 static const struct driver_info	qmi_wwan_force_int4 = {
-	.description	= "Qualcomm Gobi wwan/QMI device",
+	.description	= "Qualcomm WWAN/QMI device",
 	.flags		= FLAG_WWAN,
-	.bind		= qmi_wwan_bind_gobi,
+	.bind		= qmi_wwan_bind_shared,
 	.unbind		= qmi_wwan_unbind_shared,
 	.manage_power	= qmi_wwan_manage_power,
 	.data		= BIT(4), /* interface whitelist bitmap */
-- 
1.7.5.4

