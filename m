Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1FHNVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:21:05 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:22131 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab1FHNVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:21:01 -0400
From: David Jander <david@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v4 2/6] GPIO: pca953x.c: Set device platform_data pointer after allocating it
Date: Wed,  8 Jun 2011 14:48:30 +0200
Message-Id: <1307537314-4345-3-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307537314-4345-1-git-send-email-david@protonic.nl>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case that we obtain device-tree data to fill in platform_data,
the dev.platform_data pointer needs to be set, since it is used by
functions such as pca953x_irq_setup() later on.

Signed-off-by: David Jander <david@protonic.nl>
---
 drivers/gpio/pca953x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index b31f881..2dff562 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -660,6 +660,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 		 * dynamically and must be freed in the driver
 		 */
 		chip->dyn_pdata = pdata;
+		client->dev.platform_data = pdata;
 	}
 
 	if (pdata == NULL) {
-- 
1.7.4.1

