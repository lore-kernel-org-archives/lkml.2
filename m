Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0FSLwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 07:52:06 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:39176 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0FSLwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 07:52:04 -0400
Date: Sat, 19 Jun 2010 13:44:46 +0200
From: Peter Feuerer <peter@piie.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@googlemail.com>, lenb@kernel.org,
       Andreas Mohr <andi@lisas.de>
Subject: [PATCH 3/4] Driver didn't verify the pointers in which it got
 product information
Message-Id: <20100619134446.7b5e76d3.peter@piie.net>
In-Reply-To: <20100619134343.46564310.peter@piie.net>
References: <20100619134232.7fedd2f1.peter@piie.net>
	<20100619134343.46564310.peter@piie.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/4] Driver didn't verify the pointers in which it got product information
 back from DMI; on QEMU one of the pointers came back null,
 which made the driver crash and subsequently caused a kernel panic.

From: Rahul Chaturvedi <rkc@chromium.org>
Signed-off-by: Rahul Chaturvedi <rkc@chromium.org>
Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>

---
 drivers/platform/x86/acerhdf.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 9226838..6abd3f1 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -524,6 +524,10 @@ static int acerhdf_check_hardware(void)
 	version = dmi_get_system_info(DMI_BIOS_VERSION);
 	product = dmi_get_system_info(DMI_PRODUCT_NAME);
 
+	if (!vendor || !version || !product) {
+		pr_err("error getting hardware information\n");
+		return -EINVAL;
+	}
 
 	pr_info("Acer Aspire One Fan driver, v.%s\n", DRV_VER);
 
-- 
1.7.1

