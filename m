Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab2KVWTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:19:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:49363 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab2KVSib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [ 34/83] i2c-mux-pinctrl: Fix probe error path
Date: Wed, 21 Nov 2012 16:41:56 -0800
Message-Id: <20121122004216.417771635@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit aa1e3e81e75ceb3d977c3292cefafcd5179eb8b8 upstream.

When allocating the memory for i2c busses, the code checked the wrong
variable and thus never detected if there was a memory error.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/muxes/i2c-mux-pinctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -169,7 +169,7 @@ static int __devinit i2c_mux_pinctrl_pro
 	mux->busses = devm_kzalloc(&pdev->dev,
 				   sizeof(mux->busses) * mux->pdata->bus_count,
 				   GFP_KERNEL);
-	if (!mux->states) {
+	if (!mux->busses) {
 		dev_err(&pdev->dev, "Cannot allocate busses\n");
 		ret = -ENOMEM;
 		goto err;


