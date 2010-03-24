Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0CXXFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:05:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:44074 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0CXXFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:05:20 -0400
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH 1/2] ARM: pcmcia: Fix for building DEBUG with sa11xx_base.c as a module.
Date: Wed, 24 Mar 2010 20:04:57 -0300
Message-Id: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compilation issue when compiling PCMCIA SA1100
support as a module with PCMCIA_DEBUG enabled. The symbol
soc_pcmcia_debug was not beeing exported.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/pcmcia/soc_common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index 6f1a86b..fd4c25a 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -65,6 +65,7 @@ void soc_pcmcia_debug(struct soc_pcmcia_socket *skt, const char *func,
 		va_end(args);
 	}
 }
+EXPORT_SYMBOL(soc_pcmcia_debug);
 
 #endif
 
-- 
1.7.0.3

