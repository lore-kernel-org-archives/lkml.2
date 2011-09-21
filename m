Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab1IUXL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 19:11:29 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:22306 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919Ab1IUXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 19:11:28 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Sep 2011 19:11:28 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag0FAEZsek5Ld+Jv/2dsb2JhbABCmSaMXIFneYISHgYcASYWFhgDAgECAREWJA0BBwKrMYd2O4hyhn0EiXGJXI0IhEM
X-IronPort-AV: E=Sophos;i="4.68,420,1312171200"; 
   d="scan'208";a="137778488"
Message-ID: <4E7A6CED.5000501@gmail.com>
Date: Wed, 21 Sep 2011 19:02:05 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110902 Firefox/6.0.2 SeaMonkey/2.3.3
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: i915 blank issue on kernel 3.1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris, I do not know if it is i915 driver or X'drm or what..
Problem exists on 3.1.0, no problem on 3.0.3

Intel 945GJME 8086:27ac, intel 2.15 x driver, libdrm-intel 2.4.26, 
Debian wheezy.


Recently I have noticed that on Asus EeePCs once X screensaver kicks in 
- system is hosed. Screen goes black and I can not wake it - even 
restarting X does not work, only reboot.

Over ssh I have captured some action from drm.debug=0x0e:
<7>[  787.953399] [drm:intel_panel_get_backlight], get backlight PWM = 312
<7>[  787.953421] [drm:intel_panel_set_backlight], set backlight PWM = 0
<7>[  788.232114] [drm:intel_update_fbc],
<7>[  788.232125] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7>[  788.232134] [drm:intel_calculate_wm], FIFO entries required for 
mode: 15
<7>[  788.232142] [drm:intel_calculate_wm], FIFO watermark level: 11
<7>[  788.232149] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7>[  788.232157] [drm:i9xx_update_wm], FIFO watermarks - A: 11, B: 29
<7>[  788.232165] [drm:i9xx_update_wm], self-refresh entries: 64
<7>[  788.232171] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 11, 
B: 29, C: 2, SR 63
<7>[  788.232180] [drm:i9xx_update_wm], memory self refresh enabled
<7>[  788.232320] [drm:intel_panel_get_backlight], get backlight PWM = 0
<7>[  788.232393] [drm:intel_panel_set_backlight], set backlight PWM = 0
<7>[  788.232623] [drm:intel_panel_set_backlight], set backlight PWM = 0
<7>[ 1132.017589] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
<7>[ 1132.017614] [drm:intel_calculate_wm], FIFO entries required for 
mode: 15
<7>[ 1132.017629] [drm:intel_calculate_wm], FIFO watermark level: 11
<7>[ 1132.017643] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
<7>[ 1132.017658] [drm:i9xx_update_wm], FIFO watermarks - A: 11, B: 29
<7>[ 1132.017674] [drm:i9xx_update_wm], self-refresh entries: 64
<7>[ 1132.017687] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 11, 
B: 29, C: 2, SR 63
<7>[ 1132.017704] [drm:i9xx_update_wm], memory self refresh enabled
<7>[ 1132.036216] [drm:intel_update_fbc],
<7>[ 1132.036248] [drm:intel_lvds_enable], applying panel-fitter: 8, 0
<7>[ 1132.038081] [drm:intel_panel_set_backlight], set backlight PWM = 312
<7>[ 1132.038299] [drm:intel_panel_set_backlight], set backlight PWM = 0


It looks that the problem is the last line - sets back to 0???

I have tried to write 312 back to /sys/class/backlight/intel-backlight/  
bl-power or brightness, and touch uevent - no help.
On 3.0.3 system I see that there is no /sys/../intel-backlight, just eeepc.
And on touching a key it produces
drm:intel_lvds_enable, followed by set backlight PWM=312 (but skips 
resetting it back to 0 right after enable).

So:
is there a way to fix "intel_panel" to call lvds_enable logic?
Is there a way to force usage of eeepc backlight instead (as a workaround)?

Thanks, Woody Suwalski

