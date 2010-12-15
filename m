Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400Ab0LOBBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:01:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9416 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760346Ab0LOBBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:01:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Tue, 14 Dec 2010 17:01:52 -0800
Subject: [PATCH 1/1] power: bq20z75: Update return value of CURRENT NOW
From: rklein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 17:01:25 -0800
Message-ID: <1292374885.8731.3.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BQ20Z75 will return a negative value for current if the battery is
discharging and a positive value if charging. This should always be
exported
as a positive number.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 492da27..a039ea0 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -220,6 +220,10 @@ static int bq20z75_get_battery_property(struct
i2c_client *client,
        if (bq20z75_data[reg_offset].min_value < 0)
                ret = (s16)ret;

+       /* for current, it shoud be always positive */
+       if (psp == POWER_SUPPLY_PROP_CURRENT_NOW)
+               ret = abs(ret);
+
        if (ret >= bq20z75_data[reg_offset].min_value &&
            ret <= bq20z75_data[reg_offset].max_value) {
                val->intval = ret;

