Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab1C2AWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:22:35 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58012 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab1C2AWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:22:34 -0400
Date: Mon, 28 Mar 2011 17:22:30 -0700
From: Andres Salomon <dilinger@queued.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        "Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH resend] ARM: mx51_efika: fix build error due to new mfd
 changes
Message-ID: <20110328172230.01756522@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


MFD changes in 4ec1b54c ('mfd: mfd_cell is now implicitly available
to mc13xxx drivers') changed the mc13xxx_platform_data struct layout.
At the time all users were changed, but this driver was introduced in
another tree at the same time.  This updates the mc13xxx_platform_data
user, fixing a build error.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/arm/mach-mx5/mx51_efika.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mx5/mx51_efika.c b/arch/arm/mach-mx5/mx51_efika.c
index 51a67fc..868af8f 100644
--- a/arch/arm/mach-mx5/mx51_efika.c
+++ b/arch/arm/mach-mx5/mx51_efika.c
@@ -572,8 +572,10 @@ static struct mc13xxx_regulator_init_data mx51_efika_regulators[] = {
 
 static struct mc13xxx_platform_data mx51_efika_mc13892_data = {
 	.flags = MC13XXX_USE_RTC | MC13XXX_USE_REGULATOR,
-	.num_regulators = ARRAY_SIZE(mx51_efika_regulators),
-	.regulators = mx51_efika_regulators,
+	.regulators = {
+		.num_regulators = ARRAY_SIZE(mx51_efika_regulators),
+		.regulators = mx51_efika_regulators,
+	},
 };
 
 static struct spi_board_info mx51_efika_spi_board_info[] __initdata = {
-- 
1.7.2.5

