Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1DEEuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 00:50:09 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59112 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1DEEuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 00:50:07 -0400
Date: Tue, 5 Apr 2011 00:49:26 -0400 (EDT)
From: Takuma Umeya <tumeya@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Message-ID: <66015840.659833.1301978966706.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1457566934.641329.1301903526622.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: [PATCH] virtio: decrement dev_index when device is unregistered
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When virtio device is removed, dev_index does not get decremented. 
The next device hotplug event results in consuming the next pci to 
the one that is suppose to be available. 

Signed-off-by: Takuma Umeya <tumeya@redhat.com>

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index efb35aa..67fe71d 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -216,6 +216,7 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
 void unregister_virtio_device(struct virtio_device *dev)
 {
        device_unregister(&dev->dev);
+       dev_index--;
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 

-- 
Umeya, Takuma
Technical Account Manager
Red Hat GSS APAC
+81.3.5798.8584 (direct)
tumeya@redhat.com
