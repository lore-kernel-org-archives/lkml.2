Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1HDWL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:11:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab1HDWLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:11:53 -0400
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 18:11:53 EDT
Date: Thu, 4 Aug 2011 16:53:47 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: platform-driver-x86-approval@vger.kernel.org, linux-kernel@vger.kernel.org
cc: luto@mit.edu
Subject: Re: [PATCH] thinkpad-acpi: Enable microphone mute LED
Message-ID: <alpine.DEB.2.02.1108041621120.1894@lazy>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Can we please have an ACK on the following patch by Andy Lutomirski 
submitted to this list on May 24, with this patch

echo "1" > 
/sys/devices/platform/thinkpad_acpi/leds/tpacpi::micmute/brightness

echo "0" > 
/sys/devices/platform/thinkpad_acpi/leds/tpacpi::micmute/brightness

turns on and off the mic mute LED. I tested this on a Lenovo X220-Tablet.


Signed-off-by: Andy Lutomirski <luto <at> mit.edu>
---
  drivers/platform/x86/thinkpad_acpi.c |    6 ++++--
  1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c 
b/drivers/platform/x86/thinkpad_acpi.c
index 2797a97..40723a6 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5074,8 +5074,10 @@ static const char * const 
tpacpi_led_names[TPACPI_LED_NUMLEDS] = {
  	"tpacpi::unknown_led2",
  	"tpacpi::unknown_led3",
  	"tpacpi::thinkvantage",
+	"tpacpi::unknown_led4",
+	"tpacpi::micmute",
  };
-#define TPACPI_SAFE_LEDS	0x1081U
+#define TPACPI_SAFE_LEDS	0x5081U

  static inline bool tpacpi_is_led_restricted(const unsigned int led)
  {
@@ -5297,7 +5299,7 @@ static const struct tpacpi_quirk led_useful_qtable[] 
__initconst = {
  	{ /* Lenovo */
  	  .vendor = PCI_VENDOR_ID_LENOVO,
  	  .bios = TPACPI_MATCH_ANY, .ec = TPACPI_MATCH_ANY,
-	  .quirks = 0x1fffU,
+	  .quirks = 0x5fffU,
  	},
  	{ /* IBM ThinkPads with no EC version string */
  	  .vendor = PCI_VENDOR_ID_IBM,
--

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
