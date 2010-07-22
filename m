Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0GVWJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:09:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6427 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0GVWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:09:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48342905"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Emese Revfy <re.emese@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/6] Driver core: Fix potential memory leak
Date: Thu, 22 Jul 2010 15:09:01 -0700
Message-Id: <1279836546-26913-2-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In both of the 'goto out' cases, priv has already
been allocated and assigned to bus->p. We reset
bus->p to NULL, but neglect to free bus->p

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 drivers/base/bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 12eec3f..eb1b7fa 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -945,8 +945,8 @@ bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
-	kfree(bus->p);
 out:
+	kfree(bus->p);
 	bus->p = NULL;
 	return retval;
 }
-- 
1.7.2

