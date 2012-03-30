Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934521Ab2C3UFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:05:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53359 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934128Ab2C3UFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:05:17 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, David Howells <dhowells@redhat.com>
Subject: [PATCH v2 03/15] FRV: mark const init data with __initconst instead of __initdata
Date: Fri, 30 Mar 2012 22:04:53 +0200
Message-Id: <1333137905-13809-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120330200358.GV15647@pengutronix.de>
References: <20120330200358.GV15647@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Howells <dhowells@redhat.com>
---
no changes since (implicit) v1

 arch/frv/mb93090-mb00/pci-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/frv/mb93090-mb00/pci-irq.c b/arch/frv/mb93090-mb00/pci-irq.c
index 20f6497..808bcf7 100644
--- a/arch/frv/mb93090-mb00/pci-irq.c
+++ b/arch/frv/mb93090-mb00/pci-irq.c
@@ -28,7 +28,7 @@
  *
  */
 
-static const uint8_t __initdata pci_bus0_irq_routing[32][4] = {
+static const uint8_t pci_bus0_irq_routing[32][4] __initconst = {
 	[0 ] = { IRQ_FPGA_MB86943_PCI_INTA },
 	[16] = { IRQ_FPGA_RTL8029_INTA },
 	[17] = { IRQ_FPGA_PCI_INTC, IRQ_FPGA_PCI_INTD, IRQ_FPGA_PCI_INTA, IRQ_FPGA_PCI_INTB },
-- 
1.7.9.5

