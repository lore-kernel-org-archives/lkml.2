Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0F3CSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 22:18:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62611 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0F3CSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 22:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OhlwscMlKhcKqfIVu/gqnpvm8uZUtaY/w7Lf7GLnqwf3gp0OQVoH7Z0XthUtGLEpZO
         ThEA8wlqB2qNSDMlZIWLjBqZyEVsHl/QbKPhrTFY9QZEy5gibM5//b2s9cai1f1YbgYk
         duNN6/R58skMZfEFNwl/faTmUiM6asfpOLv3o=
Subject: [PATCH] acer-wmi: set permissions on interface file to S_IRUGO
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Wed, 30 Jun 2010 10:20:23 +0800
Message-Id: <1277864423.14363.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interface file is not writable, thus set permissions to S_IRUGO.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/acer-wmi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 1415d97..fe7c9e4 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1084,8 +1084,7 @@ static ssize_t show_interface(struct device *dev, struct device_attribute *attr,
 	}
 }
 
-static DEVICE_ATTR(interface, S_IWUGO | S_IRUGO | S_IWUSR,
-	show_interface, NULL);
+static DEVICE_ATTR(interface, S_IRUGO, show_interface, NULL);
 
 /*
  * debugfs functions
-- 
1.5.4.3



