Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0LOODp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:03:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:43674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab0LOODo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:03:44 -0500
Message-ID: <4D08CAB1.6040402@kernel.org>
Date: Wed, 15 Dec 2010 15:03:29 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, jon.mason@exar.com
Subject: [PATCH net-next-2.6] vxge: add missing flush of reset_task
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 14:03:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6e07ebd84 (drivers/net: remove unnecessary
flush_scheduled_work() calls) incorrectly removed the flush call
without replacing it with the appropriate work specific operation.
Fix it by flushing vdev->reset_task explicitly.

Pointed out by Jon Mason.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jon Mason <jon.mason@exar.com>
---
 drivers/net/vxge/vxge-main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
index 537ad87..1ac9b56 100644
--- a/drivers/net/vxge/vxge-main.c
+++ b/drivers/net/vxge/vxge-main.c
@@ -3439,6 +3439,8 @@ static void vxge_device_unregister(struct __vxge_hw_device *hldev)

 	strncpy(buf, dev->name, IFNAMSIZ);

+	flush_work_sync(&vdev->reset_task);
+
 	/* in 2.6 will call stop() if device is up */
 	unregister_netdev(dev);

