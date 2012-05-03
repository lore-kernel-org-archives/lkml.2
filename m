Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2ECAe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:34:28 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:11461 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2ECAe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:34:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1336005265!4571143!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] video: mb862xx-i2c: local functions should not be exposed globally
Date: Wed, 2 May 2012 17:34:16 -0700
User-Agent: KMail/1.9.9
CC: <linux-fbdev@vger.kernel.org>, <FlorianSchandinat@gmx.de>, <agust@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021734.16988.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions not referenced outside of a source file should be marked
static to prevent them from being exposed globally.

Quiets the sparse warnings:

warning: symbol 'mb862xx_i2c_stop' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Anatolij Gustschin <agust@denx.de>

---

diff --git a/drivers/video/mb862xx/mb862xx-i2c.c b/drivers/video/mb862xx/mb862xx-i2c.c
index 273769b..c87e17a 100644
--- a/drivers/video/mb862xx/mb862xx-i2c.c
+++ b/drivers/video/mb862xx/mb862xx-i2c.c
@@ -68,7 +68,7 @@ static int mb862xx_i2c_read_byte(struct i2c_adapter *adap, u8 *byte, int last)
 	return 1;
 }
 
-void mb862xx_i2c_stop(struct i2c_adapter *adap)
+static void mb862xx_i2c_stop(struct i2c_adapter *adap)
 {
 	struct mb862xxfb_par *par = adap->algo_data;
 
