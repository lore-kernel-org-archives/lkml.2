Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2E1Dgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52122 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968Ab2E1D3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:44 -0400
Message-Id: <20120528031214.882403942@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [ 087/117] i2c-eg20t: change timeout value 50msec to 1000msec
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 8a52f9f347da721b199b7f9dcc0168bbe7d0baae upstream.

Currently, during i2c works alone, wait-event timeout is not occurred.
However, as CPU load increases, timeout occurs frequently.
So, I modified like this patch.
Modifying like this patch, I've never seen the timeout event with high
load test.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-eg20t.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index f086131..4a46c8b 100644
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


