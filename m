Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1KXP2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:28:53 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:28703
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985Ab1KXP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:28:50 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: <linux-kernel@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Luciano Coelho <coelho@ti.com>, <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/11] wireless: Remove redundant spi driver bus initialization
Date: Thu, 24 Nov 2011 16:29:20 +0100
Message-ID: <1322148561-25138-10-git-send-email-lars@metafoo.de>
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
Cc: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Luciano Coelho <coelho@ti.com>
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/libertas/if_spi.c |    1 -
 drivers/net/wireless/p54/p54spi.c      |    1 -
 drivers/net/wireless/wl1251/spi.c      |    1 -
 drivers/net/wireless/wl12xx/spi.c      |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 728baa4..50b1ee7 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1291,7 +1291,6 @@ static struct spi_driver libertas_spi_driver = {
 	.remove = __devexit_p(libertas_spi_remove),
 	.driver = {
 		.name	= "libertas_spi",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 		.pm	= &if_spi_pm_ops,
 	},
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 2d5cf5b..7faed62 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -700,7 +700,6 @@ static int __devexit p54spi_remove(struct spi_device *spi)
 static struct spi_driver p54spi_driver = {
 	.driver = {
 		.name		= "p54spi",
-		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},
 
diff --git a/drivers/net/wireless/wl1251/spi.c b/drivers/net/wireless/wl1251/spi.c
index eaa5f95..6248c35 100644
--- a/drivers/net/wireless/wl1251/spi.c
+++ b/drivers/net/wireless/wl1251/spi.c
@@ -319,7 +319,6 @@ static int __devexit wl1251_spi_remove(struct spi_device *spi)
 static struct spi_driver wl1251_spi_driver = {
 	.driver = {
 		.name		= DRIVER_NAME,
-		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},
 
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 0f97186..12421a6 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -462,7 +462,6 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 static struct spi_driver wl1271_spi_driver = {
 	.driver = {
 		.name		= "wl1271_spi",
-		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},
 
-- 
1.7.7.1


