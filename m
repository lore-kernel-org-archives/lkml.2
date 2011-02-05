Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1BEO2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:28:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab1BEOV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KC5pFLFqIcmrXUdNVuMm+VKoA/1hOs7zSMiGHE346gGM+leG/asPWuKcOv76GegeD8
         wNre+f8ij3YIkhIVvvBosUcgAvaAJ4kAcES3D+AUcPy2DUvnfPOidWYTUTQv5zFtei9k
         J7Vh+/epWvSQ2tHLX9EKCIJ9qY6851kefzWsI=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 22/52] kstrtox: convert drivers/infiniband/
Date: Sat,  5 Feb 2011 16:20:25 +0200
Message-Id: <1296915654-7458-22-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/infiniband/hw/nes/nes.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 3b4ec32..bddf69c 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -1132,12 +1132,15 @@ static ssize_t nes_show_wqm_quanta(struct device_driver *ddp, char *buf)
 static ssize_t nes_store_wqm_quanta(struct device_driver *ddp,
 					const char *buf, size_t count)
 {
-	unsigned long wqm_quanta_value;
+	unsigned int wqm_quanta_value;
 	u32 wqm_config1;
 	u32 i = 0;
 	struct nes_device *nesdev;
+	int rv;
 
-	strict_strtoul(buf, 0, &wqm_quanta_value);
+	rv = kstrtouint(buf, 0, &wqm_quanta_value);
+	if (rv < 0)
+		return rv;
 	list_for_each_entry(nesdev, &nes_dev_list, list) {
 		if (i == ee_flsh_adapter) {
 			nesdev->nesadapter->wqm_quanta = wqm_quanta_value;
-- 
1.7.3.4

