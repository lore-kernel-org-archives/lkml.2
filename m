Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2ADDHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 22:07:41 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:50745
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474Ab2ADDHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 22:07:38 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Richard Zhao <richard.zhao@linaro.org>
To: <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>, <patches@linaro.org>,
        <eric.miao@linaro.org>, Richard Zhao <richard.zhao@linaro.org>
Subject: [PATCH v2 1/1] regulator: set constraints.apply_uV to 0 in of_get_fixed_voltage_config
Date: Wed, 4 Jan 2012 11:07:29 +0800
Message-ID: <1325646449-21916-1-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1325225213-29655-1-git-send-email-richard.zhao@linaro.org>
References: <1325225213-29655-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix fixed regulator using DT failed to call regulator_register.

of_get_regulator_init_data set apply_uV to 1, but fixed regulator
doesn't need it. Set it back to 0.

Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
---
 drivers/regulator/fixed.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 393f039..e24e3a1 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -69,6 +69,7 @@ of_get_fixed_voltage_config(struct device *dev)
 		return NULL;
 
 	init_data = config->init_data;
+	init_data->constraints.apply_uV = 0;
 
 	config->supply_name = init_data->constraints.name;
 	if (init_data->constraints.min_uV == init_data->constraints.max_uV) {
-- 
1.7.5.4


