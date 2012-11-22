Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2KWFqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 00:46:14 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56739 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2KWFqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 00:46:11 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] USB: chipidea: promote error code from ci_role_start() start instead of returning -ENODEV
Date: Thu, 22 Nov 2012 10:11:31 +0100
Message-Id: <1353575491-23976-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/chipidea/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index b726c49..bd6e7a4 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -479,7 +479,6 @@ static int __devinit ci_hdrc_probe(struct platform_device *pdev)
 	ret = ci_role_start(ci, ci->role);
 	if (ret) {
 		dev_err(dev, "can't start %s role\n", ci_role(ci)->name);
-		ret = -ENODEV;
 		goto rm_wq;
 	}
 
-- 
1.7.2.5

