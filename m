Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1KXMrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:47:46 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:48044
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093Ab1KXMro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:47:44 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>, <stable@kernel.org>
Subject: [PATCH 2/8] firmware: Sigma: Skip header during CRC generation
Date: Thu, 24 Nov 2011 13:48:21 +0100
Message-ID: <1322138908-32127-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322138908-32127-1-git-send-email-lars@metafoo.de>
References: <1322138908-32127-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware header is not part of the CRC, so skip it. Otherwise the firmware
will be rejected due to non-matching CRCs.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: stable@kernel.org
---
 drivers/firmware/sigma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/sigma.c b/drivers/firmware/sigma.c
index 5b17966..b1ab32a6 100644
--- a/drivers/firmware/sigma.c
+++ b/drivers/firmware/sigma.c
@@ -124,7 +124,8 @@ int process_sigma_firmware(struct i2c_client *client, const char *name)
 	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic)))
 		goto done;
 
-	crc = crc32(0, fw->data, fw->size);
+	crc = crc32(0, fw->data + sizeof(*ssfw_head),
+			fw->size - sizeof(*ssfw_head));
 	pr_debug("%s: crc=%x\n", __func__, crc);
 	if (crc != ssfw_head->crc)
 		goto done;
-- 
1.7.7.1


