Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030649Ab2CTI5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:57:34 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39076 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965000Ab2CTIyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:10 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] samsung-laptop: cleanup return type: mode_t vs umode_t
Date: Tue, 20 Mar 2012 09:53:07 +0100
Message-Id: <1332233594-13099-8-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrgeejucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This function returns a umode_t (unsigned short) instead of mode_t which
is an unsigned int on some architectures.  Cleaning this up silences a
compile warning:

drivers/platform/x86/samsung-laptop.c:1108:2: warning: initialization
	from incompatible pointer type [enabled by default]

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index d1142e3..4787afd 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1087,7 +1087,7 @@ static int __init samsung_backlight_init(struct samsung_laptop *samsung)
 	return 0;
 }
 
-static mode_t samsung_sysfs_is_visible(struct kobject *kobj,
+static umode_t samsung_sysfs_is_visible(struct kobject *kobj,
 				       struct attribute *attr, int idx)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-- 
1.7.3.4

