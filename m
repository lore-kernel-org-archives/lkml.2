Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0LMXxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:53:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46038 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab0LMXxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:53:22 -0500
Date: Tue, 14 Dec 2010 08:53:27 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [BUG]: mmc: single thread workqueue very bad - breaks multiple
 PERMANENT CARDS
In-reply-to: <99511979-8115-4A02-9D1E-24F763C10622@marvell.com>
To: Philip Rakity <prakity@marvell.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Tejun Heo <tj@kernel.org>
Message-id: <4D06B1F7.3080308@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
References: <936C6DE2-6229-4BBE-8CFB-55A08EC6EB5B@marvell.com>
 <99511979-8115-4A02-9D1E-24F763C10622@marvell.com>
X-OriginalArrivalTime: 13 Dec 2010 23:53:19.0403 (UTC)
 FILETIME=[EAFEFFB0:01CB9B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philip.

I known that have kernel parameter.."rootwait"

Did you use "rootwait" or "rootdelay"?
I also need information about this problem..


Philip Rakity wrote:
> Needed to change in drivers/mmc/core
> 
>> create_singlethread_workqueue
> to
> create_workqueue 
> 
> to make multiple cards be detected at boot time.  
> 
> Logs with traces (not working and working) below.
> 
> This could be a bug in the mmc layer or in the workqueue code.
> 
> reposting to linux-list and linux-mmc for additional comments
> 
>>
>> I am trying to boot
>>
>> I have an external  SD card.
>>
>> I have a PERMANENT eMMC card on the board.  (BROKEN_CARD_DETECT set and POLLING OFF)
>> I have a PERMANENT sdio card on the board (BROKEN_CARD_DETECT set and POLLING OFF)
>> I am trying  to boot from the eMMC.
>>
>> in the arch directory if I init the SD controller first -- booting fails
>> if I init the eMMC SD booting works
>>
>> From the trace so far it looks like I cannot have 2 entries on the the workqueue for mmc_rescan.
>>
>> The sdhci driver sees 2 permanent slots and calls up to the mmc layer to handle initial card detect.
>>
>> I think the workqueue needs to check if work is pending and reschedule itself -- not sure how to do this.
>>
>> mmc_rescan is not being called -- any ideas ?
>>
>> trace below
>>
>> max8925-rtc max8925-rtc: rtc core: registered max8925-rtc as rtc0
>> [   89.784231] sdhci: Secure Digital Host Controller Interface driver
>> [   89.802610] sdhci: Copyright(c) Pierre Ossman
>> [   89.815573] mmc0: no vmmc regulator found
>> [   89.827627] mmc_start_host:mmc0: ENTER
>> [   89.838892] mmc_detect_change: mmc0: ENTER
>> [   89.851084] mmc_schedule_delayed_work: ENTER
>> [   89.863893] mmc_schedule_delayed_work: x = 1 EXIT
>> [   89.877922] mmc_rescan:mmc0: ENTER
>> [   89.888025] mmc0: mmc_rescan: trying to init card at 400000 Hz
>> [   89.905442] mmc_detect_change: mmc0: EXIT
>> [   89.917422] mmc0: SDHCI controller on MMC [sdhci-pxa.0] using DMA
>> [   89.935552] mmc1: no vmmc regulator found
>> [   89.950739] NOT SDIO/SD/MMC
>> [   89.959061] mmc_rescan:mmc0 FAIL
>> [   89.968661] mmc0: mmc_rescan: trying to init card at 300000 Hz
>> [   89.986039] mmc_start_host:mmc1: ENTER
>> [   89.997404] mmc_detect_change: mmc1: ENTER
>> [   90.009585] mmc_schedule_delayed_work: ENTER
>> [   90.025342] mmc_schedule_delayed_work: x = 1 EXIT
>> [   90.039396] NOT SDIO/SD/MMC
>> [   90.047703] mmc_rescan:mmc0 FAIL
>> [   90.057304] mmc0: mmc_rescan: trying to init card at 200000 Hz
>> [   90.074664] mmc_detect_change: mmc1: EXIT
>> [   90.086698] mmc1: SDHCI controller on MMC [sdhci-pxa.1] using DMA
>> [   90.104817] mmc2: no vmmc regulator found
>> [   90.119917] mmc_start_host:mmc2: ENTER
>> [   90.131280] NOT SDIO/SD/MMC
>> [   90.139585] mmc_rescan:mmc0 FAIL
>> [   90.149271] mmc0: mmc_rescan: trying to init card at 100000 Hz
>> [   90.166643] mmc_detect_change: mmc2: ENTER
>> [   90.178818] mmc_schedule_delayed_work: ENTER
>> [   90.191703] mmc_schedule_delayed_work: x = 1 EXIT
>> [   90.205696] mmc_detect_change: mmc2: EXIT
>> [   90.220729] NOT SDIO/SD/MMC
>> [   90.229042] mmc_rescan:mmc0 FAIL
>> [   90.238638] mmc2: SDHCI controller on MMC [sdhci-pxa.2] using DMA
>> [   90.256770] TCP cubic registered
>> [   90.256954] NET: Registered protocol family 17
>> [   90.279805] Registering the dns_resolver key type
>> [   90.293787] VFP support v0.3: implementor 56 architecture 2 part 20 variant 9 rev 5
>> [   90.318180] max8925-rtc max8925-rtc: setting system clock to 2007-02-05 22:39:20 UTC (1170715160)
>> [   90.344586] Waiting 5sec before mounting root device...
>> [   95.366580] Root-NFS: no NFS server address
>> [   95.379055] VFS: Unable to mount root fs via NFS, trying floppy.
>> [   95.397037] mmc_rescan:mmc1: ENTER
>> [   95.407528] VFS: Cannot open root device "mmcblk0p1" or unknown-block(2,0)
>> [   95.428065] mmc1: mmc_rescan: trying to init card at 400000 Hz
>> [   95.445444] Please append a correct "root=" boot option; here are the available partitions:
>> [   95.470345] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)
>> [   95.494941] [<c002a9a8>] (unwind_backtrace+0x0/0x128) from [<c0274dc8>] (panic+0x70/0x184)
>> [   95.519606] [<c0274dc8>] (panic+0x70/0x184) from [<c0008d50>] (mount_block_root+0x1cc/0x20c)
>> [   95.544688] [<c0008d50>] (mount_block_root+0x1cc/0x20c) from [<c0008e30>] (mount_root+0xa0/0xc0)
>> [   95.570868] [<c0008e30>] (mount_root+0xa0/0xc0) from [<c0008f6c>] (prepare_namespace+0x11c/0x174)
>> [   95.597260] [<c0008f6c>] (prepare_namespace+0x11c/0x174) from [<c0008444>] (kernel_init+0x110/0x150)
>> [   95.624473] [<c0008444>] (kernel_init+0x110/0x150) from [<c00260e0>] (kernel_thread_exit+0x0/0x8)
>>
>>
>>
>> The following change makes things work --- IS THIS SAFE  -?
>>
>> static int __init mmc_init(void)
>> {
>> 	int ret;
>>
>> #if 0
>> 	workqueue = create_singlethread_workqueue("kmmcd");
>> #else
>> 	workqueue = create_workqueue("kmmcd");
>> #endif
>> 	if (!workqueue)
>> 		return -ENOMEM;
>>
>>
>> [    1.680952] mousedev: PS/2 mouse device common for all mice
>> [    1.698753] max8925-rtc max8925-rtc: rtc core: registered max8925-rtc as rtc0
>> [    1.720238] sdhci: Secure Digital Host Controller Interface driver
>> [    1.738743] sdhci: Copyright(c) Pierre Ossman
>> [    1.751705] mmc0: no vmmc regulator found
>> [    1.763764] mmc_start_host:mmc0: ENTER
>> [    1.775028] mmc_detect_change: mmc0: work = df94bd50 ENTER
>> [    1.791367] mmc_schedule_delayed_work: work = df94bd50 ENTER
>> [    1.808194] mmc_rescan:mmc0: work = df94bd50 ENTER
>> [    1.822464] mmc_schedule_delayed_work: x = 1 EXIT
>> [    1.836436] mmc0: mmc_rescan: trying to init card at 400000 Hz
>> [    1.853812] mmc_detect_change: mmc0: EXIT
>> [    1.865717] mmc0: SDHCI controller on MMC [sdhci-pxa.0] using DMA
>> [    1.883843] mmc1: no vmmc regulator found
>> [    1.895867] mmc_start_host:mmc1: ENTER
>> [    1.907217] mmc_detect_change: mmc1: work = df94b950 ENTER
>> [    1.926684] NOT SDIO/SD/MMC
>> [    1.935001] mmc_schedule_delayed_work: work = df94b950 ENTER
>> [    1.951835] mmc_rescan:mmc0 FAIL
>> [    1.961423] mmc0: mmc_rescan: trying to init card at 300000 Hz
>> [    1.978795] mmc_schedule_delayed_work: x = 1 EXIT
>> [    1.992779] mmc_detect_change: mmc1: EXIT
>> [    2.004701] mmc1: SDHCI controller on MMC [sdhci-pxa.1] using DMA
>> [    2.023003] mmc2: no vmmc regulator found
>> [    2.034943] mmc_start_host:mmc2: ENTER
>> [    2.049483] NOT SDIO/SD/MMC
>> [    2.057800] mmc_detect_change: mmc2: work = df94b550 ENTER
>> [    2.074191] mmc_rescan:mmc0 FAIL
>> [    2.083788] mmc0: mmc_rescan: trying to init card at 200000 Hz
>> [    2.101161] mmc_schedule_delayed_work: work = df94b550 ENTER
>> [    2.117985] mmc_schedule_delayed_work: x = 1 EXIT
>> [    2.132036] mmc_detect_change: mmc2: EXIT
>> [    2.144059] mmc2: SDHCI controller on MMC [sdhci-pxa.2] using DMA
>> [    2.162384] TCP cubic registered
>> [    2.175181] NOT SDIO/SD/MMC
>> [    2.183513] NET: Registered protocol family 17
>> [    2.196730] mmc_rescan:mmc0 FAIL
>> [    2.206388] Registering the dns_resolver key type
>> [    2.220386] mmc0: mmc_rescan: trying to init card at 100000 Hz
>> [    2.237749] VFP support v0.3: implementor 56 architecture 2 part 20 variant 9 rev 5
>> [    2.262155] max8925-rtc max8925-rtc: setting system clock to 2007-02-05 23:22:44 UTC (1170717764)
>> [    2.288769] Waiting 5sec before mounting root device...
>> [    2.307747] NOT SDIO/SD/MMC
>> [    2.316086] mmc_rescan:mmc0 FAIL
>> [    2.325673] mmc_rescan:mmc1: work = df94b950 ENTER
>> [    2.339951] mmc1: mmc_rescan: trying to init card at 400000 Hz
>> [    2.399680] NOT SDIO/SD/MMC
>> [    2.408001] mmc_rescan:mmc1 FAIL
>> [    2.417581] mmc1: mmc_rescan: trying to init card at 300000 Hz
>> [    2.480967] NOT SDIO/SD/MMC
>> [    2.489284] mmc_rescan:mmc1 FAIL
>> [    2.498867] mmc1: mmc_rescan: trying to init card at 200000 Hz
>> [    2.563544] NOT SDIO/SD/MMC
>> [    2.563551] mmc_rescan:mmc1 FAIL
>> [    2.581423] mmc1: mmc_rescan: trying to init card at 100000 Hz
>> [    2.651318] NOT SDIO/SD/MMC
>> [    2.659632] mmc_rescan:mmc1 FAIL
>> [    2.669232] mmc_rescan:mmc2: work = df94b550 ENTER
>> [    2.683465] mmc2: mmc_rescan: trying to init card at 400000 Hz
>> [    2.777696] mmc2: new high speed MMC card at address 0001
>> [    2.794089] mmcblk0: mmc2:0001 SEM08G 7.39 GiB 
>> [    2.813042]  mmcblk0: p1
>> [    7.325888] EXT3-fs: barriers not enabled
>> [    7.398090] EXT3-fs (mmcblk0p1): 
>> [    7.407518] kjournald starting.  Commit interval 5 seconds
>> [    7.424361] warning: mounting unchecked fs, running e2fsck is recommended
>> [    7.445876] EXT3-fs (mmcblk0p1): using internal journal
>> [    7.455234] EXT3-fs (mmcblk0p1): recovery complete
>> [    7.476877] EXT3-fs (mmcblk0p1): mounted filesystem with ordered data mode
>> [    7.497416] VFS: Mounted root (ext3 filesystem) on device 179:1.
>> [    7.515291] Freeing init memory: 92K
>> init started:  BusyBox v1.01 (2009.03.10-14:28+0000) multi-call binary
>> mount: Mounting none on /tmp failed: No such file or directory
>> telnetd: daemon: No such file or directory
>> cannot open /dev/null
>> [    7.925389] udevd (57): /proc/57/oom_adj is deprecated, please use /proc/57/oom_score_adj instead.
>> cannot open /dev/null
>> error initializing udevd socket
>> modprobe: could not parse modules.dep
>>
>> cannot open /dev/null
>> error initializing udevd socket
>> cannot open /dev/null
>> error initializing udevd socket
>> cannot open /dev/null
>> error initializing udevd socket
>> [    9.061143] MTD: Attempt to mount non-MTD device "/dev/mmcblk0p1"
>> device '/dev/ttyS2' does not exist.
>> [    9.597226] MTD: Attempt to mount non-MTD device "/dev/mmcblk0p1"
>>
>>
>> BusyBox v1.01 (2009.03.10-14:28+0000) Built-in shell (ash)
>> Enter 'help' for a list of built-in commands.
>>
>>
>> Processing /etc/profile... ln: /var/dpf/target/: File exists
>> [   10.209832] MTD: Attempt to mount non-MTD device "/dev/mmcblk0p1"
>> error: cannot open /dev/i2c-user
>> error: cannot open /dev/i2c-user
>> insmod: /lib/modules/2.6.37-rc5-next-20101208-00003-g4ee4acc-dirty: No such file or directory
>> Using /lib/modules/galcore.ko
>> [   10.498543] galcore: version magic '2.6.28 mod_unload modversions ARMv5 ' should be '2.6.37-rc5-next-20101208-00003-g4ee4acc-dirty preempt mod_unload ARMv6 '
>> insmod: cannot insert `/lib/modules/galcore.ko': Invalid module format (-1): Exec format error
>> insmod: /lib/modules/2.6.37-rc5-next-20101208-00003-g4ee4acc-dirty: No such file or directory
>> insmod: sd8688.ko: no module by that name found
>> [   10.927510] MTD: Attempt to mount non-MTD device "/dev/mmcblk0p1"
>> VERIFY ID: numid=81,iface=MIXER,name=''
>> amixer: Control default open error: No such device
>>
>> VERIFY ID: numid=85,iface=MIXER,name=''
>> amixer: Control default open error: No such device
>>
>> VERIFY ID: numid=1,iface=MIXER,name=''
>> amixer: Control default open error: No such device
>>
>> VERIFY ID: numid=3,iface=MIXER,name=''
>> amixer: Control default open error: No such device
>>
>> VERIFY ID: numid=4,iface=MIXER,name=''
>> amixer: Control default open error: No such device
>>
>> Done
>>
>> Philip
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

