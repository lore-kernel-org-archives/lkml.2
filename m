Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0JBGtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 02:49:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54448 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0JBGtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 02:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=yCGsClrwiyfEwUtcZ9bkVxtdvaEAoIVyTXzk5hViqNr6VDmogTzo7TXsV3VZXCfoBF
         mXgC8QiR7PTGzV/M96ocs6ZaPzSdk8KA3if0YilSw7WNaxou76V3o1/JGoblMktqBD9w
         ohJIjUtMZpLj+9PI2qoPiExQsZZswDyVH4zcg=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        asanchez@neurowork.net, rjw@sisk.pl
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: core: endpoint: Fix error path
Date: Sat,  2 Oct 2010 12:18:41 +0530
Message-Id: <1286002121-3694-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function usb_create_ep_devs()
call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/core/endpoint.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index 3788e73..cab126d 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -195,8 +195,10 @@ int usb_create_ep_devs(struct device *parent,
 	device_enable_async_suspend(&ep_dev->dev);
 
 	retval = device_register(&ep_dev->dev);
-	if (retval)
+	if (retval) {
+		put_device(&ep_dev->dev);
 		goto error_register;
+	}
 
 	endpoint->ep_dev = ep_dev;
 	return retval;
-- 
1.7.2.3

