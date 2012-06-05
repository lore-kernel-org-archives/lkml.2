Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679Ab2FEKQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:16:37 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1255 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756469Ab2FEKQf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:16:35 -0400
Message-ID: <1338891389.4971.45.camel@x61.thuisdomein>
Subject: [PATCH v2] ARM: mach-shmobile: set i2c_board_info.type once
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Date: Tue, 05 Jun 2012 12:16:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-OriginalArrivalTime: 05 Jun 2012 10:16:29.0263 (UTC) FILETIME=[45BE1DF0:01CD4304]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tsc_device (of struct i2cboard_info) has its "type" member set to
"tsc2007" twice. First through the I2C_BOARD_INFO macro and then
directly. Drop the superfluous second instance.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v1 was called "Drop superfluous setting of i2c_board_info.type". v2
drops the mach-imx bits. Those were already fixed with a patch called
"ARM: imx: only specify i2c device type once" by Uwe Kleine-König.
Sascha Hauer has committed that patch to some unknown to me branch.
Rebased onto v3.5-rc1.

1) Still entirely untested. I'm unsure what toolchain is needed to
compile this and I'm certain that I don't have the hardware.

 arch/arm/mach-shmobile/board-ap4evb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index ace6024..b9f3122 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -1197,7 +1197,6 @@ static struct tsc2007_platform_data tsc2007_info = {
 
 static struct i2c_board_info tsc_device = {
 	I2C_BOARD_INFO("tsc2007", 0x48),
-	.type		= "tsc2007",
 	.platform_data	= &tsc2007_info,
 	/*.irq is selected on ap4evb_init */
 };
-- 
1.7.7.6

