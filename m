Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2KDWf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 17:35:26 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:58080 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab2KDWfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 17:35:25 -0500
To: alsa-devel@alsa-project.org
Subject: [PATCH] snd-es1968: Add ESS vendor ID to pm_whitelist
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Sun, 4 Nov 2012 23:34:58 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211042334.59034.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic ESS vendor ID to pm_whitelist. This should fix suspend on
all Maestro-2 and Maestro-2E based PCI cards.
Tested on Terratec DMX and SF64-PCE2.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2655,6 +2655,8 @@ static struct ess_device_list pm_whitelist[] __devinitdata = {
 	{ TYPE_MAESTRO2E, 0x1179 },
 	{ TYPE_MAESTRO2E, 0x14c0 },	/* HP omnibook 4150 */
 	{ TYPE_MAESTRO2E, 0x1558 },
+	{ TYPE_MAESTRO2E, 0x125d },	/* a PCI card, e.g. Terratec DMX */
+	{ TYPE_MAESTRO2, 0x125d },	/* a PCI card, e.g. SF64-PCE2 */
 };
 
 static struct ess_device_list mpu_blacklist[] __devinitdata = {
-- 
Ondrej Zary
