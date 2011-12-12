Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab1LLD3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:29:18 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:27041
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954Ab1LLD2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:45 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Steven Miao <realmz6@gmail.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 08/11] bf54x: get mem size: missing break in switch
Date: Mon, 12 Dec 2011 11:28:30 +0800
Message-ID: <1323660513-9620-8-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Miao <realmz6@gmail.com>

Signed-off-by: Steven Miao <realmz6@gmail.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 arch/blackfin/kernel/setup.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index dfa2525..d6102c8 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -828,10 +828,18 @@ static inline int __init get_mem_size(void)
 	u32 ddrctl = bfin_read_EBIU_DDRCTL1();
 	int ret = 0;
 	switch (ddrctl & 0xc0000) {
-		case DEVSZ_64:  ret = 64 / 8;
-		case DEVSZ_128: ret = 128 / 8;
-		case DEVSZ_256: ret = 256 / 8;
-		case DEVSZ_512: ret = 512 / 8;
+	case DEVSZ_64:
+		ret = 64 / 8;
+		break;
+	case DEVSZ_128:
+		ret = 128 / 8;
+		break;
+	case DEVSZ_256:
+		ret = 256 / 8;
+		break;
+	case DEVSZ_512:
+		ret = 512 / 8;
+		break;
 	}
 	switch (ddrctl & 0x30000) {
 		case DEVWD_4:  ret *= 2;
-- 
1.7.0.4


