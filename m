Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1EIPll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:41:41 -0400
Received: from filoni2.nine.ch ([94.230.212.32]:33148 "EHLO mail.lenux.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab1EIPlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:41:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 09 May 2011 17:41:36 +0200
From: jdossantos@docs.homelinux.org
To: Hank Janssen <hjanssen@microsoft.com>, KY Srinivasan <kys@microsoft.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?Q?BLKVSC=5FDRV=3A=20blkvsc=5Fprobe=28=29=20ERROR!!=20regi?=
 =?UTF-8?Q?ster=5Fblkdev=28=29=20failed!=20ret=20-=31=36?=
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C562498A5DD5@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <0e67fbb5ce27bd8d1210f0b7b8d5069c@docs.homelinux.org>
 <8AFC7968D54FB448A30D8F38F259C562498A3FF3@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <42a623fd771f05f5bcabec8d632673e3@docs.homelinux.org>
 <f814458e9b05dd1d3f22c5bffa3ea18a@docs.homelinux.org>
 <8AFC7968D54FB448A30D8F38F259C562498A5DD5@TK5EX14MBXC114.redmond.corp.microsoft.com>
Message-ID: <31ee5b3c687d844bf9806e5035874e7a@docs.homelinux.org>
User-Agent: Roundcube Webmail/0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hello

 I am using the stable 2.6.38.5 kernel with hyper-v modules enabled. I 
 get always this error on boot and if I enable hv_blkvsc with modprobe:

 [    7.117924] STORVSC: BEGIN_INITIALIZATION_OPERATION...
 [    7.118592] STORVSC: QUERY_PROTOCOL_VERSION_OPERATION...
 [    7.119247] STORVSC: QUERY_PROPERTIES_OPERATION...
 [    7.120065] STORVSC: END_INITIALIZATION_OPERATION...
 [    7.121033] STORVSC: **** storage channel up and running!! ****
 [    7.121382] register_blkdev: cannot get major 3 for ide
 [    7.121697] BLKVSC_DRV: blkvsc_probe() ERROR!! register_blkdev() 
 failed! ret -16
 [    7.122034] STORVSC: disabling storage device (ffff88003c6c2540)...
 [    7.122360] STORVSC: removing storage device (ffff88003c6c2540)...
 [    7.122676] STORVSC: storage device (ffff88003c6c2540) safe to 
 remove
 [    7.123343] VMBUS_DRV: vmbus_probe() ERROR!! probe() failed for 
 device vmbus_0_9 (ffff88003bd620c0) on driver blkvsc (-16)...
 [    7.124070] blkvsc: probe of vmbus_0_9 failed with error -16
 [    7.124412] VMBUS_DRV: vmbus_child_device_register() ERROR!! unable 
 to register child device (ffff88003bd620c0)
 [    7.124750] VMBUS: vmbus_process_offer() ERROR!! unable to add child 
 device object (relid 1)
 [    7.125112] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}

 here is the complete log:

 [    3.516112] hv_vmbus: module is from the staging directory, the 
 quality is unknown, you have been warned.
 [    3.518627] VMBUS_DRV: Vmbus initializing.... current log level 
 0x1f1f0006 (1f1f,6)
 [    3.519330] VMBUS: +++++++ HV Driver version = 3.1 +++++++
 [    3.519968] VMBUS: +++++++ Vmbus supported version = 13 +++++++
 [    3.520598] VMBUS: +++++++ Vmbus using SINT 2 +++++++
 [    3.521220] VMBUS: Windows hypervisor detected! Retrieving more 
 info...
 [    3.521827] VMBUS: Vendor ID: Microsoft Hv
 [    3.522427] VMBUS: Interface ID: Hv#1
 [    3.523054] VMBUS: OS Build:7601-6.1-17-0.17514
 [    3.523952] hv_vmbus: module is from the staging directory, the 
 quality is unknown, you have been warned.
 [    3.562837] VMBUS: Hypercall page VA=ffffc90000698000, PA=0x3cc02000
 [    3.564736] VMBUS_DRV: irq 0x5 vector 0x35
 [    3.565484] VMBUS: SynIC version: 1
 [    3.566578] VMBUS: Vmbus connected!!
 [    3.567613] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={c5295816-f63a-4d5f-8d1a4daf999ca185}
 [    3.568640] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={c5295816-f63a-4d5f-8d1a4daf999ca185}
 [    3.569484] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={c5295816-f63a-4d5f-8d1a4daf999ca185}
 [    3.570576] VMBUS: Channel offer notification - child relid 1 
 monitor id 0 allocated 1, type {32412632-86cb-44a2-9b5c50d1417354f5} 
 instance {00000000-0000-8899-0000000000000000}
 [    3.599128] hv_timesource: module is from the staging directory, the 
 quality is unknown, you have been warned.
 [    3.600004] Registering HyperV clock source
 [    3.600670] Switching to clocksource hyperv_clocksource
 [    3.614612] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    3.615370] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    3.616158] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    3.616852] VMBUS_DRV: child device (ffff880030360cc0) registered
 [    3.617736] VMBUS: Channel offer notification - child relid 2 
 monitor id 255 allocated 0, type {cfa8b69e-5b4a-4cc0-b98b8ba1a1f3f95a} 
 instance {58f75a6d-d949-4320-99e1a2a2576d581c}
 [    3.619418] input: Power Button as 
 /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
 [    3.620284] ACPI: Power Button [PWRF]
 [    3.625003] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={cfa8b69e-5b4a-4cc0-b98b8ba1a1f3f95a}
 [    3.625767] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={cfa8b69e-5b4a-4cc0-b98b8ba1a1f3f95a}
 [    3.626525] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={cfa8b69e-5b4a-4cc0-b98b8ba1a1f3f95a}
 [    3.627238] VMBUS_DRV: child device (ffff8800303654c0) registered
 [    3.627866] VMBUS: Channel offer notification - child relid 4 
 monitor id 255 allocated 0, type {57164f39-9115-4e78-ab55382f3bd5422d} 
 instance {fd149e91-82e0-4a7d-afa62a4166cbd7c0}
 [    3.629192] piix4_smbus 0000:00:07.3: SMBus base address 
 uninitialized - upgrade BIOS or use force_addr=0xaddr
 [    3.630097] ACPI: acpi_idle registered with cpuidle
 [    3.637139] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={57164f39-9115-4e78-ab55382f3bd5422d}
 [    3.644455] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={57164f39-9115-4e78-ab55382f3bd5422d}
 [    3.645335] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={57164f39-9115-4e78-ab55382f3bd5422d}
 [    3.646819] VMBUS_DRV: child device (ffff880030364cc0) registered
 [    3.647487] VMBUS: Channel offer notification - child relid 5 
 monitor id 255 allocated 0, type {0e0b6031-5213-4934-818b38d90ced39db} 
 instance {b6650ff7-33bc-4840-8048e0676786f393}
 [    3.648834] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={0e0b6031-5213-4934-818b38d90ced39db}
 [    3.649577] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={0e0b6031-5213-4934-818b38d90ced39db}
 [    3.650332] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={0e0b6031-5213-4934-818b38d90ced39db}
 [    3.651058] VMBUS_DRV: child device (ffff8800303650c0) registered
 [    3.651468] VMBUS: Channel offer notification - child relid 6 
 monitor id 255 allocated 0, type {9527e630-d0ae-497b-adcee80ab0175caf} 
 instance {2dd1ce17-079e-403c-b352a1921ee207ee}
 [    3.652687] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={9527e630-d0ae-497b-adcee80ab0175caf}
 [    3.654270] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={9527e630-d0ae-497b-adcee80ab0175caf}
 [    3.655900] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={9527e630-d0ae-497b-adcee80ab0175caf}
 [    3.658037] VMBUS_DRV: child device (ffff8800303644c0) registered
 [    3.658733] VMBUS: Channel offer notification - child relid 7 
 monitor id 1 allocated 1, type {ba6163d9-04a1-4d29-b60572e2ffb1dc7f} 
 instance {4fb6d35f-f9d0-49e7-9d9917cfb16ab18e}
 [    3.659676] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={ba6163d9-04a1-4d29-b60572e2ffb1dc7f}
 [    3.660485] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={ba6163d9-04a1-4d29-b60572e2ffb1dc7f}
 [    3.661416] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={ba6163d9-04a1-4d29-b60572e2ffb1dc7f}
 [    3.662278] VMBUS_DRV: child device (ffff880030365cc0) registered
 [    3.663303] VMBUS: Channel offer notification - child relid 8 
 monitor id 2 allocated 1, type {f8615163-df3e-46c5-913ff2d2f965ed0e} 
 instance {4e4aafbd-b96c-4b7a-932ac50a9082637a}
 [    3.664149] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={f8615163-df3e-46c5-913ff2d2f965ed0e}
 [    3.664542] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={f8615163-df3e-46c5-913ff2d2f965ed0e}
 [    3.664986] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={f8615163-df3e-46c5-913ff2d2f965ed0e}
 [    3.665505] VMBUS_DRV: child device (ffff8800303660c0) registered
 [    3.665968] VMBUS: channel <ffff88003bbf3e00> open success!!
 [    3.666894] VMBUS: Heartbeat channel functionality initialized
 [    3.667694] VMBUS: channel <ffff88003bbf3a00> open success!!
 [    3.668650] VMBUS: Shutdown channel functionality initialized
 [    3.669341] VMBUS: channel <ffff88003babae00> open success!!
 [    3.670032] VMBUS: Timesync channel functionality initialized
 [    3.672252] hv_netvsc: module is from the staging directory, the 
 quality is unknown, you have been warned.
 [    3.674566] NETVSC_DRV: Netvsc initializing....
 [    3.675285] VMBUS_DRV: child driver (ffffffffa020a2b0) registering - 
 name netvsc
 [    3.676064] VMBUS_DRV: device object (ffff880030366048) set to 
 driver object (ffffffffa020a340)
 [    3.677052] VMBUS: channel <ffff88003bab9600> open success!!
 [    3.677812] NETVSC: *** NetVSC channel opened successfully! ***
 [    3.678541] NETVSC: Sending NvspMessageTypeInit...
 [    3.679260] NETVSC: NvspMessageTypeInit status(1) max mdl chain (34)
 [    3.679939] NETVSC: Sending NvspMessage1TypeSendNdisVersion...
 [    3.680761] NETVSC: Establishing receive buffer's GPADL...
 [    3.681291] NETVSC: Sending NvspMessage1TypeSendReceiveBuffer...
 [    3.682497] NETVSC: Receive sections info (count 1, offset 0, 
 endoffset 1048000, suballoc size 1600, num suballocs 655)
 [    3.683131] NETVSC: Establishing send buffer's GPADL...
 [    3.689950] NETVSC: Sending NvspMessage1TypeSendSendBuffer...
 [    3.690549] NETVSC: *** NetVSC channel handshake result - 0 ***
 [    3.691235] NETVSC: Device 0xffff88003bde5c40 mac addr 
 00:15:5d:21:87:84
 [    3.691602] NETVSC: Device 0xffff88003bde5c40 link state up
 [    3.692293] eth0: Dropping NETIF_F_SG since no checksum feature.
 [    3.694538] VMBUS: Channel offer notification - child relid 1 
 monitor id 0 allocated 1, type {32412632-86cb-44a2-9b5c50d1417354f5} 
 instance {00000000-0000-8899-0000000000000000}
 [    3.694976] hv_utils: module is from the staging directory, the 
 quality is unknown, you have been warned.
 [    3.695862] Registering HyperV Utility Driver
 [    3.697312] VMBUS: Channel offer notification - child relid 2 
 monitor id 255 allocated 0, type {cfa8b69e-5b4a-4cc0-b98b8ba1a1f3f95a} 
 instance {58f75a6d-d949-4320-99e1a2a2576d581c}
 [    3.698144] VMBUS: Channel offer notification - child relid 4 
 monitor id 255 allocated 0, type {57164f39-9115-4e78-ab55382f3bd5422d} 
 instance {fd149e91-82e0-4a7d-afa62a4166cbd7c0}
 [    3.699521] VMBUS: Channel offer notification - child relid 5 
 monitor id 255 allocated 0, type {0e0b6031-5213-4934-818b38d90ced39db} 
 instance {b6650ff7-33bc-4840-8048e0676786f393}
 [    3.700426] VMBUS: Channel offer notification - child relid 6 
 monitor id 255 allocated 0, type {9527e630-d0ae-497b-adcee80ab0175caf} 
 instance {2dd1ce17-079e-403c-b352a1921ee207ee}
 [    3.701038] VMBUS: Channel offer notification - child relid 7 
 monitor id 1 allocated 1, type {ba6163d9-04a1-4d29-b60572e2ffb1dc7f} 
 instance {4fb6d35f-f9d0-49e7-9d9917cfb16ab18e}
 [    3.701672] VMBUS: Channel offer notification - child relid 8 
 monitor id 2 allocated 1, type {f8615163-df3e-46c5-913ff2d2f965ed0e} 
 instance {4e4aafbd-b96c-4b7a-932ac50a9082637a}
 [    6.906633] Adding 901116k swap on /dev/hda5.  Priority:-1 extents:1 
 across:901116k
 [    6.973454] EXT3-fs (hda1): using internal journal
 [    7.005687] loop: module loaded
 [    7.020226] hv_blkvsc: module is from the staging directory, the 
 quality is unknown, you have been warned.
 [    7.029329] BLKVSC_DRV: Blkvsc initializing....
 [    7.030109] BLKVSC: max io outstd 226
 [    7.030759] VMBUS_DRV: child driver (ffffffffa0225880) registering - 
 name blkvsc
 [    7.031504] VMBUS_DRV: device object (ffff880030360c48) set to 
 driver object (ffffffffa0225910)
 [    7.033657] VMBUS: channel <ffff88002fb23400> open success!!
 [    7.034560] STORVSC: BEGIN_INITIALIZATION_OPERATION...
 [    7.036307] STORVSC: QUERY_PROTOCOL_VERSION_OPERATION...
 [    7.037643] STORVSC: QUERY_PROPERTIES_OPERATION...
 [    7.038987] STORVSC: END_INITIALIZATION_OPERATION...
 [    7.041889] STORVSC: **** storage channel up and running!! ****
 [    7.042579] register_blkdev: cannot get major 3 for ide
 [    7.043261] BLKVSC_DRV: blkvsc_probe() ERROR!! register_blkdev() 
 failed! ret -16
 [    7.044324] STORVSC: disabling storage device (ffff88003c6c3ec0)...
 [    7.044661] STORVSC: removing storage device (ffff88003c6c3ec0)...
 [    7.044982] STORVSC: storage device (ffff88003c6c3ec0) safe to 
 remove
 [    7.046878] VMBUS_DRV: vmbus_probe() ERROR!! probe() failed for 
 device vmbus_0_1 (ffff880030360cc0) on driver blkvsc (-16)...
 [    7.047634] blkvsc: probe of vmbus_0_1 failed with error -16
 [    7.048311] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    7.049321] VMBUS: Channel offer notification - child relid 1 
 monitor id 0 allocated 1, type {32412632-86cb-44a2-9b5c50d1417354f5} 
 instance {00000000-0000-8899-0000000000000000}
 [    7.050647] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    7.051399] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    7.052206] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    7.052925] VMBUS_DRV: device object (ffff88003bd61048) set to 
 driver object (ffffffffa0225910)
 [    7.053736] VMBUS: Channel offer notification - child relid 2 
 monitor id 255 allocated 0, type {cfa8b69e-5b4a-4cc0-b98b8ba1a1f3f95a} 
 instance {58f75a6d-d949-4320-99e1a2a2576d581c}
 [    7.061518] hv_storvsc: module is from the staging directory, the 
 quality is unknown, you have been warned.
 [    7.064960] STORVSC_DRV: Storvsc initializing....
 [    7.066013] STORVSC: max io 226, currently 128
 [    7.066028]
 [    7.066921] STORVSC_DRV: request extension size 72, max outstanding 
 reqs 226
 [    7.067654] VMBUS_DRV: child driver (ffffffffa022f3f0) registering - 
 name storvsc
 [    7.068391] VMBUS: Channel offer notification - child relid 4 
 monitor id 255 allocated 0, type {57164f39-9115-4e78-ab55382f3bd5422d} 
 instance {fd149e91-82e0-4a7d-afa62a4166cbd7c0}
 [    7.069853] VMBUS: Channel offer notification - child relid 5 
 monitor id 255 allocated 0, type {0e0b6031-5213-4934-818b38d90ced39db} 
 instance {b6650ff7-33bc-4840-8048e0676786f393}
 [    7.070352] VMBUS: Channel offer notification - child relid 6 
 monitor id 255 allocated 0, type {9527e630-d0ae-497b-adcee80ab0175caf} 
 instance {2dd1ce17-079e-403c-b352a1921ee207ee}
 [    7.071337] VMBUS_DRV: device object (ffff880030365c48) set to 
 driver object (ffffffffa022f480)
 [    7.072086] VMBUS: Channel offer notification - child relid 7 
 monitor id 1 allocated 1, type {ba6163d9-04a1-4d29-b60572e2ffb1dc7f} 
 instance {4fb6d35f-f9d0-49e7-9d9917cfb16ab18e}
 [    7.072936] VMBUS: Channel offer notification - child relid 8 
 monitor id 2 allocated 1, type {f8615163-df3e-46c5-913ff2d2f965ed0e} 
 instance {4e4aafbd-b96c-4b7a-932ac50a9082637a}
 [    7.074734] VMBUS: channel <ffff88003c69e800> open success!!
 [    7.075433] STORVSC: BEGIN_INITIALIZATION_OPERATION...
 [    7.076154] STORVSC: QUERY_PROTOCOL_VERSION_OPERATION...
 [    7.076494] VMBUS: channel <ffff88003baba000> open success!!
 [    7.076823] STORVSC: BEGIN_INITIALIZATION_OPERATION...
 [    7.077157] STORVSC: QUERY_PROPERTIES_OPERATION...
 [    7.077482] STORVSC: QUERY_PROTOCOL_VERSION_OPERATION...
 [    7.077809] STORVSC: END_INITIALIZATION_OPERATION...
 [    7.078149] STORVSC: QUERY_PROPERTIES_OPERATION...
 [    7.078476] STORVSC: **** storage channel up and running!! ****
 [    7.078806] register_blkdev: cannot get major 3 for ide
 [    7.079279] BLKVSC_DRV: blkvsc_probe() ERROR!! register_blkdev() 
 failed! ret -16
 [    7.079619] STORVSC: disabling storage device (ffff88002f979740)...
 [    7.079946] STORVSC: removing storage device (ffff88002f979740)...
 [    7.080298] STORVSC: storage device (ffff88002f979740) safe to 
 remove
 [    7.080627] STORVSC: END_INITIALIZATION_OPERATION...
 [    7.081382] STORVSC: **** storage channel up and running!! ****
 [    7.082057] scsi0 : storvsc_host_t
 [    7.083016] VMBUS_DRV: vmbus_probe() ERROR!! probe() failed for 
 device vmbus_0_8 (ffff88003bd610c0) on driver blkvsc (-16)...
 [    7.083673] blkvsc: probe of vmbus_0_8 failed with error -16
 [    7.084374] VMBUS_DRV: vmbus_child_device_register() ERROR!! unable 
 to register child device (ffff88003bd610c0)
 [    7.085073] VMBUS: vmbus_process_offer() ERROR!! unable to add child 
 device object (relid 1)
 [    7.093085] scsi scan: INQUIRY result too short (5), using 36
 [    7.094476] scsi scan: INQUIRY result too short (5), using 36
 [    7.099863] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    7.102080] VMBUS: Channel offer notification - child relid 1 
 monitor id 0 allocated 1, type {32412632-86cb-44a2-9b5c50d1417354f5} 
 instance {00000000-0000-8899-0000000000000000}
 [    7.106701] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    7.107779] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    7.108693] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [    7.109429] VMBUS_DRV: device object (ffff88003bd62048) set to 
 driver object (ffffffffa0225910)
 [    7.110190] VMBUS: Channel offer notification - child relid 2 
 monitor id 255 allocated 0, type {cfa8b69e-5b4a-4cc0-b98b8ba1a1f3f95a} 
 instance {58f75a6d-d949-4320-99e1a2a2576d581c}
 [    7.111430] VMBUS: Channel offer notification - child relid 4 
 monitor id 255 allocated 0, type {57164f39-9115-4e78-ab55382f3bd5422d} 
 instance {fd149e91-82e0-4a7d-afa62a4166cbd7c0}
 [    7.112965] VMBUS: Channel offer notification - child relid 5 
 monitor id 255 allocated 0, type {0e0b6031-5213-4934-818b38d90ced39db} 
 instance {b6650ff7-33bc-4840-8048e0676786f393}
 [    7.113727] VMBUS: Channel offer notification - child relid 6 
 monitor id 255 allocated 0, type {9527e630-d0ae-497b-adcee80ab0175caf} 
 instance {2dd1ce17-079e-403c-b352a1921ee207ee}
 [    7.114877] VMBUS: Channel offer notification - child relid 7 
 monitor id 1 allocated 1, type {ba6163d9-04a1-4d29-b60572e2ffb1dc7f} 
 instance {4fb6d35f-f9d0-49e7-9d9917cfb16ab18e}
 [    7.116315] VMBUS: Channel offer notification - child relid 8 
 monitor id 2 allocated 1, type {f8615163-df3e-46c5-913ff2d2f965ed0e} 
 instance {4e4aafbd-b96c-4b7a-932ac50a9082637a}
 [    7.117276] VMBUS: channel <ffff88002fb21200> open success!!
 [    7.117924] STORVSC: BEGIN_INITIALIZATION_OPERATION...
 [    7.118592] STORVSC: QUERY_PROTOCOL_VERSION_OPERATION...
 [    7.119247] STORVSC: QUERY_PROPERTIES_OPERATION...
 [    7.120065] STORVSC: END_INITIALIZATION_OPERATION...
 [    7.121033] STORVSC: **** storage channel up and running!! ****
 [    7.121382] register_blkdev: cannot get major 3 for ide
 [    7.121697] BLKVSC_DRV: blkvsc_probe() ERROR!! register_blkdev() 
 failed! ret -16
 [    7.122034] STORVSC: disabling storage device (ffff88003c6c2540)...
 [    7.122360] STORVSC: removing storage device (ffff88003c6c2540)...
 [    7.122676] STORVSC: storage device (ffff88003c6c2540) safe to 
 remove
 [    7.123343] VMBUS_DRV: vmbus_probe() ERROR!! probe() failed for 
 device vmbus_0_9 (ffff88003bd620c0) on driver blkvsc (-16)...
 [    7.124070] blkvsc: probe of vmbus_0_9 failed with error -16
 [    7.124412] VMBUS_DRV: vmbus_child_device_register() ERROR!! unable 
 to register child device (ffff88003bd620c0)
 [    7.124750] VMBUS: vmbus_process_offer() ERROR!! unable to add child 
 device object (relid 1)
 [    7.125112] VMBUS_DRV: generating uevent - 
 VMBUS_DEVICE_CLASS_GUID={32412632-86cb-44a2-9b5c50d1417354f5}
 [   10.125751] sshd (803): /proc/803/oom_adj is deprecated, please use 
 /proc/803/oom_score_adj instead.
 [   20.240021] eth0: no IPv6 routers present

 I am using debian squeeze as OS and one virtual disk (hda). What's the 
 problem here? I tried also with boot parameter noprobe but without 
 success.

 Is the problem that the blkvsc module is loaded at last?? How I can fix 
 that?

 Regards
 Juan
