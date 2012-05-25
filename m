Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab2EYNdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:33:53 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:18201
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399Ab2EYNdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:33:51 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <b29396@freescale.com>
Subject: [PATCH v4 3/6] of: release node fix for of_parse_phandle_with_args
Date: Fri, 25 May 2012 21:36:17 +0800
Message-ID: <1337952980-14621-3-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337952980-14621-1-git-send-email-b29396@freescale.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Since this API requires user to call of_node_put for the node
it returned via outargs, if no outargs provided, user have no
chance to release it, so release it internally if no outargs
provided.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/of/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index d9bfd49..91c1fb4 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -961,6 +961,8 @@ int of_parse_phandle_with_args(struct device_node *np, const char *list_name,
 				out_args->args_count = count;
 				for (i = 0; i < count; i++)
 					out_args->args[i] = be32_to_cpup(list++);
+			} else {
+				of_node_put(node);
 			}
 			return 0;
 		}
-- 
1.7.0.4


