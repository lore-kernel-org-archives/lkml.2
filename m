Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab0JGEBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:01:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35124 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab0JGEBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RUw+9xic12D7kAn+yLuGqK5yI1kvMka0EmCG1DZCXLraO2fg8IaA5M7/u1dnSE0aq5
         QbCGloh48YN45ZSIMBf+HJMUiQqhaQiOiLPYQwX5C+xuVtMrrnvWBP04Gi7g7Gxp1cn2
         GxDGWOm1dKQGU7rxmEG8SKBQK1hiXUQqloxCU=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        asanchez@neurowork.net, rjw@sisk.pl, csanchez@neurowork.net
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: core: endpoint: Fix error path
Date: Thu,  7 Oct 2010 09:31:12 +0530
Message-Id: <1286424072-2819-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function usb_create_ep_devs()
call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/core/endpoint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index 3788e73..9da2505 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -202,7 +202,7 @@ int usb_create_ep_devs(struct device *parent,
 	return retval;
 
 error_register:
-	kfree(ep_dev);
+	put_device(&ep_dev->dev);
 exit:
 	return retval;
 }
-- 
1.7.2.3

