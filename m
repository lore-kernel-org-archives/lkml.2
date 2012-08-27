Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2H0VBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:01:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab2H0VBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:01:49 -0400
Message-ID: <503BE05F.40109@suse.com>
Date: Mon, 27 Aug 2012 17:02:23 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] exynos-rng: Depend on ARCH_EXYNOS
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos-rng device is only found on Samsung EXYNOS devices but has
dependencies that allow it to be built on other architectures. This
can result in build failures on powerpc due to a missing clk_devm_get.

This patch makes it depend on ARCH_EXYNOS.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/char/hw_random/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -280,7 +280,7 @@ config HW_RANDOM_PSERIES
 
 config HW_RANDOM_EXYNOS
 	tristate "EXYNOS HW random number generator support"
-	depends on HW_RANDOM && HAS_IOMEM && HAVE_CLK
+	depends on HW_RANDOM && HAS_IOMEM && HAVE_CLK && ARCH_EXYNOS
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on EXYNOS SOCs.


-- 
Jeff Mahoney
SUSE Labs
