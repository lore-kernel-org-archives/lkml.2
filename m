Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab0G3LIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:08:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54240 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab0G3LIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vSs6BidnvJP7qsQdeFraTTRRmYJKhJb/Yl09VxLgnRb5fVRU+ndY3SE2r26KwEHnN7
         N8dH0tDUL8Bm7+0RbgBX9I3q0Au1D2Qdo0tPRFr4tbkGncbyoTk10jBuDAf4wKYEsfqe
         92YcsLwmXs/ULAmthJn30NDx1YiCOkonUpXSY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] staging: octeon: check request_irq() return value
Date: Fri, 30 Jul 2010 15:07:42 +0400
Message-Id: <1280488062-20737-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_irq() may fail, if so propagate error code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/octeon/ethernet-spi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-spi.c b/drivers/staging/octeon/ethernet-spi.c
index b58b897..9708254 100644
--- a/drivers/staging/octeon/ethernet-spi.c
+++ b/drivers/staging/octeon/ethernet-spi.c
@@ -294,6 +294,8 @@ int cvm_oct_spi_init(struct net_device *dev)
 	if (number_spi_ports == 0) {
 		r = request_irq(OCTEON_IRQ_RML, cvm_oct_spi_rml_interrupt,
 				IRQF_SHARED, "SPI", &number_spi_ports);
+		if (r)
+			return r;
 	}
 	number_spi_ports++;
 
-- 
1.7.0.4

