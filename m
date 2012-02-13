Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2BMKfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:35:55 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:38340 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab2BMKfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:35:53 -0500
Date: Mon, 13 Feb 2012 12:35:48 +0200 (EET)
From: Meelis Roos <mroos@ut.ee>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <alpine.SOC.1.00.1202131145590.1488@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1202131229190.1488@math.ut.ee>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee> <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131145590.1488@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another variation of the crash, without the patch, but backtrace is 
> slightly different (strlen) - maybe fixed by the patch, maybe not.

Tried this machine with the patvch too, same backtrace to strlen. 
prtconf below.

> [   0.000000] Unable to handle kernel NULL pointer dereference
> [    0.000000] tsk->{mm,active_mm}->context = 0000000000000000
> [    0.000000] tsk->{mm,active_mm}->pgd = fffff800604ea3a8
> [    0.000000]               \|/ ____ \|/
> [    0.000000]               "@'/ .. \`@"
> [    0.000000]               /_| \__/ |_\
> [    0.000000]                  \__U_/
> [    0.000000] swapper(0): Oops [#1]
> [    0.000000] TSTATE: 0000004480e01606 TPC: 00000000005be460 TNPC: 00000000005be464 Y: 00000037    Not d
> [    0.000000] TPC: <strlen+0x60/0xd4>
> [    0.000000] g0: 000000000000002f g1: 0000000000000001 g2: 0000000000000000 g3: 000000000073a700
> [    0.000000] g4: 000000000085ea50 g5: 0000000000000000 g6: 0000000000854000 g7: 0030a80000000000
> [    0.000000] o0: 0000000000000000 o1: 0000000000000000 o2: 0000000001010101 o3: 0000000080808080
> [    0.000000] o4: 0000000001010000 o5: fffff8006feae140 sp: 00000000008572c1 ret_pc: 0000000000655108
> [    0.000000] RPC: <of_alias_scan+0x68/0x200>
> [    0.000000] l0: 00000000008a4380 l1: fffff8006feae6b5 l2: fffff8006feae140 l3: fffff8006fe98e00
> [    0.000000] l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000 l7: 00000000008678d0
> [    0.000000] i0: 00000000008c3f24 i1: 0000000000896ca0 i2: 00000000008268c0 i3: 00000000008268b8
> [    0.000000] i4: 00000000008038c8 i5: fffff8006feae5c0 i6: 0000000000857381 i7: 00000000008c4314
> [    0.000000] I7: <of_pdt_build_devicetree+0x90/0xa0>
> [    0.000000] Call Trace:
> [    0.000000]  [00000000008c4314] of_pdt_build_devicetree+0x90/0xa0
> [    0.000000]  [00000000008b0330] prom_build_devicetree+0x10/0x3c
> [    0.000000]  [00000000008b3bb8] paging_init+0xa3c/0xde8
> [    0.000000]  [00000000008af978] setup_arch+0x324/0x688
> [    0.000000]  [00000000008ae4ec] start_kernel+0x80/0x338
> [    0.000000]  [0000000000715b30] tlb_fixup_done+0x88/0x90
> [    0.000000]  [0000000000000000]           (null)
> [    0.000000] Disabling lock debugging due to kernel taint
> [    0.000000] Caller[00000000008c4314]: of_pdt_build_devicetree+0x90/0xa0
> [    0.000000] Caller[00000000008b0330]: prom_build_devicetree+0x10/0x3c
> [    0.000000] Caller[00000000008b3bb8]: paging_init+0xa3c/0xde8
> [    0.000000] Caller[00000000008af978]: setup_arch+0x324/0x688
> [    0.000000] Caller[00000000008ae4ec]: start_kernel+0x80/0x338
> [    0.000000] Caller[0000000000715b30]: tlb_fixup_done+0x88/0x90
> [    0.000000] Caller[0000000000000000]:           (null)
> [    0.000000] Instruction DUMP: 96132080  19004040  94132101 <da020000> 9823400a  808b000b  024ffffd  9 

System Configuration:  Sun Microsystems  sun4u
Memory size: 1024 Megabytes
System Peripherals (PROM Nodes):

Node 0xf002a678
    .node:  f002a678
    idprom:  01830003.ba11b371.000003ba.11b37182.00000000.00000000.00000000.00000000
    scsi-initiator-id:  00000007
    reset-reason: 'S-POR'
    breakpoint-trap:  0000007f
    #size-cells:  00000002
    model: 'SUNW,375-3015'
    name: 'SUNW,UltraAX-i2'
    clock-frequency:  05f5e100
    banner-name: 'Sun Fire V100 (UltraSPARC-IIe 500MHz)'
    compatible: 'sun4u'
    device_type: 'upa'
    stick-frequency:  0054c563

    Node 0xf002d908
        .node:  f002d908
        name: 'packages'

        Node 0xf0035e4c
            .node:  f0035e4c
            iso6429-1983-colors:  
            name: 'terminal-emulator'

        Node 0xf0038e7c
            .node:  f0038e7c
            disk-write-fix:  
            name: 'deblocker'

        Node 0xf00395c4
            .node:  f00395c4
            name: 'obp-tftp'

        Node 0xf0044b08
            .node:  f0044b08
            name: 'disk-label'

        Node 0xf0059f74
            .node:  f0059f74
            name: 'SUNW,builtin-drivers'

        Node 0xf0062644
            .node:  f0062644
            source: '/pci@1f,0/isa@7/flashprom@1f,0:'
            name: 'dropins'

        Node 0xf00730e0
            .node:  f00730e0
            name: 'kbd-translator'

    Node 0xf002d978
        .node:  f002d978
        mmu:  fffe7ae0
        memory:  fffe7ce0
        bootargs:  00
        bootpath: '/pci@1f,0/ide@d/disk@2,0:a'
        stdout:  fffbd7b8
        stdin:  fffbda00
        stdout-#lines:  ffffffff
        name: 'chosen'

    Node 0xf002d9e4
        .node:  f002d9e4
        version: 'OBP 4.0.18 2002/05/23 18:22'
        model: 'SUNW,4.0'
        aligned-allocator:  
        relative-addressing:  
        name: 'openprom'

        Node 0xf002da74
            .node:  f002da74
            name: 'client-services'

    Node 0xf002db1c
        .node:  f002db1c
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
        #power-cycles: '100'
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
        watchdog-reboot?: 'true'
        diag-file:  
        diag-device: 'disk'
        boot-file:  
        boot-device: 'disk net'
        local-mac-address?: 'false'
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
        diag-switch?: 'true'
        name: 'options'

    Node 0xf002db8c
        .node:  f002db8c
        disk: '/pci@1f,0/ide@d/disk@2,0'
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
        cdrom: '/pci@1f,0/ide@d/cdrom@3,0:f'
        disk3: '/pci@1f,0/ide@d/disk@3,0'
        disk2: '/pci@1f,0/ide@d/disk@2,0'
        disk1: '/pci@1f,0/ide@d/disk@1,0'
        disk0: '/pci@1f,0/ide@d/disk@0,0'
        ide: '/pci@1f,0/ide@d'
        floppy: '/pci@1f,0/isa@7/dma/floppy'
        ttyb: '/pci@1f,0/isa@7/serial@0,2e8'
        ttya: '/pci@1f,0/isa@7/serial@0,3f8'
        name: 'aliases'

    Node 0xf0050050
        .node:  f0050050
        reg:  00000000.00000000.00000000.10000000.00000000.20000000.00000000.10000000.00000000.40000000.00000000.10000000.00000000.60000000.00000000.10000000
        available:  00000000.6fec0000.00000000.00006000.00000000.6fe80000.00000000.00030000.00000000.6f000000.00000000.00e00000.00000000.60000000.00000000.0effe000.00000000.40000000.00000000.10000000.00000000.20000000.00000000.10000000.00000000.00000000.00000000.10000000
        name: 'memory'

    Node 0xf0050634
        .node:  f0050634
        translations:  00000000.fffe0000.00000000.00010000.80000000.6fef00b6.00000000.fffdc000.00000000.00004000.80000000.6fee40b6.00000000.fffd4000.00000000.00004000.80000000.6fede0b6.00000000.fffd2000.00000000.00002000.800001fe.0200808e.00000000.fffd0000.00000000.00002000.80000000.6fed60b6.00000000.fffce000.00000000.00002000.800001fe.0200008e.00000000.fffcc000.00000000.00002000.800001fe.0200208e.00000000.fffca000.00000000.00002000.800001fe.0200408e.00000000.fffc8000.00000000.00002000.80000000.6effe0b6.00000000.fffc6000.00000000.00002000.80000000.6fed20b6.00000000.fffc4000.00000000.00002000.80000000.6fedc0b6.00000000.fffc2000.00000000.00002000.800001fe.0200008e.00000000.fffbc000.00000000.00004000.80000000.6fec80b6.00000000.fff82000.00000000.00010000.800001fe.0000008e.00000000.fff7e000.00000000.00004000.80000000.6fed80b6.00000000.f0000000.00000000.00100000.80000000.6ff000b6.00000000.40000000.00000000.04000000.80000000.60000036.00000000.00400000.00000000.01000000.80000000.6000
 0036.00000000.00002000.00000000.003fe000.80000000.00002036
        existing:  00000000.00000000.00000800.00000000.fffff800.00000000.00000800.00000000
        available:  fffff800.00000000.000007fc.00000000.00000001.00000000.000007ff.00000000.00000000.ffff0000.00000000.0000e000.00000000.00000000.00000000.f0000000.00000000.fffc0000.00000000.00002000.00000000.fff92000.00000000.0002a000.00000000.fff00000.00000000.0007e000.00000000.f0f80000.00000000.0e080000.00000000.f0800000.00000000.00700000
        page-size:  00002000
        name: 'virtual-memory'

    Node 0xf0069d48
        .node:  f0069d48
        available:  81000000.00000000.00010230.00000000.00bffdd0.82000000.00000000.00004000.00000000.0003c000.82000000.00000000.000c0000.00000000.00f40000.82000000.00000000.02000000.00000000.5e000000.82000000.00000000.80000000.00000000.40000000.82000000.00000000.e0000000.00000000.10000000
        bus-range:  00000000.00000000
        interrupt-map:  00006800.00000000.00000000.00000001.f0069d48.0000000c.00005000.00000000.00000000.00000001.f0069d48.00000024.00006000.00000000.00000000.00000001.f0069d48.00000006.00002800.00000000.00000000.00000001.f0069d48.0000001c.00003800.00000000.00000000.00000004.f0069d48.0000002b.00003800.00000000.00000000.00000005.f0069d48.00000023.00003800.00000000.00000000.00000001.f0069d48.0000002a.00001800.00000000.00000000.00000001.f0069d48.00000022
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

        Node 0xf0073e2c
            .node:  f0073e2c
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

            Node 0xf00749f4
                .node:  f00749f4
                reg:  00000000.00000000.00010000
                interrupts:  00000001
                compatible: 'isadma'
                name: 'dma'

            Node 0xf0074ccc
                .node:  f0074ccc
                address:  fffce070
                reg:  00000000.00000070.00000002
                compatible: 'm5819'
                model: 'm5819'
                name: 'rtc'

                Node 0xf009cac4
                    .node:  f009cac4
                    device_type: 'tod'
                    name: 'todm5819'

            Node 0xf007583c
                .node:  f007583c
                compatible: 'acpi-power'
                button:  
                interrupts:  00000005
                reg:  00000000.00002000.00000008
                name: 'power'

            Node 0xf00759d0
                .node:  f00759d0
                reg:  00000000.00008010.00000002
                interrupts:  00000001
                device_type: 'block'
                name: 'SUNW,lomh'

            Node 0xf0076e0c
                .node:  f0076e0c
                port-a-ignore-cd:  
                nohupcl:  00
                interrupt-priorities:  0000000c.0000000c
                reg:  00000000.000003f8.00000008
                compatible:  73753136.35353000.737500
                device_type: 'serial'
                name: 'serial'
                interrupts:  00000004

            Node 0xf0078af8
                .node:  f0078af8
                port-b-ignore-cd:  
                nohupcl:  00
                interrupt-priorities:  0000000c.0000000c
                reg:  00000000.000002e8.00000008
                compatible:  73753136.35353000.737500
                device_type: 'serial'
                name: 'serial'
                interrupts:  00000004

            Node 0xf007ac10
                .node:  f007ac10
                model: 'SUNW,258-7883'
                version: 'CORE 1.0.18 2002/05/23 18:22'
                name: 'flashprom'
                reg:  0000001f.00000000.00080000

        Node 0xf007b6bc
            .node:  f007b6bc
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

            Node 0xf007be84
                .node:  f007be84
                reg:  00000000.00000000.00000100.00000001.00000000.00000100
                #address-cells:  00000002
                #size-cells:  00000000
                interrupts:  00000001
                compatible: 'i2c-smbus'
                name: 'i2c'

                Node 0xf007d31c
                    .node:  f007d31c
                    compatible: 'i2c-max1617'
                    name: 'temperature'
                    reg:  00000000.00000030

                Node 0xf007d48c
                    .node:  f007d48c
                    compatible: 'i2c-at34c02'
                    name: 'dimm'
                    reg:  00000000.000000a8

                Node 0xf007d544
                    .node:  f007d544
                    compatible: 'i2c-at34c02'
                    name: 'dimm'
                    reg:  00000000.000000aa

                Node 0xf007d5fc
                    .node:  f007d5fc
                    compatible: 'i2c-at34c02'
                    name: 'dimm'
                    reg:  00000000.000000ac

                Node 0xf007d6b4
                    .node:  f007d6b4
                    compatible: 'i2c-at34c02'
                    name: 'dimm'
                    reg:  00000000.000000ae

                Node 0xf007d76c
                    .node:  f007d76c
                    reg:  00000000.000000a0
                    #address-cells:  00000001
                    compatible: 'i2c-at24c64'
                    device_type: 'nvram'
                    name: 'i2c-nvram'

                    Node 0xf007e284
                        .node:  f007e284
                        reg:  00001fd8.00000028
                        device_type: 'idprom'
                        name: 'idprom'

                Node 0xf007e538
                    .node:  f007e538
                    reg:  00000000.000000a2
                    #address-cells:  00000001
                    compatible: 'i2c-at24c64'
                    name: 'motherboard-fru'

            Node 0xf007f0d0
                .node:  f007f0d0
                compatible: 'SUNW,smbus-ppm'
                name: 'ppm'
                register-mask:  00000000.00000001
                reg:  00000000.000000b3.00000001.80000000.000000ba.00000001.00000000.000000bb.00000001

            Node 0xf007f344
                .node:  f007f344
                compatible: 'SUNW,smbus-beep'
                name: 'beep'
                reg:  00000000.000000b2.00000001.00000000.000000d3.00000001.00000002.00000042.00000002.00000002.00000061.00000001

            Node 0xf007f45c
                .node:  f007f45c
                compatible: 'SUNW,smbus-fan-control'
                name: 'fan-control'
                register-mask:  00000000.00000002
                reg:  00000000.000000c8.00000004.80000000.000000ba.00000001

        Node 0xf007f660
            .node:  f007f660
            name: 'lomp'
            reg:  00001800.00000000.00000000.00000000.00000000.81001810.00004000.00000000.00000000.00000010

        Node 0xf007fae8
            .node:  f007fae8
            local-mac-address:  0003ba11.b371
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

        Node 0xf0089634
            .node:  f0089634
            local-mac-address:  0003ba11.b372
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

        Node 0xf0093180
            .node:  f0093180
            assigned-addresses:  82005010.00000000.01000000.00000000.01000000
            sunw,find-fcode:  f009838c
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

        Node 0xf0098ff8
            .node:  f0098ff8
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

            Node 0xf009b86c
                .node:  f009b86c
                device_type: 'block'
                name: 'disk'
                compatible: 'ide-disk'

            Node 0xf009bf18
                .node:  f009bf18
                device_type: 'block'
                name: 'cdrom'
                compatible: 'ide-cdrom'

    Node 0xf0072d50
        .node:  f0072d50
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


-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
