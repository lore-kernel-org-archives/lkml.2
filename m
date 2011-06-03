Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1FCS5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:57:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37039 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab1FCS5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H3qLGQmc+Vnui2ueFpbgMQBgdT+9UgCtHHjPliO8YHvaZ84mu0GC9XB8STghDB5Kcz
         bhU/O4N750IYinF6dTOgsBPD2Svz6lLX2LBWhzbW/dEyCQRcZZ54dHxVgstErhsCFOVa
         EjjrRDg+IEC1KT/jsrWP6CjvYKior+sNT956U=
From: Andre Bartke <andre.bartke@googlemail.com>
To: cezary.jackiewicz@gmail.com
Cc: mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] drivers/platform/x86: Fix memory leak
Date: Fri,  3 Jun 2011 20:55:43 +0200
Message-Id: <1307127343-14290-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

data is not freed in the error case of
compal_probe().

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 drivers/platform/x86/compal-laptop.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 3f204fd..8877b83 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -1030,8 +1030,10 @@ static int __devinit compal_probe(struct platform_device *pdev)
 	initialize_fan_control_data(data);
 
 	err = sysfs_create_group(&pdev->dev.kobj, &compal_attribute_group);
-	if (err)
+	if (err) {
+		kfree(data);
 		return err;
+	}
 
 	data->hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(data->hwmon_dev)) {
-- 
1.7.5.2

