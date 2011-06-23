Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab1FWRhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:34994 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556Ab1FWRh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 166/247] hwmon/f71882fg: Set platform drvdata to NULL later
Date: Thu, 23 Jun 2011 13:33:54 -0400
Message-Id: <1308850515-15242-107-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d9ebaa45472c92704f4814682eec21455edcfa1f upstream.

This avoids a possible race leading to trying to dereference NULL.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/f71882fg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index a95fa42..03f08b2 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -2031,7 +2031,6 @@ static int f71882fg_remove(struct platform_device *pdev)
 	int nr_fans = (data->type == f71882fg) ? 4 : 3;
 	u8 start_reg = f71882fg_read8(data, F71882FG_REG_START);
 
-	platform_set_drvdata(pdev, NULL);
 	if (data->hwmon_dev)
 		hwmon_device_unregister(data->hwmon_dev);
 
@@ -2098,6 +2097,7 @@ static int f71882fg_remove(struct platform_device *pdev)
 		}
 	}
 
+	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 
 	return 0;
-- 
1.7.4.4

