Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab2IYQNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab2IYQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:07 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 00/57] power: Upgrade to ux500 battery management driver 
Date: Tue, 25 Sep 2012 10:11:57 -0600
Message-Id: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>

This patch set upgrades the current ux500 battery management driver
to the latest HW and functionality.

Pull request for convenience:

The following changes since commit 56d27adcb536b7430d5f8a6240df8ad261eb00bd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2012-09-24 16:17:17 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mpoirier/linux.git ux500-battery-management

Daniel WILLERUD (1):
  power: Add sysfs interfaces for capacity

Hakan Berg (10):
  power: ab8500_bm: Ignore false btemp low interrupt
  power: Adds support for Car/Travel Adapters
  power: bm remove superfluous BTEMP thermal comp.
  power: ab8500_bm: Added support for BATT_OVV
  power: ab8500_fg: Adjust for RF bursts voltage drops.
  power: ab8500_btemp: Filter btemp readings
  power: charging: Allow capacity to raise from 1%
  power: charging: Add AB8505_USB_LINK_STATUS
  power: ab8500-chargalg: update battery health on safety timer exp
  power: abx500_chargalg: Use hrtimer

Henrik Sölver (1):
  power: AB workaround for invalid charger

Johan Bjornstedt (2):
  power: ab8500_bm: Charger current step-up/down
  power: ab8500_bm: Skip first CCEOC irq for instant current

Jonas Aaberg (7):
  power: ab8500_btemp: Detect battery type in workqueue
  power: ab8500_bm: Detect removed charger
  power: ab8500_fg: flush sync on suspend
  power: ab8500_fg: usleep_range instead of short msleep
  power: ab8500_charger: Handle gpadc errors
  power: ab8500: Flush & sync all works
  power: ab8500_charger: Do not touch VBUSOVV bits

Kalle Komierowski (2):
  power: ab8500_bm: Don't clear the CCMuxOffset bit
  power: ab8500_bm: Quick re-attach charging behaviour

Loic Pallardy (3):
  power: Add plaform data charger configurables
  power: charge: update watchdog for pm2xxx support
  power: chargealg: Realign with upstream version

Marcus Cooper (8):
  power: Recharge condition not optimal for battery
  power: remove unused defines.
  power: Adds support for legacy USB chargers
  power: ab8500: ADC for battery thermistor
  power: ab8500: remove unecesary define flag
  power: ab8500_charger: Use USBLink1Status Register
  power: ab8500_charger: Add UsbLineCtrl2 reference
  power: abx500_chargalg: Fix quick re-attach charger issue.

Martin Bergstrom (2):
  power: ab8500_fg: Report unscaled capacity
  power: ab8500_charger: Limit USB charger current

Martin Bergström (1):
  power: ab8500_fg: Goto INIT_RECOVERY when charger removed

Martin Sjoblom (1):
  power: ab8500_charger: Prevent auto drop of VBUS

Mathieu J. Poirier (4):
  power: Harmonising platform data declaration/handling
  power: Cancelling status charging notification.
  power: ab8500: Re-alignment with internal developement.
  power: ab8500_fg: Moving structure definitions to header file

Michel JAOUEN (2):
  power: ab8500: adaptation to ab version
  power: sysfs interface update

Nicolas Guion (1):
  power: ab8500 - Accessing Autopower register fails

Paer-Olof Haakansson (3):
  power: ab8500_bm: Rename the power_loss function
  power: Overflow in current calculation
  power: u8500_charger: Delay for USB enumeration

Philippe Langlais (1):
  power: ab8500: bm: movimg back to ab8500 platform data managment

Rajkumar Kasirajan (1):
  power: ab8500_fg: fix to use correct battery charge full design

Rickard Andersson (1):
  power: ab8500_fg: balance IRQ enable

Rikard Olsson (1):
  power: ab8500_fg: add power cut feature for ab8505

Rupesh Kumar (3):
  power: l9540: Charge only mode fixes
  power: ab8500: defer btemp filtering while init
  power: ab8500 : quick re-attach for ext charger

Yang QU (1):
  power: add backup battery charge voltages.

pender01 (1):
  power: ab8500_fg: Round capacity output

 drivers/mfd/ab8500-core.c                 |    6 +
 drivers/power/Kconfig                     |    7 -
 drivers/power/ab8500_btemp.c              |  165 +++--
 drivers/power/ab8500_charger.c            | 1410 +++++++++++++++++++++++------
 drivers/power/ab8500_fg.c                 | 1085 +++++++++++++++++------
 drivers/power/ab8500_fg.h                 |  201 ++++
 drivers/power/abx500_chargalg.c           |  333 ++++++--
 include/linux/mfd/abx500.h                |   30 +-
 include/linux/mfd/abx500/ab8500-bm.h      |   47 +-
 include/linux/mfd/abx500/ab8500.h         |   22 +-
 include/linux/mfd/abx500/ux500_chargalg.h |    8 +
 11 files changed, 2607 insertions(+), 707 deletions(-)
 create mode 100644 drivers/power/ab8500_fg.h
-- 
1.7.5.4

