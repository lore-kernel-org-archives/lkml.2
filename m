Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056Ab1FWRtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:49:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:35449 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933743Ab1FWRiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 208/247] hwmon: (sht15) Fix integer overflow in humidity calculation
Date: Thu, 23 Jun 2011 13:34:36 -0400
Message-Id: <1308850515-15242-149-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ccd32e735de7a941906e093f8dca924bb05c5794 upstream.

An integer overflow occurs in the calculation of RHlinear when the
relative humidity is greater than around 30%. The consequence is a subtle
(but noticeable) error in the resulting humidity measurement.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/sht15.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index a610e78..38a41d2 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -333,11 +333,11 @@ static inline int sht15_calc_humid(struct sht15_data *data)
 
 	const int c1 = -4;
 	const int c2 = 40500; /* x 10 ^ -6 */
-	const int c3 = -2800; /* x10 ^ -9 */
+	const int c3 = -28; /* x 10 ^ -7 */
 
 	RHlinear = c1*1000
 		+ c2 * data->val_humid/1000
-		+ (data->val_humid * data->val_humid * c3)/1000000;
+		+ (data->val_humid * data->val_humid * c3) / 10000;
 	return (temp - 25000) * (10000 + 80 * data->val_humid)
 		/ 1000000 + RHlinear;
 }
-- 
1.7.4.4

