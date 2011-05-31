Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1EaVqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:46:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab1EaVqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YfwYjtE1oyKiQ7AdQGhjpTJjowpa1mF0xbApqb5y3u9JGUwnKd4gbsxOcl/TIkeCoU
         EfBZI/bQIiNxTnU8NsDdCRkMM71MDAYTcCqLpVWxryfnWpVhHi3KGnd9V/yWPv1noJnj
         c6uJIeq+WgiYaMY/DWoF6puby6cgX1sa3n1qI=
From: Andre Bartke <andre.bartke@googlemail.com>
To: gregkh@suse.de
Cc: hjanssen@microsoft.com, haiyangz@microsoft.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] staging/hv: Fix memory leak of storvsc_dev_add()
Date: Tue, 31 May 2011 23:45:52 +0200
Message-Id: <1306878352-14450-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stor_device is not freed in storvsc_dev_add()
causing a memory leak in case of an allocation error.

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 drivers/staging/hv/storvsc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 06cd327..92b44f4 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -414,6 +414,7 @@ int storvsc_dev_add(struct hv_device *device,
 	device_info->target_id = stor_device->target_id;
 
 cleanup:
+	free_stor_device(stor_device);
 	return ret;
 }
 
-- 
1.7.5.2

