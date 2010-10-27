Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233Ab0J0NY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:24:58 -0400
Received: from asmtpout023.mac.com ([17.148.16.98]:45554 "EHLO
	asmtpout023.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab0J0NYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:24:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010270044
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-27_06:2010-10-27,2010-10-27,1970-01-01 signatures=0
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: kernel BUG at drivers/mmc/core/sdio_io.c:28!
Date: Wed, 27 Oct 2010 17:24:04 +0400
Message-id: <652BFE86-3BFE-4E21-88BA-004CA7140D18@mac.com>
Cc: Benzy Gabay <benzyg@ti.com>, Luciano Coelho <luciano.coelho@nokia.com>,
        Vishal Mahaveer <vishalm@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
        I'm just trying to bring the LSR TiWi wl1271 wlan module up with Luca's wl12xx.git tree, which is based on with 2.6.36-rc8, and vijay's L23.I3.7 tiwlan drivers. 

When I try using the tiwlan driver, I get the following error:

 kernel BUG at drivers/mmc/core/sdio_io.c:28!

The code fragment looks like this:

/**
 *	sdio_claim_host - exclusively claim a bus for a certain SDIO function
 *	@func: SDIO function that will be accessed
 *
 *	Claim a bus for a set of operations. The SDIO function given
 *	is used to figure out which bus is relevant.
 */
void sdio_claim_host(struct sdio_func *func)
{
	BUG_ON(!func);
	BUG_ON(!func->card);

	mmc_claim_host(func->card->host);
}
EXPORT_SYMBOL_GPL(sdio_claim_host);


root@beagleboard:/wlan# insmod sdio.ko
[   92.668670] sdioDrv_init: Debug mode
[   92.673858] TI WiLink 1271 SDIO: Driver loaded
root@beagleboard:/wlan# insmod tiwlan_drv.ko
[  113.210571] TI WLAN: driver loading
[  113.236053] wifi_probe_irq: got wlan irq 215
[  113.254791] wifi_probe_irq: got wlan irq trigger falling flag
[  113.260589] dashboard20_wifi_set_carddetect: 0
[  113.283203] dashboard20_wifi_set_carddetect: Nobody to notify
[  113.298309] dashboard20_wifi_reset: 1
[  113.302581] dashboard20_wifi_power: 0
[  114.398345]  IRQ= 215 FLAGS= 2
root@beagleboard:/wlan# ./tiwlan_loader
root@beagleboard:/wlan# ifconfig -a
lo        Link encap:Local Loopback  
          LOOPBACK  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

tiwlan0   Link encap:Ethernet  HWaddr 00:00:00:00:00:00  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:100 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

usb0      Link encap:Ethernet  HWaddr 5E:8A:4F:3A:A9:25  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

root@beagleboard:/wlan# ifconfig tiwlan0 up
[  200.916687] TIWLAN: 2227.094325: pInitParams->RoamingScanning_2_4G_enable 0 
[  200.924530] dashboard20_wifi_power: 1
[  200.943267] dashboard20_wifi_power: 0
[  200.947937] dashboard20_wifi_power: 1
[  201.020507] dashboard20_wifi_reset: 0
[  201.024200] dashboard20_wifi_set_carddetect: 1
[  201.029113] dashboard20_wifi_set_carddetect: Nobody to notify
[  202.027465] tiwlan_sdio_probe not yet called
[  202.031768] tiwlan_sdio_probe not yet called
[  202.036590] kernel BUG at drivers/mmc/core/sdio_io.c:28!
[  202.041961] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[  202.050537] pgd = c6ccc000
[  202.053588] [00000000] *pgd=86d44031, *pte=00000000, *ppte=00000000
[  202.060241] Internal error: Oops: 817 [#1] PREEMPT
[  202.065063] last sysfs file: /sys/devices/platform/device_wifi.1/net/tiwlan0/flags
[  202.072662] Modules linked in: tiwlan_drv sdio
[  202.077178] CPU: 0    Tainted: G        W    (2.6.36-rc8-wl #21)
[  202.083221] PC is at __bug+0x1c/0x28
[  202.086822] LR is at __bug+0x18/0x28
[  202.090423] pc : [<c003fd34>]    lr : [<c003fd30>]    psr: 40000013
[  202.090454] sp : c6e81ba0  ip : c6e81b18  fp : 00000007
[  202.101989] r10: 00000001  r9 : 00000005  r8 : bf001174
[  202.107238] r7 : c774c000  r6 : 0001ffc4  r5 : 00000004  r4 : 00000002
[  202.113800] r3 : 00000000  r2 : c6e80000  r1 : c6e80000  r0 : 00000042
[  202.120361] Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  202.127532] Control: 10c5387d  Table: 86ccc019  DAC: 00000015
[  202.133331] Process ifconfig (pid: 836, stack limit = 0xc6e802f0)
[  202.139465] Stack: (0xc6e81ba0 to 0xc6e82000)
[  202.143859] 1ba0: c0540878 c0418968 c6e81b90 bf00074c c6e81bd6 c6e81bc0 c006e708 00000001
[  202.152069] 1bc0: 00000000 00000049 c6d32614 00000000 c76cf414 bf00cbec 00000001 00000001
[  202.160308] 1be0: 5d383637 bf0821f4 00000000 00000000 00000001 00000001 c06fbef8 0d09dc30
[  202.168548] 1c00: 000000c9 c06fb998 00000000 00000000 00000002 c76cf418 00000000 c6d32614
[  202.176757] 1c20: 00000001 c76cf414 c774c000 bf0824e0 c6e81c84 bf00045c bf000cc7 00000000
[  202.184997] 1c40: 00000000 c0068050 c074a34c 0000002e 0058f0fa 00000000 c773d7c0 00000004
[  202.193237] 1c60: 00000001 0001ffc8 00000013 c773488c c77348c8 00000002 c76cf414 c7734854
[  202.201446] 1c80: 00000005 00000001 c76cf414 bf081298 00000001 00000001 00000013 bf0822cc
[  202.209686] 1ca0: 00000000 c7734854 c76cf414 c7755814 c76cf414 c7755814 c76cf504 c76cf414
[  202.217926] 1cc0: c76cf540 bf0816cc c76cf540 c6e81cd8 00000000 c76cf450 c7755814 bf0801f0
[  202.226135] 1ce0: c774c000 bf0824e0 c6e81d6c c6e81cf8 c0544b9c c054495c 00000000 c6e55780
[  202.234375] 1d00: c7787014 000001bc 000001a4 00000000 00000000 c76cf450 c7755814 c76cf414
[  202.242614] 1d20: c76cf48c c76cf504 c76cf4c8 bf080684 00000000 c76cf57c bf009174 c7787014
[  202.250854] 1d40: 00000000 00000004 00000000 00000002 c774a014 c7787014 c7787724 bf07d9f8
[  202.259063] 1d60: 00000000 00000001 c6d3230c c6e81d78 bf009174 c054495c c7734854 c7787014
[  202.267303] 1d80: 00000050 00000000 00000000 00000002 c6d32304 c77f2200 c6d3230c bf07e07c
[  202.275543] 1da0: c7735050 00000000 c7786014 c7786014 00002000 bf068284 c6d32310 00000001
[  202.283752] 1dc0: c6d32304 00000001 00000000 00000000 c6d32214 bf00d374 00002000 c6d32310
[  202.291992] 1de0: c7667a80 00000000 c6d32310 c6d322c8 00000000 c6d3242c 00000006 c6d32414
[  202.300231] 1e00: 00000000 00000001 00000000 c6e81eb0 0001b4b4 bf083c78 c6e81eb0 bf009694
[  202.308441] 1e20: c6d32214 c6e22800 00001043 00001002 c0794020 bf00db00 00001043 00001002
[  202.316680] 1e40: c77f2200 bf0086d8 00000000 c6e22800 bf092738 c046071c c045e834 c6e22800
[  202.324920] 1e60: 00000041 c045e9c8 00000000 c6e22800 00001002 becd2af8 00008914 c0460630
[  202.333160] 1e80: c6e80000 00000001 becd2af8 c04b5018 00000000 becd2af8 00000020 c6e81ec0
[  202.341369] 1ea0: c76fe400 c76fe40c c6e22800 00000000 6c776974 00306e61 00000000 00000000
[  202.349609] 1ec0: becd1043 0000002c 00000070 00000002 becd1043 0000002c 00000070 00000002
[  202.357849] 1ee0: becd1002 00008914 00000004 becd2af8 c0794020 c003cba4 c6e80000 becd2bd0
[  202.366058] 1f00: 0001b4b4 c044cebc becd2af8 c72391a0 00000004 c6d47980 becd2af8 c012f13c
[  202.374298] 1f20: 00000005 00000000 c70f8100 00000001 00000004 00000000 c01328d8 c7400b80
[  202.382537] 1f40: c7415000 00000005 00000000 c044e410 00012c1c fffffffe c07050d0 c0704f7c
[  202.390747] 1f60: c6d47fe0 00000004 becd2af8 00008914 c6d47980 c003cba4 c6e80000 becd2bd0
[  202.398986] 1f80: 0001b4b4 c012f6e4 00000000 00000000 0001b5b8 becd2af8 becd2bd0 00000041
[  202.407226] 1fa0: 00000036 c003ca20 becd2af8 becd2bd0 00000004 00008914 becd2af8 00001002
[  202.415435] 1fc0: becd2af8 becd2bd0 00000041 00000036 00000000 00000000 becd2bd0 0001b4b4
[  202.423675] 1fe0: 0001b6ac becd2af8 00009368 4019463c 60000010 00000004 00000000 00000000
[  202.431915] [<c003fd34>] (__bug+0x1c/0x28) from [<c0418968>] (sdio_claim_host+0x3c/0x4c)
[  202.440093] [<c0418968>] (sdio_claim_host+0x3c/0x4c) from [<bf00074c>] (sdioDrv_WriteSync+0x28/0xd0 [sdio])
[  202.450469] [<bf00074c>] (sdioDrv_WriteSync+0x28/0xd0 [sdio]) from [<bf00cbec>] (sdioAdapt_Transact+0x48/0x4c [tiwlan_drv])
[  202.462402] [<bf00cbec>] (sdioAdapt_Transact+0x48/0x4c [tiwlan_drv]) from [<bf0821f4>] (busDrv_SendTxnParts+0x120/0x300 [tiwlan_drv])
[  202.475341] [<bf0821f4>] (busDrv_SendTxnParts+0x120/0x300 [tiwlan_drv]) from [<bf0824e0>] (busDrv_Transact+0x10c/0x344 [tiwlan_drv])
[  202.488189] [<bf0824e0>] (busDrv_Transact+0x10c/0x344 [tiwlan_drv]) from [<bf081298>] (txnQ_Scheduler+0x8c/0x3e8 [tiwlan_drv])
[  202.500488] [<bf081298>] (txnQ_Scheduler+0x8c/0x3e8 [tiwlan_drv]) from [<bf0816cc>] (txnQ_RunScheduler+0xd8/0x194 [tiwlan_drv])
[  202.512878] [<bf0816cc>] (txnQ_RunScheduler+0xd8/0x194 [tiwlan_drv]) from [<bf0801f0>] (twIf_SendTransaction+0xac/0x274 [tiwlan_drv])
[  202.525787] [<bf0801f0>] (twIf_SendTransaction+0xac/0x274 [tiwlan_drv]) from [<bf080684>] (twIf_SetPartition+0x118/0x294 [tiwlan_drv])
[  202.538787] [<bf080684>] (twIf_SetPartition+0x118/0x294 [tiwlan_drv]) from [<bf07d9f8>] (hwInit_BootSm+0x91c/0xf50 [tiwlan_drv])
[  202.551269] [<bf07d9f8>] (hwInit_BootSm+0x91c/0xf50 [tiwlan_drv]) from [<bf07e07c>] (hwInit_Boot+0x50/0x5c [tiwlan_drv])
[  202.562988] [<bf07e07c>] (hwInit_Boot+0x50/0x5c [tiwlan_drv]) from [<bf068284>] (TWD_InitHw+0x70/0x100 [tiwlan_drv])
[  202.574127] [<bf068284>] (TWD_InitHw+0x70/0x100 [tiwlan_drv]) from [<bf00d374>] (drvMain_SmEvent+0x57c/0x9f8 [tiwlan_drv])
[  202.585876] [<bf00d374>] (drvMain_SmEvent+0x57c/0x9f8 [tiwlan_drv]) from [<bf083c78>] (context_DriverTask+0x98/0x100 [tiwlan_drv])
[  202.598297] [<bf083c78>] (context_DriverTask+0x98/0x100 [tiwlan_drv]) from [<bf00db00>] (drvMain_InsertAction+0x78/0x114 [tiwlan_drv])
[  202.610839] [<bf00db00>] (drvMain_InsertAction+0x78/0x114 [tiwlan_drv]) from [<bf0086d8>] (wlanDrvIf_Start+0x34/0x7c [tiwlan_drv])
[  202.622833] [<bf0086d8>] (wlanDrvIf_Start+0x34/0x7c [tiwlan_drv]) from [<c046071c>] (__dev_open+0xb4/0x100)
[  202.632659] [<c046071c>] (__dev_open+0xb4/0x100) from [<c045e9c8>] (__dev_change_flags+0x80/0x140)
[  202.641693] [<c045e9c8>] (__dev_change_flags+0x80/0x140) from [<c0460630>] (dev_change_flags+0x10/0x48)
[  202.651153] [<c0460630>] (dev_change_flags+0x10/0x48) from [<c04b5018>] (devinet_ioctl+0x724/0x754)
[  202.660278] [<c04b5018>] (devinet_ioctl+0x724/0x754) from [<c044cebc>] (sock_ioctl+0x78/0x270)
[  202.668945] [<c044cebc>] (sock_ioctl+0x78/0x270) from [<c012f13c>] (do_vfs_ioctl+0x84/0x5f4)
[  202.677459] [<c012f13c>] (do_vfs_ioctl+0x84/0x5f4) from [<c012f6e4>] (sys_ioctl+0x38/0x60)
[  202.685760] [<c012f6e4>] (sys_ioctl+0x38/0x60) from [<c003ca20>] (ret_fast_syscall+0x0/0x30)
[  202.694274] Code: e1a01000 e59f000c eb140016 e3a03000 (e5833000) 
[  202.704986] ---[ end trace eacf7fa410f93d66 ]---
Segmentation fault
root@beagleboard:/wlan# [  205.832153] mmci-omap-hs mmci-omap-hs.0: mmc_fclk: enabled
[  205.837677] mmci-omap-hs mmci-omap-hs.0: context was not lost
[  205.844085] mmc0: starting CMD25 arg 64738a00 flags 000000b5
[  205.850128] mmc0:     blksz 512 blocks 8 flags 00000100 tsac 300 ms nsac 0
[  205.857360] mmc0:     CMD12 arg 00000000 flags 0000049d
[  205.862670] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD25, argument 0x64738a00
[  205.869964] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  205.875305] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  205.880645] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD12, argument 0x00000000
[  205.887542] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  205.979309] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  205.984680] mmc0: req done (CMD25): 0: 00000900 00000000 00000000 00000000
[  205.991577] mmc0:     4096 bytes transferred: 0
[  205.996154] mmc0:     (CMD12): 0: 00000c00 00000000 00000000 00000000
[  206.002746] mmc0: starting CMD13 arg b8740000 flags 00000015
[  206.009338] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD13, argument 0xb8740000
[  206.016510] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  206.021881] mmc0: req done (CMD13): 0: 00000900 00000000 00000000 00000000
[  206.030670] mmc0: starting CMD25 arg 329f9a00 flags 000000b5
[  206.036865] mmc0:     blksz 512 blocks 64 flags 00000100 tsac 300 ms nsac 0
[  206.044219] mmc0:     CMD12 arg 00000000 flags 0000049d
[  206.049591] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD25, argument 0x329f9a00
[  206.056915] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  206.064880] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  206.070220] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD12, argument 0x00000000
[  206.077117] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  206.148773] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  206.154144] mmc0: req done (CMD25): 0: 00000900 00000000 00000000 00000000
[  206.161071] mmc0:     32768 bytes transferred: 0
[  206.165710] mmc0:     (CMD12): 0: 00000c00 00000000 00000000 00000000
[  206.173004] mmc0: starting CMD13 arg b8740000 flags 00000015
[  206.179046] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD13, argument 0xb8740000
[  206.186187] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  206.191528] mmc0: req done (CMD13): 0: 00000900 00000000 00000000 00000000
[  206.200317] mmc0: starting CMD25 arg 32a01a00 flags 000000b5
[  206.206024] mmc0:     blksz 512 blocks 8 flags 00000100 tsac 300 ms nsac 0
[  206.213531] mmc0:     CMD12 arg 00000000 flags 0000049d
[  206.219177] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD25, argument 0x32a01a00
[  206.226440] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  206.231781] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  206.237121] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD12, argument 0x00000000
[  206.244018] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  206.249389] mmci-omap-hs mmci-om61627] mmc0:     4096 bytes transferred: 0
[  206.266204] mmc0:     (CMD12): 0: 00000c00 00000000 00000000 00000000
[  206.276397] mmc0: starting CMD13 arg b8740000 flags 00000015
[  206.282531] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD13, argument 0xb8740000
[  206.289733] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  206.295104] mmc0: req done (CMD13): 0: 00000900 00000000 00000000 00000000
[  206.418090] mmci-omap-hs mmci-omap-hs.0: mmc_fclk: disabled
[  229.113708] mmci-omap-hs mmci-omap-hs.0: mmc_fclk: enabled
[  229.119262] mmci-omap-hs mmci-omap-hs.0: context was not lost
[  229.125640] mmc0: starting CMD25 arg 3a7b1a00 flags 000000b5
[  229.131713] mmc0:     blksz 512 blocks 16 flags 00000100 tsac 300 ms nsac 0
[  229.139038] mmc0:     CMD12 arg 00000000 flags 0000049d
[  229.144653] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD25, argument 0x3a7b1a00
[  229.151489] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.157226] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.162597] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD12, argument 0x00000000
[  229.169464] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.236358] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.241729] mmc0: req done (CMD25): 0: 00000900 00000000 00000000 00000000
[  229.248657] mmc0:     8192 bytes transferred: 0
[  229.253204] mmc0:     (CMD12): 0: 00000c00 00000000 00000000 00000000
[  229.262176] mmc0: starting CMD13 arg b8740000 flags 00000015
[  229.267883] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD13, argument 0xb8740000
[  229.275360] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.280700] mmc0: req done (CMD13): 0: 00000900 00000000 00000000 00000000
[  229.289154] mmc0: starting CMD25 arg 5a73fa00 flags 000000b5
[  229.295288] mmc0:     blksz 512 blocks 8 flags 00000100 tsac 300 ms nsac 0
[  229.302551] mmc0:     CMD12 arg 00000000 flags 0000049d
[  229.307861] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD25, argument 0x5a73fa00
[  229.315155] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.320495] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.325836] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD12, argument 0x00000000
[  229.332733] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.403961] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.409332] mmc0: req done (CMD25): 0: 00000900 00000000 00000000 00000000
[  229.416229] mmc0:     4096 bytes transferred: 0
[  229.420806] mmc0:     (CMD12): 0: 00000c00 00000000 00000000 00000000
[  229.427398] mmc0: starting CMD13 arg b8740000 flags 00000015
[  229.433105] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD13, argument 0xb8740000
[  229.442871] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.448242] mmc0: req done (CMD13): 0: 00000900 00000000 00000000 00000000
[  229.455871] mmc0: starting CMD25 arg 02738a00 flags 000000b5
[  229.461944] mmc0:     blksz 512 blocks 16 flags 00000100 tsac 300 ms nsac 0
[  229.469360] mmc0:     CMD12 arg 00000000 flags 0000049d
[  229.474975] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD25, argument 0x02738a00
[  229.482147] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.487548] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.492889] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD12, argument 0x00000000
[  229.499786] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.566223] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.571594] mmc0: req done (CMD25): 0: 00000900 00000000 00000000 00000000
[  229.578491] mmc0:     8192 bytes transferred: 0
[  229.583068] mmc0:     (CMD12): 0: 00000c00 00000000 00000000 00000000
[  229.589660] mmc0: starting CMD13 arg b8740000 flags 00000015
[  229.596221] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD13, argument 0xb8740000
[  229.603393] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.608764] mmc0: req done (CMD13): 0: 00000900 00000000 00000000 00000000
[  229.617187] mmc0: starting CMD25 arg 5a744a00 flags 000000b5
[  229.623291] mmc0:     blksz 512 blocks 8 flags 00000100 tsac 300 ms nsac 0
[  229.630584] mmc0:     CMD12 arg 00000000 flags 0000049d
[  229.635864] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD25, argument 0x5a744a00
[  229.643157] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.648498] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.653839] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD12, argument 0x00000000
[  229.660736] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.666107] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.671447] mmc0: req done (CMD25): 0: 00000900 00000000 00000000 00000000
[  229.678344] mmc0:     4096 bytes transferred: 0
[  229.682922] mmc0:     (CMD12): 0: 00000c00 00000000 00000000 00000000
[  229.693328] mmc0: starting CMD13 arg b8740000 flags 00000015
[  229.699890] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD13, argument 0xb8740000
[  229.706726] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.712097] mmc0: req done (CMD13): 0: 00000900 00000000 00000000 00000000
[  229.719818] mmc0: starting CMD25 arg 62738a00 flags 000000b5
[  229.725921] mmc0:     blksz 512 blocks 8 flags 00000100 tsac 300 ms nsac 0
[  229.733154] mmc0:     CMD12 arg 00000000 flags 0000049d
[  229.738739] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD25, argument 0x62738a00
[  229.745605] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.750946] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.756286] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD12, argument 0x00000000
[  229.763183] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.832336] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.837707] mmc0: req done (CMD25): 0: 00000900 00000000 00000000 00000000
[  229.844635] mmc0:     4096 bytes transferred: 0
[  229.849182] mmc0:     (CMD12): 0: 00000c00 00000000 00000000 00000000
[  229.855773] mmc0: starting CMD13 arg b8740000 flags 00000015
[  229.861480] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD13, argument 0xb8740000
[  229.869171] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.874542] mmc0: req done (CMD13): 0: 00000900 00000000 00000000 00000000
[  229.883026] mmc0: starting CMD25 arg 6273aa00 flags 000000b5
[  229.889160] mmc0:     blksz 512 blocks 8 flags 00000100 tsac 300 ms nsac 0
[  229.896423] mmc0:     CMD12 arg 00000000 flags 0000049d
[  229.901733] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD25, argument 0x6273aa00
[  229.909027] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.914367] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.919708] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD12, argument 0x00000000
[  229.926605] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.931945] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 2
[  229.937286] mmc0: req done (CMD25): 0: 00000900 00000000 00000000 00000000
[  229.944213] mmc0:     4096 bytes transferred: 0
[  229.948760] mmc0:     (CMD12): 0: 00000c00 00000000 00000000 00000000
[  229.959075] mmc0: starting CMD13 arg b8740000 flags 00000015
[  229.965179] mmci-omap-hs mmci-omap-hs.0: mmc0: CMD13, argument 0xb8740000
[  229.972045] mmci-omap-hs mmci-omap-hs.0: IRQ Status is 1
[  229.977386] mmc0: req done (CMD13): 0: 00000900 00000000 00000000 00000000
[  230.113403] mmci-omap-hs mmci-omap-hs.0: mmc_fclk: disabled
[  599.822174] omapdss CORE: save context


Best regards,

Elvis Dowson
