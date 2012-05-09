Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab2EIG2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:28:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38762 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755676Ab2EIFwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:55 -0400
Message-Id: <20120509055035.656724943@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AceLan Kao <acelan.kao@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 043/167] [PATCH] dell-laptop: touchpad LED should persist its status after S3
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AceLan Kao <acelan.kao@canonical.com>

commit 2d5de9e84928e35b4d9b46b4d8d5dcaac1cff1fa upstream.

Touchpad LED will not turn on after S3, it will make the touchpad status
doesn't consist with the LED.
By adding one flag to let the LED device restore it's status.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/dell-laptop.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 27600a1..a05fc9c 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -641,6 +641,7 @@ static void touchpad_led_set(struct led_classdev *led_cdev,
 static struct led_classdev touchpad_led = {
 	.name = "dell-laptop::touchpad",
 	.brightness_set = touchpad_led_set,
+	.flags = LED_CORE_SUSPENDRESUME,
 };
 
 static int __devinit touchpad_led_init(struct device *dev)
-- 
1.7.10



