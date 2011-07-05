Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1GEJOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:14:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55314 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab1GEJOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:14:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 0/5] MFD/input/ASoC: twl6040: irq registration changes
Date: Tue, 5 Jul 2011 12:14:21 +0300
Message-ID: <1309857266-3663-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As Samuel, and Felipe requested for the twl6040 MFD series:
http://marc.info/?l=linux-kernel&m=130978512225430&w=2
http://marc.info/?l=linux-omap&m=130978403224218&w=2

This is the update to remove the obfuscation around the threaded irq request
in the twl6040 driver and it's slaves.

With this change the slaves uses directly the threaded irq request, and the
core driver passes the irq number for the slaves to use (configured runtime, so
machine drivers do not need to be updated).

Regards,
Peter

PS: for the remaining comments from Samuel I have changed the series, since the
requested change was small.
I'm not intended to send the series again, unless it is requested (again the
change from v6 is minimal - few lines has been removed/replaced).

---
Peter Ujfalusi (5):
  MFD: twl6040: Add irq variable for slave devices
  input: twl6040-vibra: Do not use wrapper for irq request
  ASoC: twl6040: Do not use wrapper for irq request
  MFD: twl6040: Demand valid interrupt configuration
  MFD: twl6040: Remove wrapper for threaded irq request

 drivers/input/misc/twl6040-vibra.c |   17 +++++++++----
 drivers/mfd/twl6040-core.c         |   46 ++++++++++++++++++-----------------
 drivers/mfd/twl6040-irq.c          |   16 +-----------
 include/linux/i2c/twl.h            |    2 +
 include/linux/mfd/twl6040.h        |   22 -----------------
 sound/soc/codecs/twl6040.c         |   17 +++++++++----
 6 files changed, 51 insertions(+), 69 deletions(-)

-- 
1.7.6

