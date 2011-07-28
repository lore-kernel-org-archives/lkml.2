Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1G1JjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:39:01 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64537 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab1G1Jix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:38:53 -0400
Subject: [PATCH] drivers/misc: fsa9480: fix a leak of the IRQ during init
 failure
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Donggeun Kim <dg77.kim@samsung.com>, Minkyu Kang <mk7.kang@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 17:38:43 +0800
Message-ID: <1311845923.9100.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we are passing the same cookie in all calls to request_threaded_irq()
and free_irq().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/fsa9480.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
index 5325a7e..27dc0d2 100644
--- a/drivers/misc/fsa9480.c
+++ b/drivers/misc/fsa9480.c
@@ -455,7 +455,7 @@ static int __devinit fsa9480_probe(struct i2c_client *client,
 
 fail2:
 	if (client->irq)
-		free_irq(client->irq, NULL);
+		free_irq(client->irq, usbsw);
 fail1:
 	i2c_set_clientdata(client, NULL);
 	kfree(usbsw);
@@ -466,7 +466,7 @@ static int __devexit fsa9480_remove(struct i2c_client *client)
 {
 	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
 	if (client->irq)
-		free_irq(client->irq, NULL);
+		free_irq(client->irq, usbsw);
 	i2c_set_clientdata(client, NULL);
 
 	sysfs_remove_group(&client->dev.kobj, &fsa9480_group);
-- 
1.7.4.1



