Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2KKVKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 16:10:40 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:34555 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2KKVKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 16:10:39 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH] snd-ice1712: enable suspend on unknown ICE1724 cards
Date: Sun, 11 Nov 2012 22:10:13 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201211112210.13837.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assume that unknown ICE1724-based cards are AC97-only that can suspend
without any additional card-specific code.

This fixes suspend on Gainward Hollywood@Home 7.1.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 sound/pci/ice1712/ice1724.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 5cc3fa5..aebd584 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2363,6 +2363,8 @@ static int __devinit snd_vt1724_read_eeprom(struct snd_ice1712 *ice,
 	}
 	printk(KERN_WARNING "ice1724: No matching model found for ID 0x%x\n",
 	       ice->eeprom.subvendor);
+	/* assume AC97-only card which can suspend without additional code */
+	ice->pm_suspend_enabled = 1;
 
  found:
 	ice->eeprom.size = snd_vt1724_read_i2c(ice, dev, 0x04);
-- 
Ondrej Zary
