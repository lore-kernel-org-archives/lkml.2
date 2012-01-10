Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934311Ab2AJXCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:02:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934297Ab2AJXCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:02:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:03 2012
Message-Id: <20120110215603.884365302@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "K. Y. Srinivasan" <kys@microsoft.com>,
        Fuzhou Chen <fuzhouch@microsoft.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [27/49] Drivers:hv: Fix a bug in vmbus_driver_unregister()
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 8f257a142fc3868d69de3f996b95d7bdbc509560 upstream.

The function vmbus_exists() was introduced recently to deal with cases where
the vmbus driver failed to initialize and yet other Hyper-V drivers attempted
to register with the vmbus bus driver. This patch introduced a bug where
vmbus_driver_unregister() would fail to unregister the driver. This patch
fixes the problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Fuzhou Chen <fuzhouch@microsoft.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hv/vmbus_drv.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -627,10 +627,7 @@ void vmbus_driver_unregister(struct hv_d
 	pr_info("unregistering driver %s\n", hv_driver->name);
 
 	if (!vmbus_exists())
-		return;
-
-	driver_unregister(&hv_driver->driver);
-
+		driver_unregister(&hv_driver->driver);
 }
 EXPORT_SYMBOL_GPL(vmbus_driver_unregister);
 


