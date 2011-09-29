Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab1I2Tya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:54:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36385 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1I2TxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:53:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/9] xen/xenbus: Check before dereferencing it.
Date: Thu, 29 Sep 2011 15:52:49 -0400
Message-Id: <1317325971-21603-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090206.4E84CC9E.00F1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. we do the check whether 'xdev' is NULL - but after we have
dereferenced it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xenbus/xenbus_probe_backend.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
index 60adf91..331589a 100644
--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -103,10 +103,11 @@ static int xenbus_uevent_backend(struct device *dev,
 		return -ENODEV;
 
 	xdev = to_xenbus_device(dev);
-	bus = container_of(xdev->dev.bus, struct xen_bus_type, bus);
 	if (xdev == NULL)
 		return -ENODEV;
 
+	bus = container_of(xdev->dev.bus, struct xen_bus_type, bus);
+
 	if (add_uevent_var(env, "MODALIAS=xen-backend:%s", xdev->devicetype))
 		return -ENOMEM;
 
-- 
1.7.4.1

