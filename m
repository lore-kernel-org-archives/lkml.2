Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1KZUTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:19:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab1KZUTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:19:47 -0500
From: NeilBrown <neilb@suse.de>
To: Felipe Balbi <balbi@ti.com>
Date: Sun, 27 Nov 2011 07:17:41 +1100
Subject: [PATCH 3/4] twl4030-irq: set tertiary interrupts to be
 nested/threaded.
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>
Message-ID: <20111126201741.16080.35062.stgit@notabene.brown>
In-Reply-To: <20111126201334.16080.85045.stgit@notabene.brown>
References: <20111126201334.16080.85045.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As tertiary interrupts are handled by handle_twl4030_sih calling
handle_nested_irq, they do not need their own separate irq thread.
So mark them as 'nested_thread' interrupts to avoid the extra thread
creation.

Tested on GTA04 Pheonux.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/mfd/twl4030-irq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 29f11e0..3ac7216 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -667,6 +667,7 @@ int twl4030_sih_setup(int module)
 		irq_set_chip_data(irq, agent);
 		irq_set_chip_and_handler(irq, &twl4030_sih_irq_chip,
 					 handle_edge_irq);
+		irq_set_nested_thread(irq, 1);
 		activate_irq(irq);
 	}
 


