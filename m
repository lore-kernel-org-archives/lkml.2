Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1KXMrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:47:52 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:12218
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755285Ab1KXMru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:47:50 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>, <stable@kernel.org>
Subject: [PATCH 4/8] firmware: Sigma: Mark firmware strutcs packed
Date: Thu, 24 Nov 2011 13:48:23 +0100
Message-ID: <1322138908-32127-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322138908-32127-1-git-send-email-lars@metafoo.de>
References: <1322138908-32127-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark structs which are embedded into the firmware as packed to avoid alignment
issues.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: stable@kernel.org
---
 include/linux/sigma.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sigma.h b/include/linux/sigma.h
index d0de882..745f1bd 100644
--- a/include/linux/sigma.h
+++ b/include/linux/sigma.h
@@ -25,7 +25,7 @@ struct sigma_firmware_header {
 	unsigned char magic[7];
 	u8 version;
 	__le32 crc;
-};
+} __packed;
 
 enum {
 	SIGMA_ACTION_WRITEXBYTES = 0,
@@ -43,7 +43,7 @@ struct sigma_action {
 	__le16 len;
 	__be16 addr;
 	unsigned char payload[];
-};
+} __packed;
 
 static inline u32 sigma_action_len(struct sigma_action *sa)
 {
-- 
1.7.7.1


