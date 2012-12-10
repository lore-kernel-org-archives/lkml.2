Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2LJKBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:01:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47810 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab2LJKA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:00:59 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v3 0/4] leds: leds-pwm: Device tree support
Date: Mon, 10 Dec 2012 11:00:33 +0100
Message-ID: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v2:
- rebased on top of linux-next
- DT bindings now alligned with Grant's request
- exporting of_pwm_request() from PWM core to allow clean DT bindings
- DT binding documentation changed to reflect the changes

Changes since v1:
- As suggested by Bryan Wu: the legacy pwm_request() has been removed from
  patch 1
- Device tree bindings added for leds-pwm driver.

When we boot with Device tree we handle one LED per device to be more aligned
with PWM core's DT implementation.
An example of the DT usage is provided in the new DT binding documentation for
leds-pwm.

Tested on OMAP4 Blaze (SDP) with legacy and DT boot.

Regards,
Peter
---
Peter Ujfalusi (4):
  leds: leds-pwm: Convert to use devm_get_pwm
  leds: leds-pwm: Preparing the driver for device tree support
  pwm: core: Export of_pwm_request() so client drivers can also use it
  leds: leds-pwm: Add device tree bindings

 .../devicetree/bindings/leds/leds-pwm.txt          |  46 ++++++
 drivers/leds/leds-pwm.c                            | 158 ++++++++++++++++-----
 drivers/pwm/core.c                                 |   2 +-
 include/linux/leds_pwm.h                           |   2 +-
 include/linux/pwm.h                                |   7 +
 5 files changed, 175 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt

-- 
1.8.0

