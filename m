Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1KJHaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 02:30:08 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49125 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1KJHaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 02:30:07 -0500
Message-ID: <1320910200.7431.3.camel@phoenix>
Subject: [PATCH 2/2] devfreq: separate error paths from successful path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 10 Nov 2011 15:30:00 +0800
In-Reply-To: <1320910091.7431.1.camel@phoenix>
References: <1320910091.7431.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this change improves readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/devfreq/devfreq.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 59d24e9..c189b82 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -347,7 +347,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 		if (!IS_ERR(devfreq)) {
 			dev_err(dev, "%s: Unable to create devfreq for the device. It already has one.\n", __func__);
 			err = -EINVAL;
-			goto out;
+			goto err_out;
 		}
 	}
 
@@ -356,7 +356,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 		dev_err(dev, "%s: Unable to create devfreq for the device\n",
 			__func__);
 		err = -ENOMEM;
-		goto out;
+		goto err_out;
 	}
 
 	mutex_init(&devfreq->lock);
@@ -399,17 +399,16 @@ struct devfreq *devfreq_add_device(struct device *dev,
 				   devfreq->next_polling);
 	}
 	mutex_unlock(&devfreq_list_lock);
-	goto out;
+out:
+	return devfreq;
+
 err_init:
 	device_unregister(&devfreq->dev);
 err_dev:
 	mutex_unlock(&devfreq->lock);
 	kfree(devfreq);
-out:
-	if (err)
-		return ERR_PTR(err);
-	else
-		return devfreq;
+err_out:
+	return ERR_PTR(err);
 }
 
 /**
-- 
1.7.5.4



