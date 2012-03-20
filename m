Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab2CTIcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:32:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42146 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab2CTIcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:32:47 -0400
Message-ID: <1332232359.3373.0.camel@phoenix>
Subject: [PATCH] drivers/base: Remove unneeded spin_lock_init call for
 soc_lock
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 20 Mar 2012 16:32:39 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

soc_lock is already initialized by DEFINE_SPINLOCK.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/base/soc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/base/soc.c b/drivers/base/soc.c
index e57aec1..ba29b2e 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -168,8 +168,6 @@ void soc_device_unregister(struct soc_device *soc_dev)
 
 static int __init soc_bus_register(void)
 {
-	spin_lock_init(&soc_lock);
-
 	return bus_register(&soc_bus_type);
 }
 core_initcall(soc_bus_register);
-- 
1.7.5.4



