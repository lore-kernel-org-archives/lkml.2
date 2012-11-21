Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2KUC0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:26:55 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2KUC0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:54 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 07/42] sh-pfc: Remove check for impossible error condition
Date: Wed, 21 Nov 2012 03:27:08 +0100
Message-Id: <1353464863-10281-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pfc pointer can't be NULL in the get and set value functions, remove
the error check.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/sh/pfc/gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/sh/pfc/gpio.c b/drivers/sh/pfc/gpio.c
index f22d43a..0a85159 100644
--- a/drivers/sh/pfc/gpio.c
+++ b/drivers/sh/pfc/gpio.c
@@ -51,7 +51,7 @@ static void sh_gpio_set_value(struct sh_pfc *pfc, unsigned gpio, int value)
 	struct pinmux_data_reg *dr = NULL;
 	int bit = 0;
 
-	if (!pfc || sh_pfc_get_data_reg(pfc, gpio, &dr, &bit) != 0)
+	if (sh_pfc_get_data_reg(pfc, gpio, &dr, &bit) != 0)
 		BUG();
 	else
 		sh_pfc_write_bit(dr, bit, value);
@@ -62,7 +62,7 @@ static int sh_gpio_get_value(struct sh_pfc *pfc, unsigned gpio)
 	struct pinmux_data_reg *dr = NULL;
 	int bit = 0;
 
-	if (!pfc || sh_pfc_get_data_reg(pfc, gpio, &dr, &bit) != 0)
+	if (sh_pfc_get_data_reg(pfc, gpio, &dr, &bit) != 0)
 		return -EINVAL;
 
 	return sh_pfc_read_bit(dr, bit);
-- 
1.7.8.6

