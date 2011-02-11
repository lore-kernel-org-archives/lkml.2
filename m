Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1BKBqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:46:12 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:35990 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab1BKBqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:46:11 -0500
Date: Thu, 10 Feb 2011 17:46:07 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 01/10] olpc_dcon: don't specify single bits for bool fields
Message-ID: <20110210174607.698e9ae0@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just use a regular 'bool foo', rather than 'bool foo:1'.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index eec10e7..cc12110 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -63,8 +63,8 @@ struct dcon_priv {
 	u8 disp_mode;
 
 	/* Current output type; true == mono, false == color */
-	bool mono:1;
-	bool asleep:1;
+	bool mono;
+	bool asleep;
 };
 
 /* I2C structures */
@@ -516,7 +516,7 @@ static ssize_t dcon_sleep_show(struct device *dev,
 {
 
 	struct dcon_priv *dcon = dev_get_drvdata(dev);
-	return sprintf(buf, "%d\n", dcon->asleep ? 1 : 0);
+	return sprintf(buf, "%d\n", dcon->asleep);
 }
 
 static ssize_t dcon_freeze_show(struct device *dev,
@@ -529,7 +529,7 @@ static ssize_t dcon_mono_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct dcon_priv *dcon = dev_get_drvdata(dev);
-	return sprintf(buf, "%d\n", dcon->mono ? 1 : 0);
+	return sprintf(buf, "%d\n", dcon->mono);
 }
 
 static ssize_t dcon_resumeline_show(struct device *dev,
@@ -564,7 +564,7 @@ static ssize_t dcon_mono_store(struct device *dev,
 	if (_strtoul(buf, count, &enable_mono))
 		return -EINVAL;
 
-	dcon_set_mono_mode(dev_get_drvdata(dev), enable_mono ? 1 : 0);
+	dcon_set_mono_mode(dev_get_drvdata(dev), enable_mono ? true : false);
 	rc = count;
 
 	return rc;
-- 
1.7.2.3

