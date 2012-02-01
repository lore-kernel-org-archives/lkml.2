Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2BAVTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:19:55 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42835 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757379Ab2BAVTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:50 -0500
X-Sasl-enc: y/Cfv9q/5eVpFM/3Xb780ixXGSspmXeRu2HCzbxvSBY0 1328131189
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:51 2012
Message-Id: <20120201210051.711353272@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mathieu Poirier <mathieu.poirier@linaro.org>,
        Fredrik Soderstedt <fredrik.soderstedt@stericsson.com>,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [89/89] mach-ux500: no MMC_CAP_SD_HIGHSPEED on Snowball
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philippe Langlais <philippe.langlais@linaro.org>

commit 2ab1159e80e8f416071e9f51e4f77b9173948296 upstream.

MMC_CAP_SD_HIGHSPEED is not supported on Snowball board resulting on
initialization errors.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Fredrik Soderstedt <fredrik.soderstedt@stericsson.com>
Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

---
 arch/arm/mach-ux500/board-mop500-sdi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -233,6 +233,8 @@ void __init snowball_sdi_init(void)
 {
 	u32 periphid = 0x10480180;
 
+	/* On Snowball MMC_CAP_SD_HIGHSPEED isn't supported on sdi0 */
+	mop500_sdi0_data.capabilities &= ~MMC_CAP_SD_HIGHSPEED;
 	mop500_sdi2_data.capabilities |= MMC_CAP_MMC_HIGHSPEED;
 
 	/* On-board eMMC */


