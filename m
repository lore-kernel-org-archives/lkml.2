Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab0FJIqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 04:46:36 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:48240 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0FJIqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:46:35 -0400
X-IronPort-AV: E=Sophos;i="4.53,397,1272859200"; 
   d="scan'208";a="17267689"
Subject: [PATCH] regulator: make sure the regulator is available prior to
	the consumers.
From: sonic zhang <sonic.adi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain
Date: Thu, 10 Jun 2010 16:53:47 +0800
Message-ID: <1276160027.18479.1.camel@eight.analog.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5a71b38961b0889a239842defd733774ed3d9cdf Mon Sep 17 00:00:00 2001
From: Sonic Zhang <sonic.zhang@analog.com>
Date: Thu, 10 Jun 2010 16:50:20 +0800
Subject: [PATCH] regulator: make sure the regulator is available prior to the consumers.

Some systems are likely to want this to be subsys_initcall() to
make sure the regulator is available prior to the consumers.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/regulator/ad5398.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 0451c30..03969d3 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -274,7 +274,7 @@ static int __init ad5398_init(void)
 {
 	return i2c_add_driver(&ad5398_driver);
 }
-module_init(ad5398_init);
+subsys_initcall(ad5398_init);
 
 static void __exit ad5398_exit(void)
 {
-- 
1.6.0



