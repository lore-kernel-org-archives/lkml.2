Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1ACNzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:55:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab1ACNu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kVBoFogl8zdUGobtTElEjGeZfaCjC6IkE5NFHPfho5ra1Pemm2Nx2dJIC5tXvwaNSs
         /EWH7qrjuYRxmw12ww1kyiEKsoDIoeIP429Z6paKLrRrZPc/EpfLB90O+a1BsUEQVTaQ
         g61ByAAikontWNCpXrg5v2miBWcz6fmux3bN0=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [PATCH 12/32] i2o: use alloc_workqueue() instead of create_workqueue()
Date: Mon,  3 Jan 2011 14:49:35 +0100
Message-Id: <1294062595-30097-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an identity conversion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
---
Please feel free to take it into the subsystem tree or simply ack -
I'll route it through the wq tree.

Thanks.

 drivers/message/i2o/driver.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/message/i2o/driver.c b/drivers/message/i2o/driver.c
index a0421ef..8a5b2d8 100644
--- a/drivers/message/i2o/driver.c
+++ b/drivers/message/i2o/driver.c
@@ -84,7 +84,8 @@ int i2o_driver_register(struct i2o_driver *drv)
 	osm_debug("Register driver %s\n", drv->name);
 
 	if (drv->event) {
-		drv->event_queue = create_workqueue(drv->name);
+		drv->event_queue = alloc_workqueue(drv->name,
+						   WQ_MEM_RECLAIM, 1);
 		if (!drv->event_queue) {
 			osm_err("Could not initialize event queue for driver "
 				"%s\n", drv->name);
-- 
1.7.1

