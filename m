Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2LLJFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:05:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32859 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab2LLJFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:05:08 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v4 0/7] leds: leds-pwm: Device tree support
Date: Wed, 12 Dec 2012 10:04:45 +0100
Message-ID: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v3:
Addressed comments from Thierry Redding:
- DT binding documentation for leds-pwm updated
- of_pwm_request() renamed as of_pwm_get()
- introduction of devm_of_pwm_get()
- Commit message updates
- Other comments has been also addressed
- Acked-by from Grant is not added to the patches since they were modified since
  v3

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

Tested on OMAP4 Blaze (SDP), BeagleBoard with legacy and DT boot. On Zoom2 with
legacy boot.

Regards,
Peter
---
Peter Ujfalusi (7):
  leds: leds-pwm: Convert to use devm_get_pwm
  leds: leds-pwm: Preparing the driver for device tree support
  pwm: Correct parameter name in header for *pwm_get() functions
  pwm: core: Rename of_pwm_request() to of_pwm_get() and export it
  pwm: Add devm_of_pwm_get() as exported API for users
  leds: leds-pwm: Simplify cleanup code
  leds: leds-pwm: Add device tree bindings

 .../devicetree/bindings/leds/leds-pwm.txt          |  48 +++++++
 drivers/leds/leds-pwm.c                            | 152 +++++++++++++++------
 drivers/pwm/core.c                                 |  38 +++++-
 include/linux/leds_pwm.h                           |   2 +-
 include/linux/pwm.h                                |  20 ++-
 5 files changed, 212 insertions(+), 48 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt

-- 
1.8.0

