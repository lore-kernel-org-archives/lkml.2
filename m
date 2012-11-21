Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2KUC1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:27:50 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2KUC11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:27:27 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 41/42] ARM: shmobile: r8a7740: Add pin control resources
Date: Wed, 21 Nov 2012 03:27:42 +0100
Message-Id: <1353464863-10281-42-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add memory resources for the pin control platform device to let the
sh-pfc driver ioremap() registers properly instead of evily casting
register physical addresses to virtual addresses.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/mach-shmobile/pfc-r8a7740.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-shmobile/pfc-r8a7740.c b/arch/arm/mach-shmobile/pfc-r8a7740.c
index c711365..0ef8287 100644
--- a/arch/arm/mach-shmobile/pfc-r8a7740.c
+++ b/arch/arm/mach-shmobile/pfc-r8a7740.c
@@ -19,9 +19,27 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/bug.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+
 #include "devices.h"
 
+static struct resource r8a7740_pfc_resources[] = {
+	[0] = {
+		.start	= 0xe6050000,
+		.end	= 0xe6057fff,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 0xe605800c,
+		.end	= 0xe605802b,
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
 void r8a7740_pinmux_init(void)
 {
-	sh_pfc_register("pfc-r8a7740", NULL, 0);
+	sh_pfc_register("pfc-r8a7740", r8a7740_pfc_resources,
+			ARRAY_SIZE(r8a7740_pfc_resources));
 }
-- 
1.7.8.6

