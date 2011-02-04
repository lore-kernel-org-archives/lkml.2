Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1BDMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:25:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1BDMYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:24:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=lx6UE8Myoc6q/bSiHer64S1lYDEDwQB6pNuj+5X1gI6HoXdtVTr7+a7L4Jk26WYLOW
         kKjAzhLj2sPJcqx4ii+BMz6sksafDlZAALEyB1wdCPbWGpK59URCuNQ1L62wK0HpV3BQ
         xL5ZasqpByAmQKhd8p7dYhDhqVCRP/KkkmGRA=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Subject: [PATCH 14/20] platform: x86: acer-wmi: world-writable sysfs threeg file
Date: Fri,  4 Feb 2011 15:23:56 +0300
Message-Id: <1456c564561bda820c358cf3c968b5c23a4c374f.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to write to hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/platform/x86/acer-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index f21eb53..1dfd966 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1279,7 +1279,7 @@ static ssize_t set_bool_threeg(struct device *dev,
 			return -EINVAL;
 	return count;
 }
-static DEVICE_ATTR(threeg, S_IWUGO | S_IRUGO | S_IWUSR, show_bool_threeg,
+static DEVICE_ATTR(threeg, S_IRUGO | S_IWUSR, show_bool_threeg,
 	set_bool_threeg);
 
 static ssize_t show_interface(struct device *dev, struct device_attribute *attr,
-- 
1.7.0.4

