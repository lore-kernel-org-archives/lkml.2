Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab0KJBOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:14:06 -0500
Received: from mail.perches.com ([173.55.12.10]:4888 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab0KJBOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:14:02 -0500
Subject: [PATCH] drivers/pcmcia/soc_common.c: Use printf extension %pV
From: Joe Perches <joe@perches.com>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 17:14:01 -0800
Message-ID: <1289351641.28590.84.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pV reduces the number of printk calls and
eliminates any possible message interleaving from
other printk calls.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pcmcia/soc_common.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index 689e3c0..3753fd0 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -57,11 +57,16 @@ module_param(pc_debug, int, 0644);
 void soc_pcmcia_debug(struct soc_pcmcia_socket *skt, const char *func,
 		      int lvl, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 	if (pc_debug > lvl) {
-		printk(KERN_DEBUG "skt%u: %s: ", skt->nr, func);
 		va_start(args, fmt);
-		vprintk(fmt, args);
+
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		printk(KERN_DEBUG "skt%u: %s: %pV", skt->nr, func, &vaf);
+
 		va_end(args);
 	}
 }


