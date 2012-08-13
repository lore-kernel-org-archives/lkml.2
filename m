Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2HMOwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:52:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2HMOwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:52:19 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH v10 00/18] Introduce a led trigger for CPU activity and consolidate LED driver in ARM
Date: Mon, 13 Aug 2012 14:52:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, nicolas.pitre@linaro.org, olof@lixom.net
References: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
In-Reply-To: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208131452.08879.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:LptuJ0qgAP5xT+5ALhzpT4FIP6q5PIJblwzdozn8tpo
 HclE7tkY3taTOHQO1YnJFFjk0+dl92cthH4viCzHis7freQ6tu
 xmyBFxtMSdlYplVohQ89BtvKIo+QAoZOmuIadJEiu6ya9Gz2zB
 X5/HBXnYosRlIwY32gAdm4GFbacrmqZ8HQRxDqFVDHau6gA2Pt
 iD5f3riBhCi0RiyV8HFaXrGj/0xbMXqXKXY90hWa5pM0HXuzto
 cnrUPh9xuJIqAKQgCZUzKWX0OeWSuNDqPkpqP09PnGnG8TsWg+
 bPWF+hA5adeVqvImt/twI6SQ43dV7E+GBbu3ovKBjtKbEQsdfN
 vq0g/TWapEJ3xtTLXh8mcp2yadHdhPeV9MzJKGuLl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2012, Bryan Wu wrote:
> Based on Linus Walleij's ARM LED consolidation work, this patchset introduce a
> new generic led trigger for CPU not only for ARM but also for others.
> 
> For enabling CPU idle event, CPU arch code should call ledtrig_cpu() stub to
> trigger idle start or idle end event.
> 
> These patches convert old style LED driver in arch/arm to gpio_led or new led
> driver interface. Against 3.5 release and build successfully for all the machines.
> 
> Test ledtrig-cpu driver on OMAP4 Panda board.
> 
> Please find these patches here:
>        git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-arm-soc
> 

Pulled into the next/drivers branch again, and I verified that there
are no new build warnings or errors against v3.6-rc1 that are introduced
by this series. I got one simple merge conflict, see below for the
resolution.

Thanks for your persistence!

	Arnd

commit 19e4ab54e7f5fe46a3c931afa7e786f11d57b558
Merge: 0d7614f fa8bbb1
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon Aug 13 16:45:48 2012 +0200

    Merge branch 'for-arm-soc' of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds into next/drivers
    
    From Bryan Wu <bryan.wu@canonical.com>:
    
    Based on Linus Walleij's ARM LED consolidation work, this patchset introduce a
    new generic led trigger for CPU not only for ARM but also for others.
    
    For enabling CPU idle event, CPU arch code should call ledtrig_cpu() stub to
    trigger idle start or idle end event.
    
    These patches convert old style LED driver in arch/arm to gpio_led or new led
    driver interface. Against 3.5 release and build successfully for all the machines.
    
    Test ledtrig-cpu driver on OMAP4 Panda board.
    
    v9 --> v10
     * fix compiling issue on versatile_defconfig reported by Russell King
     * rebase to 3.5 kernel and move patches to new git tree
    
    v8 --> v9:
     * use mutex to replace rw_sema pointed out by Tim Gardner
     * add a new struct led_trigger_cpu
     * add lock_is_inited to record mutex lock initialization
    
    v6 --> v7:
     * add a patch to unify the led-trigger name
     * fix some typo pointed
     * use BUG_ON to detect CPU numbers during building stage
    
    v5 --> v6:
     * replace  __get_cpu_var() to per_cpu()
     * remove smp_processor_id() which is wrong with for_each_possible_cpu()
     * test on real OMAP4 Panda board
     * add comments about CPU hotplug in the CPU LED trigger driver
    
    v4 --> v5:
     * rebase all the patches on top of latest linux-next
     * replace on_each_cpu() with for_each_possible_cpu()
     * add some description of ledtrig_cpu() API
     * remove old leds code from driver nwflash.c, which should use a new led trigger then
     * this trigger driver can be built as module now
    
    v3 --> v4:
     * fix a typo pointed by Jochen Friedrich
     * fix some building errors
     * add Reviewed-by and Tested-by into patch log
    
    v2 --> v3:
     * almost rewrote the whole ledtrig-cpu driver, which is more simple
     * every CPU will have a per-CPU trigger
     * cpu trigger can be assigned to any leds
     * fix a lockdep issue in led-trigger common code
     * other fix according to review
    
    v1 --> v2:
     * remove select operations in Kconfig of every machines
     * add back supporting of led in core module of mach-integrator
     * solidate name scheme in ledtrig-cpu.c
     * add comments of CPU_LED_* cpu led events
     * fold patches of RealView and Versatile together
     * add machine_is_ check during assabet led driver init
     * add some Acked-by in patch logs
     * remove code for simpad machine in machine-sa11000, since Jochen Friedrich
       introduced gpiolib and gpio-led driver for simpad
     * on Assabet and Netwinder machine, LED operations is reversed like:
       setting bit means turn off leds
       clearing bit means turn on leds
     * add a new function to read CM_CTRL register for led driver
    
    * 'for-arm-soc' of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds:
      ARM: use new LEDS CPU trigger stub to replace old one
      ARM: mach-sa1100: retire custom LED code
      ARM: mach-omap1: retire custom LED code
      ARM: mach-pnx4008: remove including old leds event API header file
      ARM: plat-samsung: remove including old leds event API header file
      ARM: mach-pxa: retire custom LED code
      char: nwflash: remove old led event code
      ARM: mach-footbridge: retire custom LED code
      ARM: mach-ebsa110: retire custom LED code
      ARM: mach-clps711x: retire custom LED code of P720T machine
      ARM: mach-integrator: retire custom LED code
      ARM: mach-integrator: move CM_CTRL to header file for accessing by other functions
      ARM: mach-orion5x: convert custom LED code to gpio_led and LED CPU trigger
      ARM: mach-shark: retire custom LED code
      ARM: mach-ks8695: remove leds driver, since nobody use it
      ARM: mach-realview and mach-versatile: retire custom LED code
      ARM: at91: convert old leds drivers to gpio_led and led_trigger drivers
      led-triggers: create a trigger for CPU activity
    
    Conflicts:
    	arch/arm/mach-clps711x/p720t.c
    	arch/arm/mach-sa1100/leds-cerf.c
    	arch/arm/mach-sa1100/leds-lart.c
    
    Let's hope this is the last time we pull this and it doesn't cause
    more trouble. I have verified that version 10 causes no build
    warnings or errors any more, and the patches still look good.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --cc arch/arm/mach-clps711x/p720t.c
index f266d90,09113a9..b752b58
--- a/arch/arm/mach-clps711x/p720t.c
+++ b/arch/arm/mach-clps711x/p720t.c
@@@ -101,19 -115,70 +105,77 @@@ static void __init p720t_init_early(voi
  	PLD_CODEC = 0;
  	PLD_TCH   = 0;
  	PLD_SPI   = 0;
 -#ifndef CONFIG_DEBUG_LL
 -	PLD_COM2  = 0;
 -	PLD_COM1  = 0;
 -#endif
 -
 -	return 0;
 +	if (!IS_ENABLED(CONFIG_DEBUG_LL)) {
 +		PLD_COM2 = 0;
 +		PLD_COM1 = 0;
 +	}
  }
  
 -__initcall(p720t_hw_init);
 -
+ /*
+  * LED controled by CPLD
+  */
+ #if defined(CONFIG_NEW_LEDS) && defined(CONFIG_LEDS_CLASS)
+ static void p720t_led_set(struct led_classdev *cdev,
+ 			      enum led_brightness b)
+ {
+ 	u8 reg = clps_readb(PDDR);
+ 
+ 	if (b != LED_OFF)
+ 		reg |= 0x1;
+ 	else
+ 		reg &= ~0x1;
+ 
+ 	clps_writeb(reg, PDDR);
+ }
+ 
+ static enum led_brightness p720t_led_get(struct led_classdev *cdev)
+ {
+ 	u8 reg = clps_readb(PDDR);
+ 
+ 	return (reg & 0x1) ? LED_FULL : LED_OFF;
+ }
+ 
+ static int __init p720t_leds_init(void)
+ {
+ 
+ 	struct led_classdev *cdev;
+ 	int ret;
+ 
+ 	if (!machine_is_p720t())
+ 		return -ENODEV;
+ 
+ 	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+ 	if (!cdev)
+ 		return -ENOMEM;
+ 
+ 	cdev->name = "p720t:0";
+ 	cdev->brightness_set = p720t_led_set;
+ 	cdev->brightness_get = p720t_led_get;
+ 	cdev->default_trigger = "heartbeat";
+ 
+ 	ret = led_classdev_register(NULL, cdev);
+ 	if (ret	< 0) {
+ 		kfree(cdev);
+ 		return ret;
+ 	}
+ 
+ 	return 0;
+ }
+ 
+ /*
+  * Since we may have triggers on any subsystem, defer registration
+  * until after subsystem_init.
+  */
+ fs_initcall(p720t_leds_init);
+ #endif
++
 +MACHINE_START(P720T, "ARM-Prospector720T")
 +	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
 +	.atag_offset	= 0x100,
 +	.fixup		= fixup_p720t,
 +	.init_early	= p720t_init_early,
 +	.map_io		= p720t_map_io,
 +	.init_irq	= clps711x_init_irq,
 +	.timer		= &clps711x_timer,
 +	.restart	= clps711x_restart,
 +MACHINE_END
