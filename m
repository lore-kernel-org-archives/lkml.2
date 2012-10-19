Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab2JSK1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:27:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40701 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2JSK1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:27:10 -0400
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: "Porter, Matt" <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v3 00/16] DMA Engine support for AM33XX
Thread-Topic: [RFC PATCH v3 00/16] DMA Engine support for AM33XX
Thread-Index: AQHNrTQZOLq9jfMJNk+iV4vTK/FhGJfAWwaQ
Date: Fri, 19 Oct 2012 10:26:20 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EBD29FC@DBDE01.ent.ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
In-Reply-To: <1350566815-409-1-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.70]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Thu, Oct 18, 2012 at 18:56:39, Porter, Matt wrote:
> Changes since v2:
> 	- Rebased on 3.7-rc1
> 	- Fixed bug in DT/pdata parsing first found by Gururaja
> 	  that turned out to be masked by some toolchains
> 	- Dropped unused mach-omap2/devices.c hsmmc patch
> 	- Added AM33XX crossbar DMA event mux support
> 	- Added am335x-evm support
> 
> Changes since v1:
> 	- Rebased on top of mainline from 12250d8
> 	- Dropped the feature removal schedule patch
> 	- Implemented dma_request_slave_channel_compat() and
> 	  converted the mmc and spi drivers to use it
> 	- Dropped unneeded #address-cells and #size-cells from
> 	  EDMA DT support
> 	- Moved private EDMA header to linux/platform_data/ and
> 	  removed some unneeded definitions
> 	- Fixed parsing of optional properties
> 
> TODO:
> 	- Add dmaengine support for per-channel caps so the
> 	  hack to set the maximum segments can be replaced with
> 	  a query to the dmaengine driver
> 
> This series adds DMA Engine support for AM33xx, which uses
> an EDMA DMAC. The EDMA DMAC has been previously supported by only
> a private API implementation (much like the situation with OMAP
> DMA) found on the DaVinci family of SoCs.
> 
> The series applies on top of 3.7-rc1 and the following patches:
> 
> 	- GPMC fails to reserve memory fix:
> 	  http://www.spinics.net/lists/linux-omap/msg79675.html
> 	- TPS65910 regulator fix:
> 	  https://patchwork.kernel.org/patch/1593651/
> 	- dmaengine DT support from Vinod's dmaengine_dt branch in
> 	  git://git.infradead.org/users/vkoul/slave-dma.git since
> 	  027478851791df751176398be02a3b1c5f6aa824
> 
> The approach taken is similar to how OMAP DMA is being converted to
> DMA Engine support. With the functional EDMA private API already
> existing in mach-davinci/dma.c, we first move that to an ARM common
> area so it can be shared. Adding DT and runtime PM support to the
> private EDMA API implementation allows it to run on AM33xx. AM33xx
> *only* boots using DT so we leverage Jon's generic DT DMA helpers to
> register EDMA DMAC with the of_dma framework and then add support
> for calling the dma_request_slave_channel() API to both the mmc
> and spi drivers.
> 
> With this series both BeagleBone and the AM335x EVM have working
> MMC and SPI support.
> 
> This is tested on BeagleBone with a SPI framebuffer driver and MMC
> rootfs. A trivial gpio DMA event misc driver was used to test the
> crossbar DMA event support. It is also tested on the AM335x EVM
> with the onboard SPI flash and MMC rootfs. The branch at
> https://github.com/ohporter/linux/tree/edma-dmaengine-v3 has the
> complete series, dependencies, and some test drivers/defconfigs.
> 

I didn't see all the patches that you posted on edma-dmaengine-v3
but I do seem them on edma-dmaengine-am33xx-v3 branch.

I added a couple of patches to enable earlyprintk and build the DTB
appended kernel image uImage-dtb.am335x-evm

Here's what i see

[...]
[    0.128831] regulator-dummy: no parameters
[    0.130793] NET: Registered protocol family 16
[    0.131694] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.133030] omap-gpmc omap-gpmc: GPMC revision 6.0
[    0.153136] platform 49000000.edma: alias fck already exists
[    0.153176] platform 49000000.edma: alias fck already exists
[    0.153199] platform 49000000.edma: alias fck already exists
[    0.158184] OMAP GPIO hardware version 0.1
[    0.172844] No ATAGs?
[    0.172868] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.174282] genirq: Flags mismatch irq 28. 00000000 (edma) vs. 00000000 (edma)
[    0.174536] ------------[ cut here ]------------
[    0.174576] WARNING: at kernel/irq/manage.c:1211 __free_irq+0x9c/0x1c0()
[    0.174586] Trying to free already-free IRQ 28
[    0.174596] Modules linked in:
[    0.174645] [<c001b0e0>] (unwind_backtrace+0x0/0xf0) from [<c0042900>] (warn_slowpath_common+0x4c/0x64)
[    0.174668] [<c0042900>] (warn_slowpath_common+0x4c/0x64) from [<c00429ac>] (warn_slowpath_fmt+0x30/0x40)
[    0.174688] [<c00429ac>] (warn_slowpath_fmt+0x30/0x40) from [<c00a8298>] (__free_irq+0x9c/0x1c0)
[    0.174708] [<c00a8298>] (__free_irq+0x9c/0x1c0) from [<c00a8408>] (free_irq+0x4c/0xa8)
[    0.174739] [<c00a8408>] (free_irq+0x4c/0xa8) from [<c07976ec>] (edma_probe+0x93c/0xa24)
[    0.174770] [<c07976ec>] (edma_probe+0x93c/0xa24) from [<c03226d4>] (platform_drv_probe+0x18/0x1c)
[    0.174793] [<c03226d4>] (platform_drv_probe+0x18/0x1c) from [<c0321494>] (driver_probe_device+0x84/0x224)
[    0.174814] [<c0321494>] (driver_probe_device+0x84/0x224) from [<c03216c8>] (__driver_attach+0x94/0x98)
[    0.174834] [<c03216c8>] (__driver_attach+0x94/0x98) from [<c031fd60>] (bus_for_each_dev+0x50/0x7c)
[    0.174854] [<c031fd60>] (bus_for_each_dev+0x50/0x7c) from [<c0320bc4>] (bus_add_driver+0xa0/0x240)
[    0.174874] [<c0320bc4>] (bus_add_driver+0xa0/0x240) from [<c0321bfc>] (driver_register+0x78/0x144)
[    0.174896] [<c0321bfc>] (driver_register+0x78/0x144) from [<c03229a4>] (platform_driver_probe+0x18/0x9c)
[    0.174918] [<c03229a4>] (platform_driver_probe+0x18/0x9c) from [<c0008874>] (do_one_initcall+0x34/0x180)
[    0.174947] [<c0008874>] (do_one_initcall+0x34/0x180) from [<c055ad14>] (kernel_init+0x104/0x2b0)
[    0.174978] [<c055ad14>] (kernel_init+0x104/0x2b0) from [<c0013590>] (ret_from_fork+0x14/0x24)
[    0.175249] ---[ end trace 1b75b31a2719ed1c ]---
[    0.175354] edma: probe of 49000000.edma failed with error -16
[    0.253165] bio: create slab <bio-0> at 0
[    0.257894] edma-dma-engine edma-dma-engine.0: Can't allocate PaRAM dummy slot
[    0.257954] edma-dma-engine: probe of edma-dma-engine.0 failed with error -5
[    0.341189] omap-dma-engine omap-dma-engine: OMAP DMA engine driver
[    0.343155] vbat: 5000 mV
[    0.352193] SCSI subsystem initialized
[    0.354571] usbcore: registered new interface driver usbfs
[    0.355085] usbcore: registered new interface driver hub
[    0.355944] usbcore: registered new device driver usb
[    0.376170] omap_i2c 44e0b000.i2c: bus 0 rev2.4.0 at 400 kHz
[    0.384465] vrtc: 1800 mV
[    0.384897] vrtc: supplied by vbat
[    0.388130] vio: at 1800 mV
[    0.388284] vio: supplied by vbat
[    0.391570] vdd_mpu: 912 <--> 1312 mV at 1262 mV
[    0.391727] vdd_mpu: supplied by vbat
[    0.394747] vdd_core: 912 <--> 1150 mV at 1137 mV
[    0.394898] vdd_core: supplied by vbat
[    0.398155] vdd3: 5000 mV
[    0.400791] vdig1: at 1800 mV
[    0.400943] vdig1: supplied by vbat
[    0.403675] vdig2: at 1800 mV
[    0.403817] vdig2: supplied by vbat
[    0.407001] vpll: at 1800 mV
[    0.407151] vpll: supplied by vbat
[    0.410187] vdac: at 1800 mV
[    0.410352] vdac: supplied by vbat
[    0.413275] vaux1: at 1800 mV
[    0.413414] vaux1: supplied by vbat
[    0.416325] vaux2: at 3300 mV
[    0.416467] vaux2: supplied by vbat
[    0.419280] vaux33: at 3300 mV
[    0.419419] vaux33: supplied by vbat
[    0.422440] vmmc: 1800 <--> 3300 mV at 3300 mV
[    0.422583] vmmc: supplied by vbat
[    0.424630] tps65910 0-002d: No interrupt support, no core IRQ
[    0.432157] Bluetooth: Core ver 2.16
[    0.432767] NET: Registered protocol family 31
[    0.432785] Bluetooth: HCI device and connection manager initialized
[    0.432928] Bluetooth: HCI socket layer initialized
[    0.432965] Bluetooth: L2CAP socket layer initialized
[    0.433071] Bluetooth: SCO socket layer initialized
[    0.435116] cfg80211: Calling CRDA to update world regulatory domain
[    0.437286] Switching to clocksource gp_timer
[    0.585766] NET: Registered protocol family 2
[    0.587934] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.588322] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.592077] TCP: Hash tables configured (established 8192 bind 8192)
[    0.592331] TCP: reno registered
[    0.592369] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.592634] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.593454] NET: Registered protocol family 1
[    0.595290] RPC: Registered named UNIX socket transport module.
[    0.595315] RPC: Registered udp transport module.
[    0.595328] RPC: Registered tcp transport module.
[    0.595340] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.596399] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.596917] CPU PMU: probing PMU on CPU 0
[    0.597083] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 5 counters available
[    0.770294] VFS: Disk quotas dquot_6.5.2
[    0.770539] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.773244] NFS: Registering the id_resolver key type
[    0.773873] Key type id_resolver registered
[    0.773897] Key type id_legacy registered
[    0.774046] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.776552] msgmni has been set to 477
[    0.780591] io scheduler noop registered
[    0.780618] io scheduler deadline registered
[    0.780721] io scheduler cfq registered (default)
[    0.783750] pinctrl-single 44e10800.pinmux: 142 pins at pa f9e10800 size 568
[    0.788066] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.795200] omap_uart 44e09000.serial: did not get pins for uart0 error: -19
[    0.795696] 44e09000.serial: ttyO0 at MMIO 0x44e09000 (irq = 88) is a OMAP UART0
[    1.728556] console [ttyO0] enabled
[    1.769162] brd: module loaded
[    1.793083] loop: module loaded
[    1.802779] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.811045] OneNAND driver initializing
[    1.816279] omap2_mcspi 48030000.spi: pins are not configured from the driver
[   61.836153] INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 0, t=7682 jiffies)
[   61.845144] INFO: Stall ended before state dump start
[  241.875170] INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 0, t=30727 jiffies)
[  241.884226] INFO: Stall ended before state dump start
[  421.914230] INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 0, t=53772 jiffies)
[...]

Let me know if I missed something.

Regards,
Vaibhav
