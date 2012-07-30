Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2G3VH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 17:07:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58954 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab2G3VH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 17:07:28 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/2] staging: ft1000: Fix ft1000_control function timeout argument usage.
Date: Mon, 30 Jul 2012 23:07:16 +0200
Message-Id: <1343682437-10015-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function ft1000_control have input argument timeout which was not passed
to usb_control_msg instead hardcoded to LARGE_TIMEOUT.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 31929ef..21c5ed6 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -73,7 +73,7 @@ static int ft1000_control(struct ft1000_device *ft1000dev, unsigned int pipe,
 	}
 
 	ret = usb_control_msg(ft1000dev->dev, pipe, request, requesttype,
-			      value, index, data, size, LARGE_TIMEOUT);
+			      value, index, data, size, timeout);
 
 	if (ret > 0)
 		ret = 0;
-- 
1.7.9.5

