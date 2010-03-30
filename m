Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab0C3Ob0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:31:26 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:12395 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0C3ObY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:31:24 -0400
Subject: Re: [PATCH 3/4] include cleanup: Update gfp.h and slab.h includes
 to prepare for breaking implicit slab.h inclusion from percpu.h
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       adobriyan@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       yi.zhu@intel.com, reinette.chatre@intel.com, ilw@linux.intel.com,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1269420538-18039-4-git-send-email-tj@kernel.org>
References: <1269420538-18039-1-git-send-email-tj@kernel.org>
	 <1269420538-18039-4-git-send-email-tj@kernel.org>
Content-Type: text/plain
Organization: HP/LKTT
Date: Tue, 30 Mar 2010 10:30:10 -0400
Message-Id: <1269959410.16298.20.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 17:48 +0900, Tejun Heo wrote: 
> percpu.h is included by sched.h and module.h and thus ends up being
> included when building most .c files in the kernel.  percpu.h includes
> slab.h which in turn includes gfp.h making everything defined by the
> two files unconditionally available and complicating inclusion
> dependencies.

<snip script/process discussion>

> Given the fact that I had only a couple of failures from tests on step
> 6, I'm fairly confident about the coverage of this conversion patch.
> If there is a breakage, it's likely to be something in the arch header
> which should be discovered easily on most builds of the specific arch.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> ---
> With the actual patch, this message would end up ~1.7M which seems tad
> bit too large to send through LKML.  I said that I would post the
> whole patch on the last round but that was 200k and this one is 272K
> only with the diffstats and this one doesn't include any interesting
> stuff, so I'm snipping it again.  The whole patch is available at the
> following URL.
> 
>  http://userweb.kernel.org/~tj/patches/0003-include-cleanup-Update-gfp.h-and-slab.h-includes-to-.patch
> 

Tejun:

I rebased your series atop the mmotm dated 24march to test my "generic
percpu numa_*_id()" series.  This largish patch [3/4] threw a few [13]
rejects.  I'll list them below.  You've said that you're going to submit
this to linux-next where it might not see the same rejects.  I built,
booted and am using the resulting kernel on x86_64.

Building with allyesconfig, I found 15 additional files in the mmotm
tree that will need an explicit include of slab.h added.  I have
attached a patch that addresses these.

I have rebased my numa_*_id() series atop this mmotm, less the
percpu.h/percpu-defs.h hack that led you down this path.  That kernel
builds and boots fine.  I'm currently testing with and without
memoryless nodes.  So far, this series looks good.

Regards,
Lee


Rejects atop 24march mmotm:

arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c.rej
drivers/gpio/gpiolib.c.rej
drivers/gpu/drm/radeon/r300.c.rej
drivers/hid/hid-wacom.c.rej
drivers/media/video/soc_camera.c.rej
drivers/net/wireless/wl12xx/wl1271_cmd.c.rej
drivers/net/wireless/wl12xx/wl1271_main.c.rej
drivers/net/wireless/wl12xx/wl1271_spi.c.rej
drivers/s390/char/vmcp.c.rej
fs/proc/base.c.rej
kernel/audit_watch.c.rej
net/mac80211/scan.c.rej
security/selinux/ss/symtab.c.rej

==============================================================
Additional files requiring explict include of slab.h from the
24march2010 mmotm.


Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 drivers/hwmon/tmp102.c              |    1 +
 drivers/input/misc/ad714x.c         |    1 +
 drivers/input/misc/pcf8574_keypad.c |    1 +
 drivers/leds/leds-input.c           |    1 +
 drivers/misc/hwlat_detector.c       |    1 +
 drivers/mtd/sm_ftl.c                |    1 +
 drivers/vbus/bus-proxy.c            |    1 +
 kernel/debug/kdb/kdb_support.c      |    1 +
 sound/soc/codecs/twl6040.c          |    1 +
 sound/usb/endpoint.c                |    1 +
 sound/usb/format.c                  |    1 +
 sound/usb/helper.c                  |    1 +
 sound/usb/mixer_quirks.c            |    1 +
 sound/usb/pcm.c                     |    1 +
 sound/usb/quirks.c                  |    1 +
 15 files changed, 15 insertions(+)

Index: linux-2.6.34-rc2-mmotm-100324-1448/drivers/vbus/bus-proxy.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/drivers/vbus/bus-proxy.c	2010-03-29 09:18:20.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/drivers/vbus/bus-proxy.c	2010-03-29 16:13:16.000000000 -0400
@@ -19,6 +19,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/vbus_driver.h>
 
 MODULE_AUTHOR("Gregory Haskins");
Index: linux-2.6.34-rc2-mmotm-100324-1448/drivers/leds/leds-input.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/drivers/leds/leds-input.c	2010-03-29 09:18:22.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/drivers/leds/leds-input.c	2010-03-29 17:17:11.000000000 -0400
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/leds.h>
 #include <linux/input.h>
 
Index: linux-2.6.34-rc2-mmotm-100324-1448/drivers/input/misc/ad714x.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/drivers/input/misc/ad714x.c	2010-03-29 09:18:20.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/drivers/input/misc/ad714x.c	2010-03-29 17:17:55.000000000 -0400
@@ -6,6 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
+#include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/input.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/mixer_quirks.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/sound/usb/mixer_quirks.c	2010-03-29 09:18:21.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/mixer_quirks.c	2010-03-29 17:18:36.000000000 -0400
@@ -26,6 +26,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
 
Index: linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/quirks.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/sound/usb/quirks.c	2010-03-29 09:18:21.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/quirks.c	2010-03-29 17:19:07.000000000 -0400
@@ -15,6 +15,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
 
Index: linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/endpoint.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/sound/usb/endpoint.c	2010-03-29 09:18:21.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/endpoint.c	2010-03-29 17:19:28.000000000 -0400
@@ -16,6 +16,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
 #include <linux/usb/audio-v2.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/format.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/sound/usb/format.c	2010-03-29 09:18:21.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/format.c	2010-03-29 17:19:47.000000000 -0400
@@ -16,6 +16,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
 #include <linux/usb/audio-v2.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/drivers/hwmon/tmp102.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/drivers/hwmon/tmp102.c	2010-03-29 09:18:24.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/drivers/hwmon/tmp102.c	2010-03-29 17:21:13.000000000 -0400
@@ -20,6 +20,7 @@
 
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/kernel/debug/kdb/kdb_support.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/kernel/debug/kdb/kdb_support.c	2010-03-29 09:18:20.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/kernel/debug/kdb/kdb_support.c	2010-03-29 17:20:52.000000000 -0400
@@ -19,6 +19,7 @@
 #include <linux/vmalloc.h>
 #include <linux/ptrace.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/hardirq.h>
 #include <linux/delay.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/sound/soc/codecs/twl6040.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/sound/soc/codecs/twl6040.c	2010-03-29 09:18:21.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/sound/soc/codecs/twl6040.c	2010-03-29 17:20:12.000000000 -0400
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/drivers/input/misc/pcf8574_keypad.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/drivers/input/misc/pcf8574_keypad.c	2010-03-29 09:18:20.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/drivers/input/misc/pcf8574_keypad.c	2010-03-30 08:17:05.000000000 -0400
@@ -7,6 +7,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/drivers/misc/hwlat_detector.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/drivers/misc/hwlat_detector.c	2010-03-29 09:18:20.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/drivers/misc/hwlat_detector.c	2010-03-30 08:17:47.000000000 -0400
@@ -39,6 +39,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/ring_buffer.h>
 #include <linux/stop_machine.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/drivers/mtd/sm_ftl.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/drivers/mtd/sm_ftl.c	2010-03-29 09:18:22.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/drivers/mtd/sm_ftl.c	2010-03-30 08:17:27.000000000 -0400
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/hdreg.h>
 #include <linux/kthread.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/pcm.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/sound/usb/pcm.c	2010-03-29 09:18:21.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/pcm.c	2010-03-30 08:16:45.000000000 -0400
@@ -15,6 +15,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
 #include <linux/usb/audio-v2.h>
Index: linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/helper.c
===================================================================
--- linux-2.6.34-rc2-mmotm-100324-1448.orig/sound/usb/helper.c	2010-03-29 09:18:21.000000000 -0400
+++ linux-2.6.34-rc2-mmotm-100324-1448/sound/usb/helper.c	2010-03-30 08:24:50.000000000 -0400
@@ -16,6 +16,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 
 #include "usbaudio.h"


