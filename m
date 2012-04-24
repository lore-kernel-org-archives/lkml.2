Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2DXWu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:50:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab2DXWgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:31 -0400
Message-Id: <20120424223246.332226404@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AceLan Kao <acelan.kao@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 51/62] dell-laptop: touchpad LED should persist its status after S3
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AceLan Kao <acelan.kao@canonical.com>

commit 2d5de9e84928e35b4d9b46b4d8d5dcaac1cff1fa upstream.

Touchpad LED will not turn on after S3, it will make the touchpad status
doesn't consist with the LED.
By adding one flag to let the LED device restore it's status.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/dell-laptop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -642,6 +642,7 @@ static void touchpad_led_set(struct led_
 static struct led_classdev touchpad_led = {
 	.name = "dell-laptop::touchpad",
 	.brightness_set = touchpad_led_set,
+	.flags = LED_CORE_SUSPENDRESUME,
 };
 
 static int __devinit touchpad_led_init(struct device *dev)


