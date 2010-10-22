Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0JVA3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:29:41 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44490 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0JVA3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PXSuQvefo1REXw9dltv7IpBvBDRys5+XC77dYxoTujUYVSQ/TkZj/5enqxCuaGM4hJ
         TvwlXHJmRO38UYfUFviqRfBH4LmgtC2hMhhIq+ZGaHaC5yC3rjj9Pj2O03BgAprCcApf
         3gV/SXSJnJxBXDSUjyfeTt9WOQVt//E2jxk+I=
Subject: [PATCH 2/2] mfd: Fix resource reclaim for max8998
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <1287707426.27802.3.camel@mola>
References: <1287707426.27802.3.camel@mola>
Content-Type: text/plain
Date: Fri, 22 Oct 2010 08:31:49 +0800
Message-Id: <1287707509.27802.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly free irq and unregister max8998->rtc device in
max8998_i2c_probe() error path and max8998_i2c_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/max8998.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 06ddf74..bb9977b 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -153,6 +153,8 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 
 err:
 	mfd_remove_devices(max8998->dev);
+	max8998_irq_exit(max8998);
+	i2c_unregister_device(max8998->rtc);
 	kfree(max8998);
 	return ret;
 }
@@ -162,6 +164,8 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
 	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 
 	mfd_remove_devices(max8998->dev);
+	max8998_irq_exit(max8998);
+	i2c_unregister_device(max8998->rtc);
 	kfree(max8998);
 
 	return 0;
-- 
1.7.2



