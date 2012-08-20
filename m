Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2HTKpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:45:40 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:32856 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab2HTKph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 06:45:37 -0400
From: Marina Makienko <makienko@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marina Makienko <makienko@ispras.ru>, David Daney <david.daney@cavium.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Roy.Li" <rongqing.li@windriver.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging: octeon: Add prevent NAPI from scheduling
Date: Mon, 20 Aug 2012 14:41:22 +0400
Message-Id: <1345459282-8666-1-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code inspection shows that this can
only be triggered by calling napi_enable() without
napi_disable().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Marina Makienko <makienko@ispras.ru>
---
 drivers/staging/octeon/ethernet-rx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 34afc16..db81613 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -560,4 +560,5 @@ void cvm_oct_rx_shutdown(void)
 	/* Shutdown all of the NAPIs */
 	for_each_possible_cpu(i)
 		netif_napi_del(&cvm_oct_napi[i].napi);
+		napi_disable(&cvm_oct_napi[i].napi);
 }
-- 
1.7.7

