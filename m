Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2GJLJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:09:29 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:57461 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab2GJLJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:09:25 -0400
Date: Tue, 10 Jul 2012 14:09:20 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Rob Herring <rob.herring@calxeda.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: bisected regression since 3.5-rc5 - hang on boot on some sparc64
 machines
Message-ID: <alpine.SOC.1.00.1207091627480.17307@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A regression since 3.5-rc5 stops Sun Fire V100 and Sun Netra X1 sparc64 
machines from booting, hanging after enabling serial console. Several 
different other sparc64 systems work fine with 3.5-rc6. prtconf and full 
dmesg below.

Bisecting leads to
107a84e61cdd3406c842a0e4be7efffd3a05dba6 is the first bad commit
commit 107a84e61cdd3406c842a0e4be7efffd3a05dba6
Author: Thierry Reding <thierry.reding@avionic-design.de>
Date:   Thu Jun 14 09:12:35 2012 +0200

    of: match by compatible property first
    
    When matching devices against an OF device ID table, the first string of
    the compatible property that is listed in the table should match,
    regardless of its position in the table.
    
    Cc: Grant Likely <grant.likely@secretlab.ca>
    Cc: Rob Herring <rob.herring@calxeda.com>
    Cc: devicetree-discuss@lists.ozlabs.org
    Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
    Signed-off-by: Rob Herring <rob.herring@calxeda.com>

:040000 040000 4982c947d5a864d1bd85aea50b962ab021af9985 f33e14c35917da29bd03b7d2fa135e9245ae435d M      drivers

--------------------------------------------------------------------------
System Configuration:  Sun Microsystems  sun4u
Memory size: 1024 Megabytes
System Peripherals (PROM Nodes):

Node 0xf002a63c
    .node:  f002a63c
    idprom:  01830003.ba0c06cd.000003ba.0c06cd82.00000000.00000000.00000000.00000000
    scsi-initiator-id:  00000007
    reset-reason: 'B-POR'
    breakpoint-trap:  0000007f
    #size-cells:  00000002
    model: 'SUNW,375-3015'
    name: 'SUNW,UltraAX-i2'
    clock-frequency:  05f5e100
    banner-name: 'Sun Netra X1 (UltraSPARC-IIe 500MHz)'
    compatible: 'sun4u'
    device_type: 'upa'
    stick-frequency:  0054c563

    Node 0xf002d8cc
        .node:  f002d8cc
        name: 'packages'

        Node 0xf0035e10
            .node:  f0035e10
            iso6429-1983-colors:  
            name: 'terminal-emulator'

        Node 0xf0038e4c
            .node:  f0038e4c
            disk-write-fix:  
            name: 'deblocker'

        Node 0xf0039594
            .node:  f0039594
            name: 'obp-tftp'

        Node 0xf0044a48
            .node:  f0044a48
            name: 'disk-label'

        Node 0xf0059b14
            .node:  f0059b14
            name: 'SUNW,builtin-drivers'

        Node 0xf0061ff8
            .node:  f0061ff8
            source: '/pci@1f,0/isa@7/flashprom@1f,0:'
            name: 'dropins'

        Node 0xf0072a30
            .node:  f0072a30
            name: 'kbd-translator'

    Node 0xf002d93c
        .node:  f002d93c
        mmu:  fffe7ae0
        memory:  fffe7ce0
        bootargs:  00
        bootpath: '/pci@1f,0/ide@d/disk@0,0:a'
        stdout:  fffbd7b8
        stdin:  fffbda00
        stdout-#lines:  ffffffff
        name: 'chosen'

    Node 0xf002d9a8
        .node:  f002d9a8
        version: 'OBP 4.0.9 2001/05/17 21:52'
        model: 'SUNW,4.0'
        aligned-allocator:  
        relative-addressing:  
        name: 'openprom'

        Node 0xf002da38
            .node:  f002da38
            name: 'client-services'

    Node 0xf002dae0
        .node:  f002dae0
        ras-shutdown-enabled?: 'false'
        shutdown-temp: '75'
        warning-temp: '70'
        env-monitor: 'enabled'
        diag-passes: '1'
        diag-continue?: '0'
        diag-targets: '0'
        diag-verbosity: '0'
        keyboard-click?: 'false'
        keymap:  
        scsi-initiator-id: '7'
        #power-cycles: '91'
        system-board-serial#:  
        system-board-date:  
        ttyb-rts-dtr-off: 'false'
        ttyb-ignore-cd: 'true'
        ttya-rts-dtr-off: 'false'
        ttya-ignore-cd: 'true'
        ttyb-mode: '9600,8,n,1,-'
        ttya-mode: '9600,8,n,1,-'
        pci-probe-list: '7,3,c,5,a,d'
        mfg-mode: 'off'
        diag-level: 'max'
        fcode-debug?: 'false'
        output-device: 'ttya'
        input-device: 'ttya'
        load-base: '16384'
        auto-boot-retry?: 'false'
        boot-command: 'boot'
        auto-boot?: 'true'
        watchdog-reboot?: 'false'
        diag-file:  
        diag-device: 'disk'
        boot-file:  
        boot-device: 'disk'
        local-mac-address?: 'true'
        net-timeout: '0'
        ansi-terminal?: 'true'
        screen-#columns: '80'
        screen-#rows: '34'
        silent-mode?: 'false'
        use-nvramrc?: 'false'
        nvramrc:  
        security-mode: 'none'
        security-password:  
        security-#badlogins: '0'
        oem-logo:  
        oem-logo?: 'false'
        oem-banner:  
        oem-banner?: 'false'
        hardware-revision:  
        last-hardware-update:  
        diag-switch?: 'false'
        name: 'options'

    Node 0xf002db50
        .node:  f002db50
        rtc: '/pci@1f,0/isa@7/rtc@0,70'
        usb: '/pci@1f,0/usb@a'
        flash: '/pci@1f,0/isa@7/flashprom@1f,0'
        lom: '/pci@1f,0/isa@7/SUNW,lomh@0,8010'
        i2c-nvram: '/pci@1f,0/pmu@3/i2c@0,0/i2c-nvram@0,aa'
        net1: '/pci@1f,0/ethernet@5'
        dload1: '/pci@1f,0/ethernet@5:,'
        dload: '/pci@1f,0/ethernet@c:,'
        net0: '/pci@1f,0/ethernet@c'
        net: '/pci@1f,0/ethernet@c'
        cdrom: '/pci@1f,0/ide@d/cdrom@2,0:f'
        disk: '/pci@1f,0/ide@d/disk@0,0'
        disk3: '/pci@1f,0/ide@d/disk@3,0'
        disk2: '/pci@1f,0/ide@d/disk@2,0'
        disk1: '/pci@1f,0/ide@d/disk@1,0'
        disk0: '/pci@1f,0/ide@d/disk@0,0'
        ide: '/pci@1f,0/ide@d'
        floppy: '/pci@1f,0/isa@7/dma/floppy'
        ttyb: '/pci@1f,0/isa@7/serial@0,2e8'
        ttya: '/pci@1f,0/isa@7/serial@0,3f8'
        name: 'aliases'

    Node 0xf004fd44
        .node:  f004fd44
        reg:  00000000.00000000.00000000.10000000.00000000.20000000.00000000.10000000.00000000.40000000.00000000.10000000.00000000.60000000.00000000.10000000
        available:  00000000.6fec0000.00000000.00008000.00000000.6fe80000.00000000.00030000.00000000.6f000000.00000000.00e00000.00000000.60000000.00000000.0effe000.00000000.40000000.00000000.10000000.00000000.20000000.00000000.10000000.00000000.00000000.00000000.10000000
        name: 'memory'

    Node 0xf0050328
        .node:  f0050328
        translations:  00000000.fffe0000.00000000.00010000.80000000.6fef00b6.00000000.fffdc000.00000000.00004000.80000000.6fee40b6.00000000.fffd4000.00000000.00004000.80000000.6fede0b6.00000000.fffd2000.00000000.00002000.800001fe.0200808e.00000000.fffd0000.00000000.00002000.80000000.6fed60b6.00000000.fffce000.00000000.00002000.800001fe.0200008e.00000000.fffcc000.00000000.00002000.800001fe.0200208e.00000000.fffca000.00000000.00002000.800001fe.0200408e.00000000.fffc8000.00000000.00002000.80000000.6effe0b6.00000000.fffc6000.00000000.00002000.80000000.6fed20b6.00000000.fffc4000.00000000.00002000.80000000.6fedc0b6.00000000.fffc2000.00000000.00002000.800001fe.0200008e.00000000.fffbc000.00000000.00004000.80000000.6fec80b6.00000000.fff82000.00000000.00010000.800001fe.0000008e.00000000.fff7e000.00000000.00004000.80000000.6fed80b6.00000000.f0000000.00000000.00100000.80000000.6ff000b6.00000000.40000000.00000000.04000000.80000000.60000036.00000000.00400000.00000000.00800000.80000000.6000
 0036.00000000.00002000.00000000.003fe000.80000000.00002036
        existing:  00000000.00000000.00000800.00000000.fffff800.00000000.00000800.00000000
        available:  fffff800.00000000.000007fc.00000000.00000001.00000000.000007ff.00000000.00000000.ffff0000.00000000.0000e000.00000000.00000000.00000000.f0000000.00000000.fffc0000.00000000.00002000.00000000.fff92000.00000000.0002a000.00000000.fff00000.00000000.0007e000.00000000.f0f80000.00000000.0e080000.00000000.f0800000.00000000.00700000
        page-size:  00002000
        name: 'virtual-memory'

    Node 0xf0069698
        .node:  f0069698
        available:  81000000.00000000.00010230.00000000.00bffdd0.82000000.00000000.00004000.00000000.0003c000.82000000.00000000.000c0000.00000000.00f40000.82000000.00000000.02000000.00000000.5e000000.82000000.00000000.80000000.00000000.40000000.82000000.00000000.e0000000.00000000.10000000
        bus-range:  00000000.00000000
        interrupt-map:  00006800.00000000.00000000.00000001.f0069698.0000000c.00005000.00000000.00000000.00000001.f0069698.00000024.00006000.00000000.00000000.00000001.f0069698.00000006.00002800.00000000.00000000.00000001.f0069698.0000001c.00003800.00000000.00000000.00000004.f0069698.0000002b.00003800.00000000.00000000.00000005.f0069698.00000023.00003800.00000000.00000000.00000001.f0069698.0000002a.00001800.00000000.00000000.00000001.f0069698.00000022
        interrupt-map-mask:  00fff800.00000000.00000000.00000007
        #interrupt-cells:  00000001
        virtual-dma:  60000000.20000000
        reg:  000001fe.00000000.00000000.00010000.000001fe.01000000.00000000.00000100
        ranges:  00000000.00000000.00000000.000001fe.01000000.00000000.01000000.01000000.00000000.00000000.000001fe.02000000.00000000.01000000.02000000.00000000.00000000.000001ff.00000000.00000001.00000000.03000000.00000000.00000000.000001ff.00000000.00000001.00000000
        #virtual-dma-size-cells:  00000001
        #virtual-dma-addr-cells:  00000001
        clock-frequency:  03ef1480
        latency-timer:  
        button-interrupt:  
        no-streaming-cache:  
        66mhz-capable:  
        interrupts:  00000030.0000002e.0000002f.00000025
        upa-portid:  0000001f
        bus-parity-generated:  
        compatible: 'pci108e,a001'
        model: 'SUNW,sabre'
        name: 'pci'
        device_type: 'pci'
        #address-cells:  00000003
        #size-cells:  00000002

        Node 0xf007377c
            .node:  f007377c
            cache-line-size:  00000000
            latency-timer:  00000000
            #size-cells:  00000001
            #address-cells:  00000002
            name: 'isa'
            ranges:  00000000.00000000.81003810.00000000.00000000.00010000.0000001f.00000000.82003814.00000000.f0000000.00080000
            reg:  00003800.00000000.00000000.00000000.00000000.81003810.00000000.00000000.00000000.00010000.82003814.00000000.00000000.00000000.00100000
            devsel-speed:  00000001
            class-code:  00060100
            max-latency:  00000000
            min-grant:  00000000
            subsystem-id:  00001533
            subsystem-vendor-id:  000010b9
            revision-id:  00000000
            device-id:  00001533
            vendor-id:  000010b9

            Node 0xf0074344
                .node:  f0074344
                reg:  00000000.00000000.00010000
                interrupts:  00000001
                compatible: 'isadma'
                name: 'dma'

            Node 0xf007461c
                .node:  f007461c
                address:  fffce070
                reg:  00000000.00000070.00000002
                compatible: 'm5819'
                model: 'm5819'
                name: 'rtc'

                Node 0xf009c318
                    .node:  f009c318
                    device_type: 'tod'
                    name: 'todm5819'

            Node 0xf0075134
                .node:  f0075134
                compatible: 'acpi-power'
                button:  
                interrupts:  00000005
                reg:  00000000.00002000.00000008
                name: 'power'

            Node 0xf00752c8
                .node:  f00752c8
                reg:  00000000.00008010.00000002
                interrupts:  00000001
                device_type: 'block'
                name: 'SUNW,lomh'

            Node 0xf0076704
                .node:  f0076704
                port-a-ignore-cd:  
                nohupcl:  00
                interrupt-priorities:  0000000c.0000000c
                reg:  00000000.000003f8.00000008
                compatible:  73753136.35353000.737500
                device_type: 'serial'
                name: 'serial'
                interrupts:  00000004

            Node 0xf00783f0
                .node:  f00783f0
                port-b-ignore-cd:  
                nohupcl:  00
                interrupt-priorities:  0000000c.0000000c
                reg:  00000000.000002e8.00000008
                compatible:  73753136.35353000.737500
                device_type: 'serial'
                name: 'serial'
                interrupts:  00000004

            Node 0xf007a508
                .node:  f007a508
                model: 'SUNW,258-7883'
                version: 'CORE 1.0.2 2001/04/23 18:18'
                name: 'flashprom'
                reg:  0000001f.00000000.00080000

        Node 0xf007afb0
            .node:  f007afb0
            name: 'pmu'
            ranges:  00000000.00000000.00001800.00000000.00000000.00000100.00000001.00000000.81001810.00000000.00004000.00000100.00000002.00000000.81001814.00000000.00000000.00000100
            reg:  00001800.00000000.00000000.00000000.00000000.81001810.00000000.00004000.00000000.00000010
            compatible:  70636931.3062392c.37313031.00706369.636c6173.732c3030.30303030.00
            #address-cells:  00000002
            #size-cells:  00000001
            devsel-speed:  00000001
            class-code:  00000000
            max-latency:  00000000
            min-grant:  00000000
            revision-id:  00000000
            device-id:  00007101
            vendor-id:  000010b9

            Node 0xf007b778
                .node:  f007b778
                reg:  00000000.00000000.00000100.00000001.00000000.00000100
                #address-cells:  00000002
                #size-cells:  00000000
                interrupts:  00000001
                compatible: 'i2c-smbus'
                name: 'i2c'

                Node 0xf007cc10
                    .node:  f007cc10
                    compatible: 'i2c-max1617'
                    name: 'temperature'
                    reg:  00000000.00000030

                Node 0xf007cd80
                    .node:  f007cd80
                    compatible: 'i2c-at34c02'
                    name: 'dimm'
                    reg:  00000000.000000a8

                Node 0xf007ce38
                    .node:  f007ce38
                    compatible: 'i2c-at34c02'
                    name: 'dimm'
                    reg:  00000000.000000aa

                Node 0xf007cef0
                    .node:  f007cef0
                    compatible: 'i2c-at34c02'
                    name: 'dimm'
                    reg:  00000000.000000ac

                Node 0xf007cfa8
                    .node:  f007cfa8
                    compatible: 'i2c-at34c02'
                    name: 'dimm'
                    reg:  00000000.000000ae

                Node 0xf007d060
                    .node:  f007d060
                    reg:  00000000.000000a0
                    #address-cells:  00000001
                    compatible: 'i2c-at24c64'
                    device_type: 'nvram'
                    name: 'i2c-nvram'

                    Node 0xf007db78
                        .node:  f007db78
                        reg:  00001fd8.00000028
                        device_type: 'idprom'
                        name: 'idprom'

                Node 0xf007de2c
                    .node:  f007de2c
                    reg:  00000000.000000a2
                    #address-cells:  00000001
                    compatible: 'i2c-at24c64'
                    name: 'motherboard-fru'

            Node 0xf007e9c4
                .node:  f007e9c4
                compatible: 'SUNW,smbus-ppm'
                name: 'ppm'
                register-mask:  00000000.00000001
                reg:  00000000.000000b3.00000001.80000000.000000ba.00000001.00000000.000000bb.00000001

            Node 0xf007ec38
                .node:  f007ec38
                compatible: 'SUNW,smbus-beep'
                name: 'beep'
                reg:  00000000.000000b2.00000001.00000000.000000d3.00000001.00000002.00000042.00000002.00000002.00000061.00000001

            Node 0xf007ed50
                .node:  f007ed50
                compatible: 'SUNW,smbus-fan-control'
                name: 'fan-control'
                register-mask:  00000000.00000002
                reg:  00000000.000000c8.00000004.80000000.000000ba.00000001

        Node 0xf007ef54
            .node:  f007ef54
            name: 'lomp'
            reg:  00001800.00000000.00000000.00000000.00000000.81001810.00004000.00000000.00000000.00000010

        Node 0xf007f3ac
            .node:  f007f3ac
            local-mac-address:  0003ba0c.06cd
            assigned-addresses:  81006010.00000000.00010000.00000000.00000100.82006014.00000000.00000000.00000000.00002000.82006030.00000000.00040000.00000000.00040000
            version: '1.0'
            compatible:  70636934.3535342c.34333465.00706369.31323868.2c393130.32007063.69313238.322c3931.30320070.6369636c.6173732c.30323030.303000
            device_type: 'network'
            subsystem-id:  0000434e
            subsystem-vendor-id:  00004554
            reg:  00006000.00000000.00000000.00000000.00000000.01006010.00000000.00000000.00000000.00000100.02006014.00000000.00000000.00000000.00000100
            name: 'ethernet'
            devsel-speed:  00000001
            class-code:  00020000
            interrupts:  00000001
            max-latency:  00000028
            min-grant:  00000014
            revision-id:  00000031
            device-id:  00009102
            vendor-id:  00001282

        Node 0xf0088ef8
            .node:  f0088ef8
            local-mac-address:  0003ba0c.06ce
            assigned-addresses:  81002810.00000000.00010100.00000000.00000100.82002814.00000000.00002000.00000000.00002000.82002830.00000000.00080000.00000000.00040000
            version: '1.0'
            compatible:  70636934.3535342c.34333465.00706369.31323868.2c393130.32007063.69313238.322c3931.30320070.6369636c.6173732c.30323030.303000
            device_type: 'network'
            subsystem-id:  0000434e
            subsystem-vendor-id:  00004554
            reg:  00002800.00000000.00000000.00000000.00000000.01002810.00000000.00000000.00000000.00000100.02002814.00000000.00000000.00000000.00000100
            name: 'ethernet'
            devsel-speed:  00000001
            class-code:  00020000
            interrupts:  00000001
            max-latency:  00000028
            min-grant:  00000014
            revision-id:  00000031
            device-id:  00009102
            vendor-id:  00001282

        Node 0xf0092a44
            .node:  f0092a44
            assigned-addresses:  82005010.00000000.01000000.00000000.01000000
            sunw,find-fcode:  f0097c08
            maximum-frame#:  0000ffff
            reg:  00005000.00000000.00000000.00000000.00000000.02005010.00000000.00000000.00000000.01000000
            #size-cells:  00000000
            #address-cells:  00000001
            compatible:  70636931.3062392c.35323337.2e330070.63693130.62392c35.32333700.70636963.6c617373.2c306330.33313000.70636963.6c617373.2c306330.3300
            name: 'usb'
            fast-back-to-back:  
            devsel-speed:  00000001
            class-code:  000c0310
            interrupts:  00000001
            max-latency:  00000050
            min-grant:  00000000
            revision-id:  00000003
            device-id:  00005237
            vendor-id:  000010b9

        Node 0xf009884c
            .node:  f009884c
            assigned-addresses:  81006810.00000000.00010200.00000000.00000008.81006814.00000000.00010218.00000000.00000008.81006818.00000000.00010210.00000000.00000008.8100681c.00000000.00010208.00000000.00000008.81006820.00000000.00010220.00000000.00000010
            reg:  00006800.00000000.00000000.00000000.00000000.01006810.00000000.00000000.00000000.00000008.01006814.00000000.00000000.00000000.00000004.01006818.00000000.00000000.00000000.00000008.0100681c.00000000.00000000.00000000.00000004.01006820.00000000.00000000.00000000.00000010
            compatible:  70636931.3062392c.35323239.00706369.636c6173.732c3031.30316666.00
            #address-cells:  00000002
            device_type: 'ide'
            name: 'ide'
            fast-back-to-back:  
            devsel-speed:  00000001
            class-code:  000101ff
            interrupts:  00000001
            max-latency:  00000004
            min-grant:  00000002
            revision-id:  000000c3
            device-id:  00005229
            vendor-id:  000010b9

            Node 0xf009b0c0
                .node:  f009b0c0
                device_type: 'block'
                name: 'disk'
                compatible: 'ide-disk'

            Node 0xf009b76c
                .node:  f009b76c
                device_type: 'block'
                name: 'cdrom'
                compatible: 'ide-cdrom'

    Node 0xf00726a0
        .node:  f00726a0
        manufacturer#:  00000017
        implementation#:  00000013
        mask#:  00000014
        ecache-size:  00040000
        clock-frequency:  1dcd6500
        name: 'SUNW,UltraSPARC-IIe'
        sparc-version:  00000009
        ecache-associativity:  00000001
        ecache-line-size:  00000040
        #dtlb-entries:  00000040
        dcache-associativity:  00000001
        dcache-line-size:  00000020
        dcache-size:  00004000
        #itlb-entries:  00000040
        icache-associativity:  00000002
        icache-line-size:  00000020
        icache-size:  00004000
        upa-portid:  00000000
        reg:  000001c0.00000000.00000000.00000008
        device_type: 'cpu'



[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.0.9 2001/05/17 21:52'                                                                   
[    0.000000] PROMLIB: Root node compatible: sun4u                                                                                       
[    0.000000] Linux version 3.5.0-rc5-00124-g5eecb9c (mroos@deegu) (gcc version 4.6.3 (Debian 4.6.3-7) ) #51 Mon Jul 9 16:09:59 EEST 2012
[    0.000000] debug: ignoring loglevel setting.                                                                                          
[    0.000000] bootconsole [earlyprom0] enabled                                                                                           
[    0.000000] ARCH: SUN4U                                                                                                                
[    0.000000] Ethernet address: 00:03:ba:0c:06:cd                                                                                        
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.                                                                  
[    0.000000] Remapping the kernel... done.                                                                                              
[    0.000000] OF stdout device is: /pci@1f,0/isa@7/serial@0,3f8                                                                          
[    0.000000] PROM: Built device tree with 46439 bytes of memory.                                                                        
[    0.000000] Top of RAM: 0x6fec8000, Total RAM: 0x3fe36000                                                                              
[    0.000000] Memory hole size: 768MB                                                                                                    
[    0.000000] [0000010000000000-fffff8006f800000] page_structs=131072 node=0 entry=0/8192                                                
[    0.000000] [0000010000000000-fffff8006f400000] page_structs=131072 node=0 entry=1/8192                                                
[    0.000000] [0000010000800000-fffff8006f000000] page_structs=131072 node=0 entry=2/8192                                                
[    0.000000] [0000010000800000-fffff8006e800000] page_structs=131072 node=0 entry=3/8192                                                
[    0.000000] Zone ranges:                                                                                                               
[    0.000000]   Normal   [mem 0x00000000-0x6fec7fff]                                                                                     
[    0.000000] Movable zone start for each node                                                                                           
[    0.000000] Early memory node ranges                                                                                                   
[    0.000000]   node   0: [mem 0x00000000-0x0fffffff]                                                                                    
[    0.000000]   node   0: [mem 0x20000000-0x2fffffff]                                                                                    
[    0.000000]   node   0: [mem 0x40000000-0x4fffffff]                                                                                    
[    0.000000]   node   0: [mem 0x60000000-0x6effdfff]                                                                                    
[    0.000000]   node   0: [mem 0x6f000000-0x6fdfffff]                                                                                    
[    0.000000]   node   0: [mem 0x6fe80000-0x6feaffff]                                                                                    
[    0.000000]   node   0: [mem 0x6fec0000-0x6fec7fff]                                                                                    
[    0.000000] On node 0 totalpages: 130843                                                                                               
[    0.000000]   Normal zone: 1791 pages used for memmap                                                                                  
[    0.000000]   Normal zone: 0 pages reserved                                                                                            
[    0.000000]   Normal zone: 129052 pages, LIFO batch:15                                                                                 
[    0.000000] Booting Linux...                                                                                                           
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]                                                                  
[    0.000000] CPU CAPS: [vis]                                                                                                            
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768                                                                              
[    0.000000] pcpu-alloc: [0] 0                                                                                                          
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129052                                                
[    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel                                                               
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)                                                                       
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)                                                          
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)                                                             
[    0.000000] Memory: 1023472k available (3128k kernel code, 1432k data, 144k init) [fffff80000000000,000000006fec8000]                  
[    0.000000] SLUB: Genslabs=16, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1                                                    
[    0.000000] NR_IRQS:255                                                                                                                
[    0.000000] clocksource: mult[b400012e] shift[24]                                                                                      
[    0.000000] clockevent: mult[16c16bf] shift[32]                                                                                        
[    0.000000] Console: colour dummy device 80x25                                                                                         
[    0.000000] console [tty0] enabled, bootconsole disabled                                                                               



-- 
Meelis Roos (mroos@linux.ee)
