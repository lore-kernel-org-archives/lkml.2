Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1GENtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:49:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54196 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1GENts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:49:48 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 0/5] MFD/input/ASoC: twl6040: irq registration changes
Date: Tue, 5 Jul 2011 16:49:30 +0300
Message-ID: <1309873775-17927-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v1:
- IRQ number is passed with resource to the slave devices

Intro mail froim v1:
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
  MFD: twl6040: Use resource to provide irq number for slaves
  input: twl6040-vibra: Do not use wrapper for irq request
  ASoC: twl6040: Do not use wrapper for irq request
  MFD: twl6040: Demand valid interrupt configuration
  MFD: twl6040: Remove wrapper for threaded irq request

 drivers/input/misc/twl6040-vibra.c |   17 ++++++---
 drivers/mfd/twl6040-core.c         |   69 ++++++++++++++++++++++++-----------
 drivers/mfd/twl6040-irq.c          |   16 +--------
 include/linux/mfd/twl6040.h        |   22 -----------
 sound/soc/codecs/twl6040.c         |   19 +++++++---
 5 files changed, 74 insertions(+), 69 deletions(-)

-- 
1.7.6

