Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1AYKU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:20:26 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:34196 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961Ab1AYKUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:20:22 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 29/32] dma40: handle failure to allocate first LCLA
Date: Tue, 25 Jan 2011 11:18:32 +0100
Message-ID: <1295950715-22340-30-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4ec96ac..b8cce85 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -538,6 +538,10 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 			       curr_lcla);
 
 	lli_current++;
+
+	if (curr_lcla < 0)
+		goto out;
+
 	for (; lli_current < lli_len; lli_current++) {
 		unsigned int lcla_offset = chan->phy_chan->num * 1024 +
 					   8 * curr_lcla * 2;
@@ -567,6 +571,7 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 		}
 	}
 
+out:
 	desc->lli_current = lli_current;
 }
 
-- 
1.7.3.2

