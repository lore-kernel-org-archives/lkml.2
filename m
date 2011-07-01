Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1GAJga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:36:30 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:34939 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab1GAJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:30 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>, stable@kernel.org,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 13/16] asus-wmi: return proper value in store_cpufv()
Date: Fri,  1 Jul 2011 11:34:38 +0200
Message-Id: <1309512881-2901-14-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: stable@kernel.org
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index be9e89a..b181f5d 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1307,14 +1307,18 @@ ASUS_WMI_CREATE_DEVICE_ATTR(cardr, 0644, ASUS_WMI_DEVID_CARDREADER);
 static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
-	int value;
+	int value, rv;
 
 	if (!count || sscanf(buf, "%i", &value) != 1)
 		return -EINVAL;
 	if (value < 0 || value > 2)
 		return -EINVAL;
 
-	return asus_wmi_evaluate_method(ASUS_WMI_METHODID_CFVS, value, 0, NULL);
+	rv = asus_wmi_evaluate_method(ASUS_WMI_METHODID_CFVS, value, 0, NULL);
+	if (rv < 0)
+		return rv;
+
+	return count;
 }
 
 static DEVICE_ATTR(cpufv, S_IRUGO | S_IWUSR, NULL, store_cpufv);
-- 
1.7.3.4

