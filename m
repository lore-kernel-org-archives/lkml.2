Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab2EDUra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:47:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2EDUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:25 -0400
Message-Id: <20120504204230.008838207@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Stigge <stigge@antcom.de>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [ 66/75] i2c: pnx: Disable clk in suspend
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Stigge <stigge@antcom.de>

commit 6c557cfee08751d22aed34840f389b846f0f4508 upstream.

In the driver's suspend function, clk_enable() was used instead of
clk_disable(). This is corrected with this patch.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
[wsa: reworded commit header slightly]
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-pnx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -546,8 +546,7 @@ static int i2c_pnx_controller_suspend(st
 {
 	struct i2c_pnx_algo_data *alg_data = platform_get_drvdata(pdev);
 
-	/* FIXME: shouldn't this be clk_disable? */
-	clk_enable(alg_data->clk);
+	clk_disable(alg_data->clk);
 
 	return 0;
 }


