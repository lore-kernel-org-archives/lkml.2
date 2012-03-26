Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2CZGAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:00:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63493 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2CZF7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:59:47 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 3/3] i2c-eg20t: change timeout value 50msec to 1000msec
Date: Mon, 26 Mar 2012 14:55:25 +0900
Message-Id: <1332741325-7746-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332741325-7746-1-git-send-email-tomoya.rohm@gmail.com>
References: <1332741325-7746-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, during i2c works alone, wait-event timeout is not occurred.
However, as CPU load increases, timeout occurs frequently.
So, I modified like this patch.
Modifying like this patch, I've never seen the timeout event with high
load test.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 714b070..ec8f4fa 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -324,7 +324,7 @@ static s32 pch_i2c_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
 {
 	long ret;
 	ret = wait_event_timeout(pch_event,
-			(adap->pch_event_flag != 0), msecs_to_jiffies(50));
+			(adap->pch_event_flag != 0), msecs_to_jiffies(1000));
 
 	if (ret == 0) {
 		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
-- 
1.7.7.6

