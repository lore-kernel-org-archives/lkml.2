Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868Ab2LFHmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:42:55 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:59926 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831Ab2LFHmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:42:43 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-mtd@lists.infradead.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/2] mtd: mxc_nand: reorder part_probes to let cmdline override other sources
Date: Thu,  6 Dec 2012 08:42:28 +0100
Message-Id: <1354779748-28869-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1354779748-28869-1-git-send-email-LW@KARO-electronics.de>
References: <1354779748-28869-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cmdline is the easiest to change source of information. Thus
let it take precedence over 'RedBoot' and 'ofpart'. This makes the
mxc_nand driver to be in sync with all other NAND drivers that support
'cmdlinepart' partition parsing.

Also change 'const char *' to 'const char const *' as advised by checkpatch.pl

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/mtd/nand/mxc_nand.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index d316324..fb98775 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -266,7 +266,8 @@ static struct nand_ecclayout nandv2_hw_eccoob_4k = {
 	}
 };
 
-static const char *part_probes[] = { "RedBoot", "cmdlinepart", "ofpart", NULL };
+static const char const *part_probes[] = {
+	"cmdlinepart", "RedBoot", "ofpart", NULL };
 
 static void memcpy32_fromio(void *trg, const void __iomem  *src, size_t size)
 {
-- 
1.7.2.5

