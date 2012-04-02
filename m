Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2DBS4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:56:40 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:37531
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab2DBS4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:56:37 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V8M6-01-CTT-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <x86@kernel.org>, <len.brown@intel.com>, <tony.luck@gmail.com>,
        <konrad.wilk@oracle.com>
CC: <linux-acpi@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH] x86: Use safe_halt() instead of halt() in acpi_idle_play_dead()
Date: Mon, 2 Apr 2012 20:56:17 +0200
Message-ID: <1333392977-26468-1-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using halt() in acpi_idle_play_dead() breaks ia64 build. Use safe_halt()
instead.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 drivers/acpi/processor_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 6b1d32a..784f9a7 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -786,7 +786,7 @@ static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
 	while (1) {
 
 		if (cx->entry_method == ACPI_CSTATE_HALT)
-			halt();
+			safe_halt();
 		else if (cx->entry_method == ACPI_CSTATE_SYSTEMIO) {
 			inb(cx->address);
 			/* See comment in acpi_idle_do_entry() */
-- 
1.7.3.4


