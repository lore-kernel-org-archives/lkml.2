Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2FMI1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:27:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26845 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2FMI1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:27:18 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-1d-4fd84ee54886
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: [PATCH 2/5] regulator: Fix the s5m8767a problem of the division by null
Date: Wed, 13 Jun 2012 17:27:16 +0900
Message-id: <042001cd493e$57920600$06b61200$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JPldQ6vE5/V6XQVaK6uXe8/YLmg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd2nfjf8Dc6tkLG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZbcefMRa8YK14vvkRWwPjY5YuRk4OCQETiTcPG9ghbDGJC/fW
	s3UxcnEICSxilJg8/yUrhDOXSaJ74SqwDjYBDYmVu9+ygdgiAmESM2etBIszCxhLnFj4HmyS
	sECARM/808wgNouAqsSepY1gNq+AocTXs1eZIGxBiR+T70H1akms33mcCcKWl9i85i1QPQfQ
	ReoSj/7qQqzSk3g96yobRImIxL4X7xgnMArMQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4MB8Jr2DcVWDxSFGAQ5GJR7eILcb/kKsiWXFlbmHGCU4mJVEeIu3
	XvcX4k1JrKxKLcqPLyrNSS0+xCjNwaIkzttkfcFfSCA9sSQ1OzW1ILUIJsvEwSnVwJh0uXtt
	9V225eKZP4TCD18ridW2Wyy7Y/9mZVOdD3M32WzyP9vsWucQ9WNSr3+4XtIvzUkGn3Xvq/hr
	mpioXDx98MAZo5RLT195rJ/r3vwv78vr+9rX3LJYlSbHfF7/Ka1/1dRUeVWLjU5i6hMn7tr/
	k3lGse6JT76yH6+b+H+onP92bV2OSIYSS3FGoqEWc1FxIgAIcXy5SAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ramp_delay is 0, delay value can be divided by zero.
This patch can fix the problem.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 4edf344..ce9dda2 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -451,7 +451,7 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 
 	desc = reg_voltage_map[reg_id];
 
-	if (old_sel < new_sel)
+	if ((old_sel < new_sel) && s5m8767->ramp_delay)
 		return DIV_ROUND_UP(desc->step * (new_sel - old_sel),
 					s5m8767->ramp_delay * 1000);
 	return 0;
-- 
1.7.1


