Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab2FYROw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:14:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:23306 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab2FYROt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="184693285"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.4.2 doesn't detect Intel 82579V on Supermicro X9SCL-F
Thread-Topic: Linux 3.4.2 doesn't detect Intel 82579V on Supermicro X9SCL-F
Thread-Index: AQHNURb7QnITPLtxDUSYGaVsoryz5pcLSYWg
Date: Mon, 25 Jun 2012 17:13:57 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18428473A73@ORSMSX102.amr.corp.intel.com>
References: <7d89df63ac6b7f801f8b8fb69d0c1b14@visp.net.lb>
In-Reply-To: <7d89df63ac6b7f801f8b8fb69d0c1b14@visp.net.lb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5PHF6r7032329

> -----Original Message-----
> From: Denys Fedoryshchenko [mailto:denys@visp.net.lb]
> Sent: Saturday, June 23, 2012 1:05 AM
> To: Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
> Carolyn; Skidmore, Donald C; Rose, Gregory V; Waskiewicz Jr, Peter P;
> Duyck, Alexander H; Ronciak, John; e1000-devel@lists.sourceforge.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Linux 3.4.2 doesn't detect Intel 82579V on Supermicro X9SCL-F
> 
> I have motherboard X9SCL-F with two onboard network cards, one of them
> are not detected.
> First i notice that on Ubuntu, now i tried also vanilla 3.4.2, on same
> motherboard model, but different server.
> 
> 00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network
> Connection (rev 05)
> 02:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
> Connection
> 
> Particular adapter that are not working:
> 
> 00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network
> Connection (rev 05)
>          Subsystem: Intel Corporation Device 0000
>          Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>          Interrupt: pin A routed to IRQ 20
>          Region 0: Memory at f7a00000 (32-bit, non-prefetchable)
> [size=128K]
>          Region 1: Memory at f7a23000 (32-bit, non-prefetchable)
> [size=4K]
>          Region 2: I/O ports at f020 [size=32]
>          Capabilities: [c8] Power Management version 2
>                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1
> PME-
>          Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
>                  Address: 00000000fee00378 Data: 0000
>          Capabilities: [e0] PCI Advanced Features
>                  AFCap: TP+ FLR+
>                  AFCtrl: FLR-
>                  AFStatus: TP-
>          Kernel modules: e1000e
> 
> corresponding log entries:
> [ 3.189176] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
> [ 3.197950] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
> [ 3.206540] md: raid0 personality registered for level 0
> [ 3.206693] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) ->
> IRQ 20
> [ 3.206723] e1000e 0000:00:19.0: setting latency timer to 64
> [ 3.207412] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
> [ 3.224410] input: Winbond Electronics Corp Hermon USB hidmouse Device
> as
> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input2
> [ 3.241969] md: raid1 personality registered for level 1
> [ 3.242538] generic-usb 0003:0557:2221.0001: input,hidraw0: USB HID
> v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on
> usb-0000:00:1a.0-1.2/input0
> [ 3.243563] input: Winbond Electronics Corp Hermon USB hidmouse Device
> as
> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/input/input3
> [ 3.243978] generic-usb 0003:0557:2221.0002: input,hidraw1: USB HID
> v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device]
> on
> usb-0000:00:1a.0-1.2/input1
> [ 3.243988] usbcore: registered new interface driver usbhid
> [ 3.243989] usbhid: USB HID core driver
> [ 3.271808] e1000e 0000:00:19.0: PCI INT A disabled
> [ 3.271813] e1000e: probe of 0000:00:19.0 failed with error -3
> [ 3.271821] e1000e 0000:02:00.0: Disabling ASPM L0s
> [ 3.272000] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) ->
> IRQ 16
> [ 3.272082] e1000e 0000:02:00.0: setting latency timer to 64
> [ 3.381646] e1000e 0000:02:00.0: irq 42 for MSI/MSI-X
> [ 3.381652] e1000e 0000:02:00.0: irq 43 for MSI/MSI-X
> [ 3.381658] e1000e 0000:02:00.0: irq 44 for MSI/MSI-X
> [ 3.382503] async_tx: api initialized (async)
> 
> root@central:~# ethtool -i eth0
> driver: e1000e
> version: 1.5.1-k
> firmware-version: 2.1-2
> bus-info: 0000:02:00.0
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> root@central:~# ethtool -i eth1
> Cannot get driver information: No such device
> ---
> AlsaDevices:
>   total 0
>   crw-rw---T 1 root audio 116, 1 Jun 17 13:22 seq
>   crw-rw---T 1 root audio 116, 33 Jun 17 13:22 timer
> AplayDevices: Error: [Errno 2] No such file or directory
> ApportVersion: 2.0.1-0ubuntu8
> Architecture: amd64
> ArecordDevices: Error: [Errno 2] No such file or directory
> AudioDevicesInUse: Error: command ['fuser', '-v', '/dev/snd/seq',
> '/dev/snd/timer'] failed with exit code 1:
> CRDA: Error: [Errno 2] No such file or directory
> DistroRelease: Ubuntu 12.04
> HibernationDevice: RESUME=UUID=6bdcd41e-069d-48e1-831d-5789badf4aab
> InstallationMedia: Ubuntu-Server 12.04 LTS "Precise Pangolin" -
> Release
> amd64 (20120424.1)
> Lsusb:
>   Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>   Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>   Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate
> Matching
> Hub
>   Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate
> Matching
> Hub
>   Bus 001 Device 003: ID 0557:2221 ATEN International Co., Ltd
> MachineType: Supermicro X9SCL/X9SCM
> Package: linux (not installed)
> PciMultimedia:
> 
> ProcEnviron:
>   TERM=xterm
>   LANG=en_US.UTF-8
>   SHELL=/bin/bash
> ProcFB: 0 EFI VGA
> ProcKernelCmdLine: BOOT_IMAGE=/boot/vmlinuz-3.2.0-25-generic
> root=UUID=49e8b23b-7eb0-41ac-8343-d6586659c879 ro
> ProcVersionSignature: Ubuntu 3.2.0-25.40-generic 3.2.18
> RelatedPackageVersions:
>   linux-restricted-modules-3.2.0-25-generic N/A
>   linux-backports-modules-3.2.0-25-generic N/A
>   linux-firmware 1.79
> RfKill: Error: [Errno 2] No such file or directory
> Tags: precise
> Uname: Linux 3.2.0-25-generic x86_64
> UpgradeStatus: No upgrade log present (probably fresh install)
> UserGroups:
> 
> dmi.bios.date: 05/08/2012
> dmi.bios.vendor: American Megatrends Inc.
> dmi.bios.version: 2.00
> dmi.board.asset.tag: To be filled by O.E.M.
> dmi.board.name: X9SCL/X9SCM
> dmi.board.vendor: Supermicro
> dmi.board.version: 0123456789
> dmi.chassis.asset.tag: To Be Filled By O.E.M.
> dmi.chassis.type: 3
> dmi.chassis.vendor: Supermicro
> dmi.chassis.version: 0123456789
> dmi.modalias:
> dmi:bvnAmericanMegatrendsInc.:bvr2.00:bd05/08/2012:svnSupermicro:pnX9S
> CL/X9SCM:pvr0123456789:rvnSupermicro:rnX9SCL/X9SCM:rvr0123456789:cvnSu
> permicro:ct3:cvr0123456789:
> dmi.product.name: X9SCL/X9SCM
> dmi.product.version: 0123456789
> dmi.sys.vendor: Supermicro
> 
> Detailed hardware information and ticket on ubuntu
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1014490
> 
> ---
> Denys Fedoryshchenko, Network Engineer, Virtual ISP S.A.L.

I'm looking into this now.

Thanks,
Bruce.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
