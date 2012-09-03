Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2ICEn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 00:43:59 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58585 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2ICEn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 00:43:58 -0400
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.46.74
Date: Sun, 2 Sep 2012 21:43:52 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] hid: Remove "default m" from HID_LOGITECH_DJ
Message-ID: <20120903044351.GA1590@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID_LOGITECH_DJ uses "default m", which enables it in default kernel
builds.  Since this module just enables extra, non-critical
functionality for one particular piece of hardware (specifically,
differentiating multiple wireless keyboards and mice as separate input
devices rather than treating them as one device), and the hardware works
just fine with the default USB HID support, drop the "default m".

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/hid/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index fbf4950..d004528 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -307,7 +307,6 @@ config HID_LOGITECH
 config HID_LOGITECH_DJ
 	tristate "Logitech Unifying receivers full support"
 	depends on HID_LOGITECH
-	default m
 	---help---
 	Say Y if you want support for Logitech Unifying receivers and devices.
 	Unifying receivers are capable of pairing up to 6 Logitech compliant
-- 
1.7.10.4

