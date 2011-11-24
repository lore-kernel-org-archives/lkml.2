Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1KXP2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:28:47 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:46340
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969Ab1KXP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:42 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Chris Ball <cjb@laptop.org>,
        <linux-mmc@vger.kernel.org>
Subject: [PATCH 07/11] mmc: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:17 +0100
Message-ID: <1322148561-25138-7-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322148561-25138-1-git-send-email-lars@metafoo.de>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ancient times it was necessary to manually initialize the bus field of an
spi_driver to spi_bus_type. These days this is done in spi_driver_register(),
so we can drop the manual assignment.

The patch was generated using the following coccinelle semantic patch:
// <smpl>
@@
identifier _driver;
@@
struct spi_driver _driver = {
	.driver = {
-		.bus = &spi_bus_type,
	},
};
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org
---
 drivers/mmc/host/mmc_spi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 92946b8..273306c 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1525,7 +1525,6 @@ static struct of_device_id mmc_spi_of_match_table[] __devinitdata = {
 static struct spi_driver mmc_spi_driver = {
 	.driver = {
 		.name =		"mmc_spi",
-		.bus =		&spi_bus_type,
 		.owner =	THIS_MODULE,
 		.of_match_table = mmc_spi_of_match_table,
 	},
-- 
1.7.7.1


