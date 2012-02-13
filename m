Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2BMHpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:45:46 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:57895 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab2BMHpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:45:43 -0500
Date: Mon, 13 Feb 2012 09:45:40 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
cc: sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend with proper To-s for OF people)

This is my first post-3.2 test on 2-CPU Sun Enterprise 3500 (PCI+SBus 
IO). prtconf is also below. Something OF-related seems to be happening 
here.

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
[    0.000000] PROMLIB: Root node compatible:
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-rc3-00188-g3ec1e88 (mroos@korvits) (gcc version 4.6.2 (Debian 4.6.2-14) ) #64 SMP Sun Feb 12 22:26:40 EET 2012
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:b6:ee:e2
[    0.000000] Kernel: Using 4 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] Unable to handle kernel NULL pointer dereference
[    0.000000] tsk->{mm,active_mm}->context = 0000000000000000
[    0.000000] tsk->{mm,active_mm}->pgd = fffff800008c77d0
[    0.000000]               \|/ ____ \|/
[    0.000000]               "@'/ .. \`@"
[    0.000000]               /_| \__/ |_\
[    0.000000]                  \__U_/
[    0.000000] swapper(0): Oops [#1]
[    0.000000] TSTATE: 0000000080e01607 TPC: 00000000006459a0 TNPC: 0000000000645964 Y: 00000037    Not tainted
[    0.000000] TPC: <of_find_node_by_path+0x60/0x80>
[    0.000000] g0: 0000000000000000 g1: 0000000000000001 g2: 00000000000000ff g3: 00000000000000f0
[    0.000000] g4: 0000000000853fd0 g5: 0000000000000000 g6: 0000000000834000 g7: 0000000000000050
[    0.000000] o0: 0000000000000001 o1: fffff8007fced7c0 o2: 0000000001010101 o3: 0000000080808080
[    0.000000] o4: fffff8007fcc0a4d o5: 00000000000199b5 sp: 0000000000837231 ret_pc: 0000000000645970
[    0.000000] RPC: <of_find_node_by_path+0x30/0x80>
[    0.000000] l0: 00000000008ab400 l1: fffff8007fcc1f40 l2: 000000000085c5ec l3: 0000000000000025
[    0.000000] l4: 00000000005c0400 l5: 00000000008fa5e6 l6: 0000000000000006 l7: 0028280000000000
[    0.000000] i0: fffff8007fced7c0 i1: 0000000000808fd8 i2: 0000000001010101 i3: 0000000080808080
[    0.000000] i4: 0000000000876c00 i5: 0000000000000050 i6: 00000000008372e1 i7: 000000000064684c
[    0.000000] I7: <of_alias_scan+0xcc/0x1c0>
[    0.000000] Call Trace:
[    0.000000]  [000000000064684c] of_alias_scan+0xcc/0x1c0
[    0.000000]  [00000000008a0350] of_pdt_build_devicetree+0x90/0xa0
[    0.000000]  [000000000088c540] prom_build_devicetree+0x10/0x3c
[    0.000000]  [00000000008904d4] paging_init+0x59c/0x6bc
[    0.000000]  [000000000088bebc] setup_arch+0xf8/0x110
[    0.000000]  [000000000088a51c] start_kernel+0x8c/0x34c
[    0.000000]  [00000000006fbf28] tlb_fixup_done+0xa0/0xa8
[    0.000000]  [0000000000000000]           (null)
[    0.000000] Disabling lock debugging due to kernel taint
[    0.000000] Caller[000000000064684c]: of_alias_scan+0xcc/0x1c0
[    0.000000] Caller[00000000008a0350]: of_pdt_build_devicetree+0x90/0xa0
[    0.000000] Caller[000000000088c540]: prom_build_devicetree+0x10/0x3c
[    0.000000] Caller[00000000008904d4]: paging_init+0x59c/0x6bc
[    0.000000] Caller[000000000088bebc]: setup_arch+0xf8/0x110
[    0.000000] Caller[000000000088a51c]: start_kernel+0x8c/0x34c
[    0.000000] Caller[00000000006fbf28]: tlb_fixup_done+0xa0/0xa8
[    0.000000] Caller[0000000000000000]:           (null)
[    0.000000] Instruction DUMP: 01000000  fa5f6050  2aff7ff2 <c25f6018> 901720f0  40034b86  b010001d  81cfe008  01000000
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] Press Stop-A (L1-A) to return to the boot prom


System Configuration:  Sun Microsystems  sun4u
Memory size: 2048 Megabytes
System Peripherals (PROM Nodes):

Node 0xf0029c88
    .node:  f0029c88
    clock-frequency:  05f5e100
    previous-reset-reason: 'S-POR'
    banner-name: '5-slot Sun Enterprise E3500'
    idprom:  01800800.20b6eee2.00000000.b6eee2a9.00000000.00000000.00000000.00000000
    reset-reason: 'S-POR'
    fatal-reset-info:  00006000
    breakpoint-trap:  0000007f
    #size-cells:  00000002
    name: 'SUNW,Ultra-Enterprise'

    Node 0xf002cf50
        .node:  f002cf50
        name: 'packages'

        Node 0xf00365c0
            .node:  f00365c0
            iso6429-1983-colors:  
            name: 'terminal-emulator'

        Node 0xf003932c
            .node:  f003932c
            disk-write-fix:  
            name: 'deblocker'

        Node 0xf0039a08
            .node:  f0039a08
            name: 'obp-tftp'

        Node 0xf00447cc
            .node:  f00447cc
            name: 'disk-label'

    Node 0xf002cfc0
        .node:  f002cfc0
        stdout:  ffdc1428
        stdin:  ffdc1658
        eeprom:  f005dd0c
        mmu:  fffe9f70
        memory:  fffea170
        bootargs:  00
        bootpath: '/pci@f,4000/SUNW,isptwo@3/sd@2,0:a'
        stdout-#lines:  ffffffff
        name: 'chosen'

    Node 0xf002d02c
        .node:  f002d02c
        add-brd-supported-types: '014'
        version: 'OBP 3.2.30 2002/10/25 14:03'
        model: 'SUNW,3.2'
        decode-complete:  
        aligned-allocator:  
        relative-addressing:  
        name: 'openprom'

        Node 0xf002d0bc
            .node:  f002d0bc
            name: 'client-services'

    Node 0xf002d164
        .node:  f002d164
        disabled-memory-list:  
        disabled-board-list:  
        memory-interleave: 'max'
        configuration-policy: 'component'
        scsi-initiator-id: '7'
        keyboard-click?: 'false'
        keymap:  
        ttyb-rts-dtr-off: 'false'
        ttyb-ignore-cd: 'true'
        ttya-rts-dtr-off: 'false'
        ttya-ignore-cd: 'true'
        ttyb-mode: '9600,8,n,1,-'
        ttya-mode: '9600,8,n,1,-'
        sbus-specific-probe:  
        sbus-probe-default: 'd3120'
        mfg-mode: 'off '
        diag-level: 'min'
        powerfail-time: '0'
        #power-cycles: '52'
        fcode-debug?: 'false'
        output-device: 'ttya'
        input-device: 'ttya'
        load-base: '16384'
        boot-command: 'boot'
        auto-boot?: 'false'
        watchdog-reboot?: 'false'
        diag-file:  
        diag-device: 'mydisk'
        boot-file:  
        boot-device: 'mydisk'
        local-mac-address?: 'false'
        ansi-terminal?: 'true'
        screen-#columns: '80'
        screen-#rows: '34'
        silent-mode?: 'false'
        use-nvramrc?: 'true'
        nvramrc:  64657661.6c696173.206d7964.69736b20.2f706369.40662c34.3030302f.53554e57.2c697370.74776f40.332f7364.40322c30.0a
        security-mode: 'none'
        security-password:  
        security-#badlogins: '0'
        oem-logo:  
        oem-logo?: 'false'
        oem-banner:  
        oem-banner?: 'false'
        hardware-revision:  
        last-hardware-update: '0'
        diag-switch?: 'false'
        name: 'options'

    Node 0xf002d1d4
        .node:  f002d1d4
        mydisk: '/pci@f,4000/SUNW,isptwo@3/sd@2,0'
        disk: '/sbus@2,0/SUNW,socal@d,10000/sf@0,0/ssd@0,0'
        disksocal: '/sbus@2,0/SUNW,socal@d,10000/sf@0,0/ssd@0,0'
        diskbrd: '/sbus@3,0/SUNW,fas@3,8800000/sd@a,0'
        diskisp: '/sbus@3,0/QLGC,isp@0,10000/sd@0,0'
        net: '/sbus@3,0/SUNW,hme@3,8c00000'
        cdrom: '/sbus@3,0/SUNW,fas@3,8800000/sd@6,0:f'
        tape: '/sbus@3,0/SUNW,fas@3,8800000/st@4,0'
        scsi: '/sbus@3,0/SUNW,fas@3,8800000'
        disk0: '/sbus@3,0/SUNW,fas@3,8800000/sd@0,0'
        disk1: '/sbus@3,0/SUNW,fas@3,8800000/sd@1,0'
        disk2: '/sbus@3,0/SUNW,fas@3,8800000/sd@2,0'
        disk3: '/sbus@3,0/SUNW,fas@3,8800000/sd@3,0'
        disk4: '/sbus@3,0/SUNW,fas@3,8800000/sd@4,0'
        disk5: '/sbus@3,0/SUNW,fas@3,8800000/sd@5,0'
        tape0: '/sbus@3,0/SUNW,fas@3,8800000/st@4,0'
        tape1: '/sbus@3,0/SUNW,fas@3,8800000/st@5,0'
        ttya: '/central/fhc/zs@0,902000:a'
        ttyb: '/central/fhc/zs@0,902000:b'
        keyboard: '/central/fhc/zs@0,904000'
        keyboard!: '/central/fhc/zs@0,904000:forcemode'
        name: 'aliases'

    Node 0xf004efb4
        .node:  f004efb4
        reg:  00000000.00000000.00000000.40000000.00000000.40000000.00000000.40000000
        available:  00000000.7fce2000.00000000.00014000.00000000.7fc00000.00000000.000d2000.00000000.00000000.00000000.7f7de000
        name: 'memory'

    Node 0xf004f594
        .node:  f004f594
        translations:  00000000.fffd0000.00000000.00020000.80000000.7ff600b6.00000000.fff70000.00000000.00060000.80000000.7fef80b6.00000000.fff6e000.00000000.00002000.80000000.7fbfe0b6.00000000.fff6c000.00000000.00002000.80000000.7fef60b6.00000000.fff66000.00000000.00002000.800001ff.f890208e.00000000.fff64000.00000000.00002000.800001ff.f890808e.00000000.fff62000.00000000.00002000.800001ff.f890808e.00000000.fff60000.00000000.00002000.800001c4.f830008e.00000000.fff5e000.00000000.00002000.800001d4.f830008e.00000000.fff5c000.00000000.00002000.800001dc.f830008e.00000000.ffdd8000.00000000.00184000.80000000.7fd720b6.00000000.ffdcc000.00000000.0000c000.800001cc.f880408e.00000000.ffdca000.00000000.00002000.80000000.7fd700b6.00000000.ffdc8000.00000000.00002000.800001ff.f820608e.00000000.ffdc4000.00000000.00004000.80000000.7fd3c0b6.00000000.ffdc2000.00000000.00002000.800001ff.f890408e.00000000.ffdc0000.00000000.00002000.80000000.7fd3a0b6.00000000.ffdb2000.00000000.00006000.800001c4.0000
 008e.00000000.ffdac000.00000000.00006000.800001c4.0000008e.00000000.ffda4000.00000000.00008000.80000000.7fd680b6.00000000.ffd98000.00000000.0000c000.800001c4.f880408e.00000000.ffd96000.00000000.00002000.800001c4.f830008e.00000000.ffd94000.00000000.00002000.800001c4.0000208e.00000000.ffd92000.00000000.00002000.800001c4.0000208e.00000000.ffd90000.00000000.00002000.800001c4.0000208e.00000000.ffd8a000.00000000.00006000.800001c6.0000008e.00000000.ffd84000.00000000.00006000.800001c6.0000008e.00000000.ffd7c000.00000000.00008000.80000000.7fd600b6.00000000.ffd7a000.00000000.00002000.800001c6.0000208e.00000000.ffd78000.00000000.00002000.800001c6.0000208e.00000000.ffd76000.00000000.00002000.800001c6.0000208e.00000000.ffd70000.00000000.00006000.800001d4.0000008e.00000000.ffd6a000.00000000.00006000.800001d4.0000008e.00000000.ffd62000.00000000.00008000.80000000.7fd580b6.00000000.ffd56000.00000000.0000c000.800001d4.f880408e.00000000.ffd54000.00000000.00002000.800001d4.f830008e.00000000.ffd
 52000.00000000.00002000.800001d4.0000208e.00000000.ffd50000.00000000.00002000.800001d4.0000208e.00000000.ffd4e000.00000000.00002000.800001d4.0000208e.00000000.ffd48000.00000000.00006000.800001d6.0000008e.00000000.ffd42000.00000000.00006000.800001d6.0000008e.00000000.ffd3a000.00000000.00008000.80000000.7fd500b6.00000000.ffd38000.00000000.00002000.800001d6.0000208e.00000000.ffd36000.00000000.00002000.800001d6.0000208e.00000000.ffd34000.00000000.00002000.800001d6.0000208e.00000000.ffd32000.00000000.00002000.800001dc.0000408e.00000000.ffd30000.00000000.00002000.880001dc.0100008e.00000000.ffd22000.00000000.0000e000.800001dc.0000008e.00000000.ffd1a000.00000000.00008000.80000000.7fd480b6.00000000.ffd18000.00000000.00002000.800001dc.0000208e.00000000.ffd16000.00000000.00002000.880001dc.0180008e.00000000.ffd08000.00000000.0000e000.800001dc.0000008e.00000000.ffcfc000.00000000.0000c000.800001dc.f880408e.00000000.ffcfa000.00000000.00002000.800001dc.f830008e.00000000.ffcf8000.00000000.00
 002000.800001dc.0000008e.00000000.ffcf6000.00000000.00002000.800001dc.0000008e.00000000.ffcf4000.00000000.00002000.800001dc.0000008e.00000000.ffcf2000.00000000.00002000.800001de.0000408e.00000000.ffcf0000.00000000.00002000.880001de.0100008e.00000000.ffce2000.00000000.0000e000.800001de.0000008e.00000000.ffcda000.00000000.00008000.80000000.7fd400b6.00000000.ffcd8000.00000000.00002000.800001de.0000208e.00000000.ffcd6000.00000000.00002000.880001de.0180008e.00000000.ffcc8000.00000000.0000e000.800001de.0000008e.00000000.ffcc6000.00000000.00002000.800001de.0000008e.00000000.ffcc4000.00000000.00002000.800001de.0000008e.00000000.ffcc2000.00000000.00002000.800001de.0000008e.00000000.ffac2000.00000000.00200000.80000000.7f7de0b6.00000000.f07fe000.00000000.00002000.800001ff.f004208e.00000000.f02a0000.00000000.00040000.80000000.7fcfa0b6.00000000.f0080000.00000000.00220000.80000000.7f9de0b6.00000000.f0000000.00000000.00080000.80000000.7ff800b6.00000000.4162a000.00000000.029d6000.80000000.0
 1a2a036.00000000.40000000.00000000.00c00000.80000000.00400036.00000000.00002000.00000000.00bfe000.80000000.00002036
        existing:  00000000.00000000.00000800.00000000.fffff800.00000000.00000800.00000000
        available:  fffff800.00000000.000007fc.00000000.00000001.00000000.000007ff.00000000.00000000.ffff0000.00000000.0000e000.00000000.00000000.00000000.f0000000.00000000.ffdb8000.00000000.00008000.00000000.f0800000.00000000.0f2c2000
        page-size:  00002000
        name: 'virtual-memory'

    Node 0xf005da70
        .node:  f005da70
        ranges:  00000000.f8000000.000001ff.f8000000.08000000
        reg:  000001ff.00000000.00000000.08000000
        name: 'central'

        Node 0xf005db8c
            .node:  f005db8c
            board-model: 'SUNW,501-2511'
            ranges:  00000000.00000000.00000000.f8000000.08000000
            reg:  00000000.f8800000.00000110.00000000.f8802000.00000010.00000000.f8804000.00000020.00000000.f8806000.00000020.00000000.f8808000.00000020.00000000.f880a000.00000020
            name: 'fhc'

            Node 0xf005dd0c
                .node:  f005dd0c
                address:  fff62000
                watchdog-enable:  
                interrupts:  0000003a
                reg:  00000000.00908000.00002000
                model: 'mk48t59'
                name: 'eeprom'

            Node 0xf005de3c
                .node:  f005de3c
                port-b-ignore-cd:  
                port-a-ignore-cd:  
                address:  fff66000
                interrupts:  00000039
                device_type: 'serial'
                reg:  00000000.00902000.00000008
                name: 'zs'

            Node 0xf005df14
                .node:  f005df14
                address:  ffdc2000
                port-b-ignore-cd:  
                port-a-ignore-cd:  
                keyboard:  
                interrupts:  00000039
                device_type: 'serial'
                reg:  00000000.00904000.00000008
                name: 'zs'

            Node 0xf005e05c
                .node:  f005e05c
                reg:  00000000.00900000.00000008.00000000.00906000.00000060.00000000.0090c000.00000001
                interrupts:  00000038
                name: 'clock-board'

    Node 0xf00df7bc
        .node:  f00df7bc
        board-type: 'cpu'
        board-model: 'SUNW,501-2557'
        ranges:  00000000.00000000.000001cc.f8000000.08000000
        central-space:  
        board#:  00000003
        reg:  000001cc.f8800000.00000000.00000110.000001cc.f8802000.00000000.00000010.000001cc.f8804000.00000000.00000020.000001cc.f8806000.00000000.00000020.000001cc.f8808000.00000000.00000020.000001cc.f880a000.00000000.00000020
        manfid#:  0000003e
        version#:  00000001
        model: 'SUNW,fhc0FA0'
        name: 'fhc'

        Node 0xf00dfa08
            .node:  f00dfa08
            reg:  00000000.01000000.00008000.00000000.02000000.01000000
            bank-0-status: 'ok'
            bank-1-status: 'ok'
            manfid#:  0000003e
            version#:  00000005
            model: 'SUNW,ac0F9E'
            device_type: 'memory-controller'
            name: 'ac'

        Node 0xf00dfb90
            .node:  f00dfb90
            reg:  00000000.00600000.00000010
            name: 'simm-status'

        Node 0xf00dfc28
            .node:  f00dfc28
            interrupts:  0000003b
            reg:  00000000.00400000.00000010
            name: 'environment'

        Node 0xf00dfce4
            .node:  f00dfce4
            reg:  00000000.00200000.00008000.00000000.00280000.00008000
            name: 'sram'

        Node 0xf00dfd80
            .node:  f00dfd80
            version:  4f425020.2020332e.322e3330.20323030.322f3130.2f323520.31343a30.3300504f.53542020.332e392e.33302032.3030322f.31302f32.35203134.3a303400
            model: 'SUNW,525-1431'
            reg:  00000000.00000000.00080000
            name: 'flashprom'

    Node 0xf00dfec4
        .node:  f00dfec4
        manufacturer#:  00000017
        implementation#:  00000011
        mask#:  000000a0
        sparc-version:  00000009
        ecache-associativity:  00000001
        ecache-line-size:  00000040
        ecache-size:  00800000
        #dtlb-entries:  00000040
        dcache-associativity:  00000001
        dcache-line-size:  00000020
        dcache-size:  00004000
        #itlb-entries:  00000040
        icache-associativity:  00000002
        icache-line-size:  00000020
        icache-size:  00004000
        upa-portid:  00000006
        clock-frequency:  17d78400
        rated-frequency:  17d78400
        reg:  000001cc.00000000.00000000.00000008
        board#:  00000003
        device_type: 'cpu'
        name: 'SUNW,UltraSPARC-II'

    Node 0xf00e0284
        .node:  f00e0284
        manufacturer#:  00000017
        implementation#:  00000011
        mask#:  000000a0
        sparc-version:  00000009
        ecache-associativity:  00000001
        ecache-line-size:  00000040
        ecache-size:  00800000
        #dtlb-entries:  00000040
        dcache-associativity:  00000001
        dcache-line-size:  00000020
        dcache-size:  00004000
        #itlb-entries:  00000040
        icache-associativity:  00000002
        icache-line-size:  00000020
        icache-size:  00004000
        upa-portid:  00000007
        clock-frequency:  17d78400
        rated-frequency:  17d78400
        reg:  000001ce.00000000.00000000.00000008
        board#:  00000003
        device_type: 'cpu'
        name: 'SUNW,UltraSPARC-II'

    Node 0xf006f7bc
        .node:  f006f7bc
        ranges:  00000001.00000000.000001c5.10000000.10000000.00000002.00000000.000001c5.20000000.10000000.0000000d.00000000.000001c5.d0000000.10000000
        interrupts:  000000b4.000000b5.000000b6.000000a5.000000aa.000000b7
        version#:  00000001
        implementation#:  00000000
        bus-parity-generated:  
        address:  ffdb2000
        scsi-initiator-id:  00000007
        model: 'SUNW,sysio'
        reg:  000001c4.00000000.00000000.00006000
        slot-address-bits:  0000001c
        up-burst-sizes:  0078007f
        burst-sizes:  00f8007f
        device_type: 'sbus'
        name: 'sbus'
        upa-portid:  00000002
        clock-frequency:  017d7840
        board#:  00000001

        Node 0xf0075084
            .node:  f0075084
            wwn:  20040800.20b6eee2
            intr:  00000003.00000000
            interrupts:  00000022
            ranges:  00000000.00000000.0000000d.00010240.00000018.00000001.00000000.0000000d.00010258.00000018.00000010.00000000.0000000d.00010300.00000008.00000011.00000000.0000000d.00010308.00000008
            reg:  0000000d.00010000.00010018
            device_type: 'socal'
            version: '@(#) FCode 1.12 99/07/30'
            manufacturer: 'SUNW'
            model: '501-3060'
            name: 'SUNW,socal'

            Node 0xf007c8ec
                .node:  f007c8ec
                port-wwn:  20050800.20b6eee2
                reg:  00000000.00000000.00000018.00000010.00000000.00000008
                port#:  00000000
                #address-cells:  00000004
                device_type: 'scsi-3'
                name: 'sf'

                Node 0xf007e704
                    .node:  f007e704
                    device_type: 'block'
                    name: 'ssd'

            Node 0xf007efd4
                .node:  f007efd4
                port-wwn:  20060800.20b6eee2
                reg:  00000001.00000000.00000018.00000011.00000000.00000008
                port#:  00000001
                #address-cells:  00000004
                device_type: 'scsi-3'
                name: 'sf'

                Node 0xf007f670
                    .node:  f007f670
                    device_type: 'block'
                    name: 'ssd'

        Node 0xf0080050
            .node:  f0080050
            local-mac-address:  080020ee.2248
            gem-rev:  00000000
            burst-sizes:  0078007f
            shared-pins: 'serdes'
            board-rev:  00000005
            interrupts:  00000004
            compatible: 'SUNW,sbus-gem'
            model: 'SUNW,sbus-gem'
            has-fcode: ' '
            version: '1.7'
            device_type: 'network'
            address-bits:  00000030
            max-frame-size:  00004000
            reg:  00000001.00100000.00000014.00000001.00200000.00009060
            name: 'network'

        Node 0xf0086420
            .node:  f0086420
            scsi-initiator-id:  00000007
            isp-fcode: '1.21 95/05/18'
            device_type: 'scsi'
            intr:  00000003.00000000
            interrupts:  00000003
            wide:  00
            clock-frequency:  02625a00
            reg:  00000002.00010000.00000450
            64-bit-clean:  00
            model: 'QLGC,ISP1000'
            name: 'QLGC,isp'

            Node 0xf008bc8c
                .node:  f008bc8c
                device_type: 'block'
                name: 'sd'

            Node 0xf008c4a0
                .node:  f008c4a0
                device_type: 'byte'
                name: 'st'

    Node 0xf0071c1c
        .node:  f0071c1c
        board-type: 'dual-sbus-soc+'
        manfid#:  0000003e
        version#:  00000001
        ranges:  00000000.00000000.000001c4.f8000000.08000000
        reg:  000001c4.f8800000.00000000.00000110.000001c4.f8802000.00000000.00000010.000001c4.f8804000.00000000.00000020.000001c4.f8806000.00000000.00000020.000001c4.f8808000.00000000.00000020.000001c4.f880a000.00000000.00000020
        board-model: 'SUNW,501-2558'
        model: 'SUNW,fhc0FA0'
        board#:  00000001
        name: 'fhc'

        Node 0xf00720cc
            .node:  f00720cc
            manfid#:  0000003e
            version#:  00000005
            device_type: 'memory-controller'
            reg:  00000000.01000000.00008000.00000000.02000000.01000000
            model: 'SUNW,ac0F9E'
            name: 'ac'

        Node 0xf0072204
            .node:  f0072204
            interrupts:  0000003b
            reg:  00000000.00400000.00000010
            name: 'environment'

        Node 0xf00722c0
            .node:  f00722c0
            version:  46434f44.4520312e.382e3330.20323030.322f3130.2f323520.31343a30.32006950.4f535420.332e342e.33302032.3030322f.31302f32.35203134.3a303300
            model: 'SUNW,525-1757'
            reg:  00000000.00000000.00080000
            name: 'flashprom'

        Node 0xf00726f8
            .node:  f00726f8
            address:  ffd96000
            interrupts:  0000003a
            reg:  00000000.00300000.00002000
            model: 'mk48t59'
            name: 'eeprom'

        Node 0xf00727f0
            .node:  f00727f0
            reg:  00000000.00500000.00000010
            name: 'sbus-speed'

    Node 0xf00728e4
        .node:  f00728e4
        address:  ffd95c00.ffd91860.ffd93060
        interrupts:  000000b0.000000b1
        reg:  000001c4.00003c00.00000000.00000020.000001c4.00003860.00000000.00000010.000001c4.00003060.00000000.00000010
        board#:  00000001
        name: 'counter-timer'

    Node 0xf0072ad4
        .node:  f0072ad4
        ranges:  00000000.00000000.000001c7.00000000.10000000.00000003.00000000.000001c7.30000000.10000000
        interrupts:  000000f4.000000f5.000000f6.000000e5.000000ea.000000f7
        version#:  00000001
        implementation#:  00000000
        bus-parity-generated:  
        address:  ffd8a000
        scsi-initiator-id:  00000007
        model: 'SUNW,sysio'
        reg:  000001c6.00000000.00000000.00006000
        slot-address-bits:  0000001c
        up-burst-sizes:  0078007f
        burst-sizes:  00f8007f
        device_type: 'sbus'
        name: 'sbus'
        upa-portid:  00000003
        clock-frequency:  017d7840
        board#:  00000001

        Node 0xf008d070
            .node:  f008d070
            hm-rev:  00000022
            device_type: 'network'
            intr:  00000004.00000000
            interrupts:  00000004
            address-bits:  00000030
            max-frame-size:  00004000
            reg:  00000003.08c00000.00000108.00000003.08c02000.00002000.00000003.08c04000.00002000.00000003.08c06000.00002000.00000003.08c07000.00000020
            name: 'SUNW,hme'

        Node 0xf0093c14
            .node:  f0093c14
            hm-rev:  00000022
            device_type: 'scsi'
            clock-frequency:  02625a00
            intr:  00000003.00000000
            interrupts:  00000003
            reg:  00000003.08800000.00000010.00000003.08810000.00000040
            name: 'SUNW,fas'

            Node 0xf009864c
                .node:  f009864c
                device_type: 'block'
                name: 'sd'

            Node 0xf0098f08
                .node:  f0098f08
                device_type: 'byte'
                name: 'st'

        Node 0xf0099bf4
            .node:  f0099bf4
            local-mac-address:  08002093.7994
            hm-rev:  00000022
            device_type: 'network'
            intr:  00000004.00000000
            interrupts:  00000004
            address-bits:  00000030
            max-frame-size:  00004000
            reg:  00000000.08c00000.00000108.00000000.08c02000.00002000.00000000.08c04000.00002000.00000000.08c06000.00002000.00000000.08c07000.00000020
            model: 'SUNW,sbus-qfe'
            version: '1.11'
            name: 'SUNW,qfe'

        Node 0xf009fba8
            .node:  f009fba8
            local-mac-address:  08002093.7995
            hm-rev:  00000022
            device_type: 'network'
            intr:  00000004.00000000
            interrupts:  00000004
            address-bits:  00000030
            max-frame-size:  00004000
            reg:  00000000.08c10000.00000108.00000000.08c12000.00002000.00000000.08c14000.00002000.00000000.08c16000.00002000.00000000.08c17000.00000020
            model: 'SUNW,sbus-qfe'
            version: '1.11'
            name: 'SUNW,qfe'

        Node 0xf00a5a84
            .node:  f00a5a84
            local-mac-address:  08002093.7996
            hm-rev:  00000022
            device_type: 'network'
            intr:  00000004.00000000
            interrupts:  00000004
            address-bits:  00000030
            max-frame-size:  00004000
            reg:  00000000.08c20000.00000108.00000000.08c22000.00002000.00000000.08c24000.00002000.00000000.08c26000.00002000.00000000.08c27000.00000020
            model: 'SUNW,sbus-qfe'
            version: '1.11'
            name: 'SUNW,qfe'

        Node 0xf00ab960
            .node:  f00ab960
            local-mac-address:  08002093.7997
            hm-rev:  00000022
            device_type: 'network'
            intr:  00000004.00000000
            interrupts:  00000004
            address-bits:  00000030
            max-frame-size:  00004000
            reg:  00000000.08c30000.00000108.00000000.08c32000.00002000.00000000.08c34000.00002000.00000000.08c36000.00002000.00000000.08c37000.00000020
            model: 'SUNW,sbus-qfe'
            version: '1.11'
            name: 'SUNW,qfe'

    Node 0xf0074e94
        .node:  f0074e94
        address:  ffd7bc00.ffd77860.ffd79060
        interrupts:  000000f0.000000f1
        reg:  000001c6.00003c00.00000000.00000020.000001c6.00003860.00000000.00000010.000001c6.00003060.00000000.00000010
        board#:  00000001
        name: 'counter-timer'

    Node 0xf014f7bc
        .node:  f014f7bc
        ranges:  00000001.00000000.000001d5.10000000.10000000.00000002.00000000.000001d5.20000000.10000000.0000000d.00000000.000001d5.d0000000.10000000
        interrupts:  000002b4.000002b5.000002b6.000002a5.000002aa.000002b7
        version#:  00000001
        implementation#:  00000000
        bus-parity-generated:  
        address:  ffd70000
        scsi-initiator-id:  00000007
        model: 'SUNW,sysio'
        reg:  000001d4.00000000.00000000.00006000
        slot-address-bits:  0000001c
        up-burst-sizes:  0078007f
        burst-sizes:  00f8007f
        device_type: 'sbus'
        name: 'sbus'
        upa-portid:  0000000a
        clock-frequency:  017d7840
        board#:  00000005

        Node 0xf0155084
            .node:  f0155084
            wwn:  20140800.20b6eee2
            intr:  00000003.00000000
            interrupts:  00000022
            ranges:  00000000.00000000.0000000d.00010240.00000018.00000001.00000000.0000000d.00010258.00000018.00000010.00000000.0000000d.00010300.00000008.00000011.00000000.0000000d.00010308.00000008
            reg:  0000000d.00010000.00010018
            device_type: 'socal'
            version: '@(#) FCode 1.12 99/07/30'
            manufacturer: 'SUNW'
            model: '501-3060'
            name: 'SUNW,socal'

            Node 0xf015c8ec
                .node:  f015c8ec
                port-wwn:  20150800.20b6eee2
                reg:  00000000.00000000.00000018.00000010.00000000.00000008
                port#:  00000000
                #address-cells:  00000004
                device_type: 'scsi-3'
                name: 'sf'

                Node 0xf015e704
                    .node:  f015e704
                    device_type: 'block'
                    name: 'ssd'

            Node 0xf015efd4
                .node:  f015efd4
                port-wwn:  20160800.20b6eee2
                reg:  00000001.00000000.00000018.00000011.00000000.00000008
                port#:  00000001
                #address-cells:  00000004
                device_type: 'scsi-3'
                name: 'sf'

                Node 0xf015f670
                    .node:  f015f670
                    device_type: 'block'
                    name: 'ssd'

        Node 0xf0160050
            .node:  f0160050
            scsi-initiator-id:  00000007
            clock-frequency:  03938700
            differential:  00
            isp-fcode: '1.28 99/11/08'
            device_type: 'scsi'
            intr:  00000003.00000000
            interrupts:  00000003
            wide:  00
            fast-20:  00
            reg:  00000001.00010000.00000450
            64-bit-clean:  00
            model: 'QLGC,ISP1000U'
            name: 'QLGC,isp'

            Node 0xf0165dc8
                .node:  f0165dc8
                device_type: 'block'
                name: 'sd'

            Node 0xf01665b8
                .node:  f01665b8
                device_type: 'byte'
                name: 'st'

        Node 0xf016713c
            .node:  f016713c
            cache-linesize:  00000010
            cache-size:  00008000
            intr:  00000002.00000000
            interrupts:  00000002
            reg:  00000002.00010000.00000080.00000002.00020000.00000068.00000002.00030000.0000000c
            model: 'SUNW,501-1763-01'
            name: 'SUNW,SunPC'

    Node 0xf0151c1c
        .node:  f0151c1c
        board-type: 'dual-sbus-soc+'
        manfid#:  0000003e
        version#:  00000001
        ranges:  00000000.00000000.000001d4.f8000000.08000000
        reg:  000001d4.f8800000.00000000.00000110.000001d4.f8802000.00000000.00000010.000001d4.f8804000.00000000.00000020.000001d4.f8806000.00000000.00000020.000001d4.f8808000.00000000.00000020.000001d4.f880a000.00000000.00000020
        board-model: 'SUNW,501-2558'
        model: 'SUNW,fhc0FA0'
        board#:  00000005
        name: 'fhc'

        Node 0xf01520cc
            .node:  f01520cc
            manfid#:  0000003e
            version#:  00000005
            device_type: 'memory-controller'
            reg:  00000000.01000000.00008000.00000000.02000000.01000000
            model: 'SUNW,ac0F9E'
            name: 'ac'

        Node 0xf0152204
            .node:  f0152204
            interrupts:  0000003b
            reg:  00000000.00400000.00000010
            name: 'environment'

        Node 0xf01522c0
            .node:  f01522c0
            version:  46434f44.4520312e.382e3330.20323030.322f3130.2f323520.31343a30.32006950.4f535420.332e342e.33302032.3030322f.31302f32.35203134.3a303300
            model: 'SUNW,525-1757'
            reg:  00000000.00000000.00080000
            name: 'flashprom'

        Node 0xf01526f8
            .node:  f01526f8
            address:  ffd54000
            interrupts:  0000003a
            reg:  00000000.00300000.00002000
            model: 'mk48t59'
            name: 'eeprom'

        Node 0xf01527f0
            .node:  f01527f0
            reg:  00000000.00500000.00000010
            name: 'sbus-speed'

    Node 0xf01528e4
        .node:  f01528e4
        address:  ffd53c00.ffd4f860.ffd51060
        interrupts:  000002b0.000002b1
        reg:  000001d4.00003c00.00000000.00000020.000001d4.00003860.00000000.00000010.000001d4.00003060.00000000.00000010
        board#:  00000005
        name: 'counter-timer'

    Node 0xf0152ad4
        .node:  f0152ad4
        ranges:  00000000.00000000.000001d7.00000000.10000000.00000003.00000000.000001d7.30000000.10000000
        interrupts:  000002f4.000002f5.000002f6.000002e5.000002ea.000002f7
        version#:  00000001
        implementation#:  00000000
        bus-parity-generated:  
        address:  ffd48000
        scsi-initiator-id:  00000007
        model: 'SUNW,sysio'
        reg:  000001d6.00000000.00000000.00006000
        slot-address-bits:  0000001c
        up-burst-sizes:  0078007f
        burst-sizes:  00f8007f
        device_type: 'sbus'
        name: 'sbus'
        upa-portid:  0000000b
        clock-frequency:  017d7840
        board#:  00000005

        Node 0xf01673a8
            .node:  f01673a8
            hm-rev:  00000022
            device_type: 'network'
            intr:  00000004.00000000
            interrupts:  00000004
            address-bits:  00000030
            max-frame-size:  00004000
            reg:  00000003.08c00000.00000108.00000003.08c02000.00002000.00000003.08c04000.00002000.00000003.08c06000.00002000.00000003.08c07000.00000020
            name: 'SUNW,hme'

        Node 0xf016df4c
            .node:  f016df4c
            hm-rev:  00000022
            device_type: 'scsi'
            clock-frequency:  02625a00
            intr:  00000003.00000000
            interrupts:  00000003
            reg:  00000003.08800000.00000010.00000003.08810000.00000040
            name: 'SUNW,fas'

            Node 0xf0172984
                .node:  f0172984
                device_type: 'block'
                name: 'sd'

            Node 0xf0173240
                .node:  f0173240
                device_type: 'byte'
                name: 'st'

        Node 0xf0173f2c
            .node:  f0173f2c
            scsi-initiator-id:  00000007
            clock-frequency:  03938700
            differential:  00
            isp-fcode: '1.28 99/11/08'
            device_type: 'scsi'
            intr:  00000003.00000000
            interrupts:  00000003
            wide:  00
            fast-20:  00
            reg:  00000000.00010000.00000450
            64-bit-clean:  00
            model: 'QLGC,ISP1000U'
            name: 'QLGC,isp'

            Node 0xf0179ca4
                .node:  f0179ca4
                device_type: 'block'
                name: 'sd'

            Node 0xf017a494
                .node:  f017a494
                device_type: 'byte'
                name: 'st'

    Node 0xf0154e94
        .node:  f0154e94
        address:  ffd39c00.ffd35860.ffd37060
        interrupts:  000002f0.000002f1
        reg:  000001d6.00003c00.00000000.00000020.000001d6.00003860.00000000.00000010.000001d6.00003060.00000000.00000010
        board#:  00000005
        name: 'counter-timer'

    Node 0xf01bf7bc
        .node:  f01bf7bc
        available:  82000000.00000000.02808000.00000000.7d7f8000.81000000.00000000.00000400.00000000.0000fc00
        bus-range:  00000000.00000000
        version#:  00000004
        implementation#:  00000000
        clock-frequency:  01f78a40
        upa-portid:  0000000e
        interrupts:  000003b1.000003ae.000003af.000003a5.000003a8.000003b2
        ranges:  00000000.00000000.00000000.000001dc.01000000.00000000.00800000.01000000.00000000.00000000.000001dc.02010000.00000000.00010000.02000000.00000000.00000000.000001dd.80000000.00000000.80000000.03000000.00000000.00000000.000001dd.80000000.00000000.80000000
        address:  ffd32000.ffd30000.ffd22000
        reg:  000001dc.00004000.00000000.00002000.000001dc.01000000.00000000.00000100.000001dc.00000000.00000000.0000d000
        board#:  00000007
        model: 'SUNW,psycho'
        compatible: 'pci108e,8000'
        bus-parity-generated:  
        #size-cells:  00000002
        #address-cells:  00000003
        device_type: 'pci'
        name: 'pci'

        Node 0xf01d3d84
            .node:  f01d3d84
            assigned-addresses:  82000810.00000000.01000000.00000000.01000000.82000814.00000000.02000000.00000000.00800000
            power-consumption:  00000000.00e4e1c0
            reg:  00000800.00000000.00000000.00000000.00000000.02000810.00000000.00000000.00000000.01000000.02000814.00000000.00000000.00000000.00800000
            compatible:  70636931.3038652c.31303030.00706369.636c6173.732c3036.38303030.00
            name: 'pci108e,1000'
            66mhz-capable:  00000000
            udf-supported:  00000000
            fast-back-to-back:  00000001
            devsel-speed:  00000001
            class-code:  00068000
            interrupts:  00000001
            max-latency:  00000019
            min-grant:  0000000a
            revision-id:  00000001
            device-id:  00001000
            vendor-id:  0000108e

        Node 0xf01d4058
            .node:  f01d4058
            assigned-addresses:  82000910.00000000.02800000.00000000.00007030
            compatible: 'pci108e,1001'
            version: '1.17'
            device_type: 'network'
            hm-rev:  000000c1
            address-bits:  00000030
            max-frame-size:  00004000
            reg:  00000900.00000000.00000000.00000000.00000000.02000910.00000000.00000000.00000000.00007030
            model: 'SUNW,cheerio'
            name: 'SUNW,hme'
            66mhz-capable:  00000000
            udf-supported:  00000000
            fast-back-to-back:  00000001
            devsel-speed:  00000001
            class-code:  00020000
            interrupts:  000003a1
            max-latency:  00000005
            min-grant:  0000000a
            revision-id:  00000001
            device-id:  00001001
            vendor-id:  0000108e

    Node 0xf01c88e0
        .node:  f01c88e0
        available:  82800000.00000000.00002100.00000000.7fffdf00.81800000.00000000.00000440.00000000.0000fbc0
        bus-range:  00000080.00000080
        version#:  00000004
        implementation#:  00000000
        clock-frequency:  01f78a40
        slot-names:  00000004.7063692d.736c6f74.203000
        upa-portid:  0000000e
        66mhz-capable:  
        interrupts:  000003b0.000003ae.000003af.000003a5.000003a8.000003b2
        ranges:  00800000.00000000.00000000.000001dc.01000000.00000000.00800000.01000000.00000000.00000000.000001dc.02000000.00000000.00010000.02000000.00000000.00000000.000001dd.00000000.00000000.80000000.03000000.00000000.00000000.000001dd.00000000.00000000.80000000
        address:  ffd18000.ffd16000.ffd08000
        reg:  000001dc.00002000.00000000.00002000.000001dc.01800000.00000000.00000100.000001dc.00000000.00000000.0000d000
        board#:  00000007
        model: 'SUNW,psycho'
        compatible: 'pci108e,8000'
        bus-parity-generated:  
        #size-cells:  00000002
        #address-cells:  00000003
        device_type: 'pci'
        name: 'pci'

        Node 0xf01e7cb8
            .node:  f01e7cb8
            assigned-addresses:  81801020.00000000.00000400.00000000.00000020
            power-consumption:  00000000.00e4e1c0
            reg:  00801000.00000000.00000000.00000000.00000000.01801020.00000000.00000000.00000000.00000020
            compatible:  70636939.32352c31.32333400.70636931.3130362c.33303338.00706369.636c6173.732c3063.30333030.00757362.00
            name: 'usb'
            66mhz-capable:  00000000
            udf-supported:  00000000
            fast-back-to-back:  00000000
            devsel-speed:  00000001
            class-code:  000c0300
            interrupts:  00000001
            subsystem-vendor-id:  00000925
            subsystem-id:  00001234
            max-latency:  00000000
            min-grant:  00000000
            revision-id:  00000050
            device-id:  00003038
            vendor-id:  00001106

        Node 0xf01e7fd4
            .node:  f01e7fd4
            assigned-addresses:  81801120.00000000.00000420.00000000.00000020
            reg:  00801100.00000000.00000000.00000000.00000000.01801120.00000000.00000000.00000000.00000020
            compatible:  70636939.32352c31.32333400.70636931.3130362c.33303338.00706369.636c6173.732c3063.30333030.00757362.00
            name: 'usb'
            66mhz-capable:  00000000
            udf-supported:  00000000
            fast-back-to-back:  00000000
            devsel-speed:  00000001
            class-code:  000c0300
            interrupts:  00000002
            subsystem-vendor-id:  00000925
            subsystem-id:  00001234
            max-latency:  00000000
            min-grant:  00000000
            revision-id:  00000050
            device-id:  00003038
            vendor-id:  00001106

        Node 0xf01e82c0
            .node:  f01e82c0
            assigned-addresses:  82801210.00000000.00002000.00000000.00000100
            reg:  00801200.00000000.00000000.00000000.00000000.02801210.00000000.00000000.00000000.00000100
            compatible:  70636939.32352c31.32333400.70636931.3130362c.33313034.00706369.636c6173.732c3063.30333230.00757362.00
            name: 'usb'
            66mhz-capable:  00000000
            udf-supported:  00000000
            fast-back-to-back:  00000000
            devsel-speed:  00000001
            class-code:  000c0320
            interrupts:  00000003
            subsystem-vendor-id:  00000925
            subsystem-id:  00001234
            max-latency:  00000000
            min-grant:  00000000
            revision-id:  00000051
            device-id:  00003104
            vendor-id:  00001106

    Node 0xf01c923c
        .node:  f01c923c
        board-type: 'dual-pci'
        manfid#:  0000003e
        version#:  00000001
        ranges:  00000000.00000000.000001dc.f8000000.08000000
        reg:  000001dc.f8800000.00000000.00000110.000001dc.f8802000.00000000.00000010.000001dc.f8804000.00000000.00000020.000001dc.f8806000.00000000.00000020.000001dc.f8808000.00000000.00000020.000001dc.f880a000.00000000.00000020
        board-model: 'SUNW,501-3023'
        model: 'SUNW,fhc0FA0'
        board#:  00000007
        name: 'fhc'

        Node 0xf01c9718
            .node:  f01c9718
            manfid#:  0000003e
            version#:  00000005
            device_type: 'memory-controller'
            reg:  00000000.01000000.00008000.00000000.02000000.01000000
            model: 'SUNW,ac0F9E'
            name: 'ac'

        Node 0xf01c9850
            .node:  f01c9850
            interrupts:  0000003b
            reg:  00000000.00400000.00000010
            name: 'environment'

        Node 0xf01c990c
            .node:  f01c990c
            version:  46434f44.4520312e.382e3330.20323030.322f3130.2f323520.31343a30.32006950.4f535420.332e302e.33302032.3030322f.31302f32.35203134.3a303300
            model: 'SUNW,525-1680'
            reg:  00000000.00000000.00080000
            name: 'flashprom'

        Node 0xf01c9d44
            .node:  f01c9d44
            address:  ffcfa000
            interrupts:  0000003a
            reg:  00000000.00300000.00002000
            model: 'mk48t59'
            name: 'eeprom'

        Node 0xf01c9e3c
            .node:  f01c9e3c
            reg:  00000000.00500000.00000010
            name: 'sbus-speed'

    Node 0xf01c9f28
        .node:  f01c9f28
        address:  ffcf9c00.ffcf5860.ffcf7060
        interrupts:  000003ac.000003ad
        reg:  000001dc.00001c00.00000000.00000020.000001dc.00001860.00000000.00000010.000001dc.00001060.00000000.00000010
        board#:  00000007
        name: 'counter-timer'

    Node 0xf01ca118
        .node:  f01ca118
        available:  82000000.00000000.00020000.00000000.7ffe0000.81000000.00000000.00000500.00000000.0000fb00
        bus-range:  00000000.00000000
        version#:  00000004
        implementation#:  00000000
        clock-frequency:  01f78a40
        upa-portid:  0000000f
        interrupts:  000003f1.000003ee.000003ef.000003e5.000003e8.000003f2
        ranges:  00000000.00000000.00000000.000001de.01000000.00000000.00800000.01000000.00000000.00000000.000001de.02010000.00000000.00010000.02000000.00000000.00000000.000001df.80000000.00000000.80000000.03000000.00000000.00000000.000001df.80000000.00000000.80000000
        address:  ffcf2000.ffcf0000.ffce2000
        reg:  000001de.00004000.00000000.00002000.000001de.01000000.00000000.00000100.000001de.00000000.00000000.0000d000
        board#:  00000007
        model: 'SUNW,psycho'
        compatible: 'pci108e,8000'
        bus-parity-generated:  
        #size-cells:  00000002
        #address-cells:  00000003
        device_type: 'pci'
        name: 'pci'

        Node 0xf01dc3c0
            .node:  f01dc3c0
            assigned-addresses:  81001810.00000000.00000400.00000000.00000100.82001814.00000000.00002000.00000000.00001000.82001830.00000000.00010000.00000000.00010000
            model: 'QLGC,ISP1040B'
            scsi-initiator-id:  00000007
            clock-frequency:  03938700
            alternate-reg:  00000000.00000000.00000000.00000000.00000000.02001814.00000000.00000000.00000000.00000100.01001810.00000000.00000000.00000000.00000100
            reg:  00001800.00000000.00000000.00000000.00000000.01001810.00000000.00000000.00000000.00000100.02001814.00000000.00000000.00000000.00001000.02001830.00000000.00000000.00000000.00010000
            power-consumption:  00000000.00000000.00895440.00895440
            manufacturer: 'QLGC'
            device_type: 'scsi'
            name: 'SUNW,isptwo'
            66mhz-capable:  00000000
            udf-supported:  00000000
            fast-back-to-back:  00000000
            devsel-speed:  00000001
            class-code:  00010000
            interrupts:  000003e0
            max-latency:  00000000
            min-grant:  00000000
            revision-id:  00000002
            device-id:  00001020
            vendor-id:  00001077

            Node 0xf01e6534
                .node:  f01e6534
                device_type: 'block'
                name: 'sd'

            Node 0xf01e7010
                .node:  f01e7010
                device_type: 'byte'
                name: 'st'

    Node 0xf01d320c
        .node:  f01d320c
        available:  82800000.00000000.00004000.00000000.7fffc000.81800000.00000000.00000900.00000000.0000f700
        bus-range:  00000080.00000080
        version#:  00000004
        implementation#:  00000000
        clock-frequency:  03ef1480
        slot-names:  00000004.7063692d.736c6f74.203100
        upa-portid:  0000000f
        66mhz-capable:  
        interrupts:  000003f0.000003ee.000003ef.000003e5.000003e8.000003f2
        ranges:  00800000.00000000.00000000.000001de.01000000.00000000.00800000.01000000.00000000.00000000.000001de.02000000.00000000.00010000.02000000.00000000.00000000.000001df.00000000.00000000.80000000.03000000.00000000.00000000.000001df.00000000.00000000.80000000
        address:  ffcd8000.ffcd6000.ffcc8000
        reg:  000001de.00002000.00000000.00002000.000001de.01800000.00000000.00000100.000001de.00000000.00000000.0000d000
        board#:  00000007
        model: 'SUNW,psycho'
        compatible: 'pci108e,8000'
        bus-parity-generated:  
        #size-cells:  00000002
        #address-cells:  00000003
        device_type: 'pci'
        name: 'pci'

        Node 0xf01e86d0
            .node:  f01e86d0
            assigned-addresses:  81801010.00000000.00000400.00000000.00000100.83801014.00000000.00002000.00000000.00002000.8180101c.00000000.00000800.00000000.00000100
            power-consumption:  00000000.00e4e1c0
            reg:  00801000.00000000.00000000.00000000.00000000.01801010.00000000.00000000.00000000.00000100.03801014.00000000.00000000.00000000.00002000.0180101c.00000000.00000000.00000000.00000100
            compatible:  70636939.3030352c.34340070.63693930.30352c38.30313700.70636963.6c617373.2c303130.30303000.73637369.00
            name: 'scsi'
            66mhz-capable:  00000001
            udf-supported:  00000000
            fast-back-to-back:  00000000
            devsel-speed:  00000002
            class-code:  00010000
            interrupts:  00000001
            subsystem-vendor-id:  00009005
            subsystem-id:  00000044
            max-latency:  00000019
            min-grant:  00000028
            revision-id:  00000010
            device-id:  00008017
            vendor-id:  00009005

    Node 0xf01d3b68
        .node:  f01d3b68
        address:  ffcc7c00.ffcc3860.ffcc5060
        interrupts:  000003ec.000003ed
        reg:  000001de.00001c00.00000000.00000020.000001de.00001860.00000000.00000010.000001de.00001060.00000000.00000010
        board#:  00000007
        name: 'counter-timer'


-- 
Meelis Roos (mroos@linux.ee)
