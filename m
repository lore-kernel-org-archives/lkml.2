Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2A0Oke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:40:34 -0500
Received: from smtpq2.gn.mail.iss.as9143.net ([212.54.34.165]:40316 "EHLO
	smtpq2.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702Ab2A0Okd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:40:33 -0500
X-Greylist: delayed 1337 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jan 2012 09:40:32 EST
Message-ID: <4F22B21E.1040005@sron.nl>
Date: Fri, 27 Jan 2012 15:18:06 +0100
From: Richard van Hees <r.m.van.hees@sron.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: NFS (v4) mount freezes after copying a few hundred Gbytes.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ziggo-spambar: ----
X-Ziggo-spamscore: -4.3
X-Ziggo-spamreport: ALL_TRUSTED=-1,BAYES_00=-1.9,CM_META_TB_NOARR=0.5,PROLO_TRUST_RDNS=-3,PROLO_TRUST_TO_DIRECT=-3.48,RDNS_DYNAMIC=0.982,SARE_PROLOSTOCK_SYM3=0.3,TO_NO_BRKTS_DIRECT=2.456,TW_BF=0.077,TW_BN=0.077,TW_CL=0.077,TW_FX=0.077,TW_II=0.077,TW_LX=0.077,TW_QE=0.077,TW_VM=0.077,TW_VN=0.077,TW_XS=0.077,TW_XT=0.077
X-Ziggo-Spam-Status: No
X-Spam-Flag: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

This is my first kernel problem report in ten years.
I hope that I give you all the required information...
Naturally, this could be hardware failure related.

Greetings, Richard van Hees
-----

[1.] One line summary of the problem:
NFS (v4) mount freezes after copying a few hunderd Gbytes.

[2.] Full description of the problem/report:
NFS (v4) mount freezes after copying a few hunderd Gbytes. All other 
mount-points are still available. Re-boot fails because the affected 
nfs-mount can not be closed.

[3.] Keywords (i.e., modules, networking, kernel): kernel - networking - 
NFS4

[4.] Kernel version (from /proc/version):
Linux version 3.2.2 (richardh@lepus) (gcc version 4.4.5 (Debian 4.4.5-8) 
) #1 SMP Thu Jan 26 16:47:24 CET 2012

[5.] Output of Oops.. message (if applicable) with symbolic information 
resolved (see Documentation/oops-tracing.txt)

    BUG: unable to handle kernel NULL pointer dereference at          
    (null)
    IP: [<ffffffff811315f4>] nfs4_xdr_enc_getacl+0x79/0xe4
    PGD 61194a067 PUD 609450067 PMD 0
    Oops: 0000 [#1] SMP
    CPU 7
    Pid: 14809, comm: cp Not tainted 3.2.2 #1 HP ProLiant DL380 G6
    RIP: 0010:[<ffffffff811315f4>]  [<ffffffff811315f4>]
    nfs4_xdr_enc_getacl+0x79/0xe4
    RSP: 0018:ffff88030d0f7a58  EFLAGS: 00010206
    RAX: ffff8805c02d39e8 RBX: ffff88030d0f7ce8 RCX: 0000000000000000
    RDX: ffff88030d0f7c28 RSI: 0000000000000000 RDI: ffff8806068cc048
    RBP: ffff88030d0f7ac8 R08: 0000000000001000 R09: 000000000000007c
    R10: ffff8805c02d39b0 R11: ffff88061189df70 R12: ffff8806068cc000
    R13: 000000000000000e R14: ffffffff8113157b R15: ffff880616de13c0
    FS:  00007f71f89cd7a0(0000) GS:ffff88061fd80000(0000)
    knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    CR2: 0000000000000000 CR3: 000000049ae59000 CR4: 00000000000006e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Process cp (pid: 14809, threadinfo ffff88030d0f6000, task
    ffff88030968d900)
    Stack:
      0000000200000000 ffff8805c02d3870 0000000000000000 0000000000000000
      000000000000006e ffffffff81060fb9 ffff8806068cc000 ffff88030d0f7ac8
      ffff8805c02d3868 ffff88051e750300 ffffffff8113157b ffffffff8131413a
    Call Trace:
      [<ffffffff81060fb9>] ? mempool_alloc+0x45/0xff
      [<ffffffff8113157b>] ? nfs4_xdr_dec_read+0xdc/0xdc
      [<ffffffff8131413a>] ? rpcauth_wrap_req+0x9c/0xab
      [<ffffffff8130e4a3>] ? xprt_prepare_transmit+0x77/0x83
      [<ffffffff8130c8df>] ? call_transmit+0x1be/0x241
      [<ffffffff81313411>] ? __rpc_execute+0x71/0x23f
      [<ffffffff8103fe1c>] ? wake_up_bit+0x10/0x20
      [<ffffffff8130d41a>] ? rpc_run_task+0x71/0x78
      [<ffffffff8130d504>] ? rpc_call_sync+0x3d/0x5d
      [<ffffffff8112d497>] ? __nfs4_get_acl_uncached+0x1b5/0x2a9
      [<ffffffff8112d65d>] ? nfs4_xattr_get_nfs4_acl+0xd2/0x10d
      [<ffffffff810acf08>] ? generic_getxattr+0x57/0x5b
      [<ffffffff810ad1d2>] ? vfs_getxattr+0x57/0x64
      [<ffffffff810ad947>] ? getxattr+0x8c/0xe8
      [<ffffffff810a01ef>] ? do_filp_open+0x2c/0x72
      [<ffffffff810a88fb>] ? alloc_fd+0x69/0x10a
      [<ffffffff8108aaa5>] ? virt_to_head_page+0x19/0x31
      [<ffffffff8108d454>] ? kmem_cache_free+0x14/0x6c
      [<ffffffff810ad9e3>] ? sys_fgetxattr+0x40/0x58
      [<ffffffff8134033b>] ? system_call_fastpath+0x16/0x1b
    Code: 00 00 48 89 ef e8 65 da ff ff 8b 4b 10 48 8b 53 18 42 8d 34 ad
    00 00 00 00 49 8d 7c 24 48 44 8b 43 08 e8 a4 96 1e 00 48 8b 73 20
    <48> 8b 06 48 c1 e8 2d 48 89 c2 48 c1 ea 08 48 8b 0c d5 80 b4 58
    RIP  [<ffffffff811315f4>] nfs4_xdr_enc_getacl+0x79/0xe4
      RSP <ffff88030d0f7a58>
    CR2: 0000000000000000
    ---[ end trace d95ec60002dc20df ]---

[6.] A small shell script or example program which triggers the problem 
(if possible)
Difficult, the problem occurs ramdomly after copying few hunderd Gbyte 
from a NFS (v4) mounted partition

[7.] Environment:
Debian sqeeuze

[7.1.] Software (add the output of the ver_linux script here)

    Linux betelgeuse 3.2.2 #1 SMP Thu Jan 26 16:47:24 CET 2012 x86_64
    GNU/Linux
    Gnu C 4.4.5
    Gnu make 3.81
    binutils 2.20.1
    util-linux 2.17.2
    mount support module-init-tools 3.12
    e2fsprogs 1.41.12
    Linux C Library 2.11.2
    Dynamic linker (ldd) 2.11.2
    Procps 3.2.8
    Net-tools 1.60
    Kbd 1.15.2
    Sh-utils 8.5

[7.2.] Processor information (from /proc/cpuinfo):

    processor    : 0
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 26
    model name    : Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    stepping    : 5
    microcode    : 0x16
    cpu MHz        : 2666.680
    cache size    : 8192 KB
    physical id    : 0
    siblings    : 4
    core id        : 0
    cpu cores    : 4
    apicid        : 0
    initial apicid    : 0
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 11
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
    mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
    syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
    nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx
    est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida
    dts tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 5335.58
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 40 bits physical, 48 bits virtual
    power management:

    processor    : 1
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 26
    model name    : Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    stepping    : 5
    microcode    : 0x16
    cpu MHz        : 2666.680
    cache size    : 8192 KB
    physical id    : 1
    siblings    : 4
    core id        : 0
    cpu cores    : 4
    apicid        : 16
    initial apicid    : 16
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 11
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
    mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
    syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
    nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx
    est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida
    dts tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 5335.48
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 40 bits physical, 48 bits virtual
    power management:

    processor    : 2
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 26
    model name    : Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    stepping    : 5
    microcode    : 0x16
    cpu MHz        : 2666.680
    cache size    : 8192 KB
    physical id    : 0
    siblings    : 4
    core id        : 2
    cpu cores    : 4
    apicid        : 4
    initial apicid    : 4
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 11
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
    mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
    syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
    nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx
    est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida
    dts tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 5335.46
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 40 bits physical, 48 bits virtual
    power management:

    processor    : 3
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 26
    model name    : Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    stepping    : 5
    microcode    : 0x16
    cpu MHz        : 2666.680
    cache size    : 8192 KB
    physical id    : 1
    siblings    : 4
    core id        : 2
    cpu cores    : 4
    apicid        : 20
    initial apicid    : 20
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 11
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
    mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
    syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
    nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx
    est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida
    dts tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 5335.47
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 40 bits physical, 48 bits virtual
    power management:

    processor    : 4
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 26
    model name    : Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    stepping    : 5
    microcode    : 0x16
    cpu MHz        : 2666.680
    cache size    : 8192 KB
    physical id    : 0
    siblings    : 4
    core id        : 1
    cpu cores    : 4
    apicid        : 2
    initial apicid    : 2
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 11
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
    mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
    syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
    nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx
    est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida
    dts tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 5335.46
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 40 bits physical, 48 bits virtual
    power management:

    processor    : 5
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 26
    model name    : Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    stepping    : 5
    microcode    : 0x16
    cpu MHz        : 2666.680
    cache size    : 8192 KB
    physical id    : 1
    siblings    : 4
    core id        : 1
    cpu cores    : 4
    apicid        : 18
    initial apicid    : 18
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 11
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
    mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
    syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
    nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx
    est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida
    dts tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 5335.48
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 40 bits physical, 48 bits virtual
    power management:

    processor    : 6
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 26
    model name    : Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    stepping    : 5
    microcode    : 0x16
    cpu MHz        : 2666.680
    cache size    : 8192 KB
    physical id    : 0
    siblings    : 4
    core id        : 3
    cpu cores    : 4
    apicid        : 6
    initial apicid    : 6
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 11
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
    mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
    syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
    nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx
    est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida
    dts tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 5335.47
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 40 bits physical, 48 bits virtual
    power management:

    processor    : 7
    vendor_id    : GenuineIntel
    cpu family    : 6
    model        : 26
    model name    : Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    stepping    : 5
    microcode    : 0x16
    cpu MHz        : 2666.680
    cache size    : 8192 KB
    physical id    : 1
    siblings    : 4
    core id        : 3
    cpu cores    : 4
    apicid        : 22
    initial apicid    : 22
    fpu        : yes
    fpu_exception    : yes
    cpuid level    : 11
    wp        : yes
    flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
    mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
    syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
    nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx
    est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida
    dts tpr_shadow vnmi flexpriority ept vpid
    bogomips    : 5335.48
    clflush size    : 64
    cache_alignment    : 64
    address sizes    : 40 bits physical, 48 bits virtual
    power management:

[7.3.] Module information (from /proc/modules):
     None!

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

     >> cat /proc/ioports
    0000-03af : PCI Bus 0000:00
       0000-001f : dma1
       0020-0021 : pic1
       0040-0043 : timer0
       0050-0053 : timer1
       0060-0060 : keyboard
       0064-0064 : keyboard
       0070-0077 : rtc
       0080-008f : dma page reg
       00a0-00a1 : pic2
       00c0-00df : dma2
       00f0-00ff : fpu
       02f8-02ff : pnp 00:01
         02f8-02ff : serial
    03b0-03bb : PCI Bus 0000:00
    03c0-03df : PCI Bus 0000:00
       03c0-03df : vga+
    03e0-0cf7 : PCI Bus 0000:00
       03f8-03ff : serial
       0408-040f : pnp 00:01
       04d0-04d1 : pnp 00:01
       0700-071f : pnp 00:01
       0880-08ff : pnp 00:01
       0900-097f : pnp 00:01
         0900-0903 : ACPI PM1a_EVT_BLK
         0904-0907 : ACPI PM1a_CNT_BLK
         0908-090b : ACPI PM_TMR
         0920-092f : ACPI GPE0_BLK
         0950-0953 : ACPI PM2_CNT_BLK
       0c80-0c83 : pnp 00:01
       0ca0-0ca1 : pnp 00:01
       0ca4-0ca5 : pnp 00:01
       0cd4-0cd7 : pnp 00:01
    0cf8-0cff : PCI conf1
    0d00-0fff : PCI Bus 0000:00
       0f50-0f58 : pnp 00:01
    1000-5fff : PCI Bus 0000:00
       1000-101f : 0000:00:1d.0
       1020-103f : 0000:00:1d.1
       1040-105f : 0000:00:1d.2
       1060-107f : 0000:00:1d.3
       1080-1087 : 0000:00:1f.2
         1080-1087 : ata_piix
       1088-108b : 0000:00:1f.2
         1088-108b : ata_piix
       1090-1097 : 0000:00:1f.2
         1090-1097 : ata_piix
       1098-109b : 0000:00:1f.2
         1098-109b : ata_piix
       10a0-10af : 0000:00:1f.2
         10a0-10af : ata_piix
       10b0-10bf : 0000:00:1f.2
         10b0-10bf : ata_piix
       2000-3fff : PCI Bus 0000:01
         2800-28ff : 0000:01:04.0
         3000-30ff : 0000:01:03.0
         3400-34ff : 0000:01:04.2
           3400-34ff : hpilo
         3800-381f : 0000:01:04.4
       4000-4fff : PCI Bus 0000:04
         4000-40ff : 0000:04:00.0
           4000-40ff : hpsa
       5000-5fff : PCI Bus 0000:07
         5000-50ff : 0000:07:00.0
           5000-50ff : hpsa
     >> cat /proc/iomem
    00000000-0000ffff : reserved
    00010000-0009f3ff : System RAM
    0009f400-0009ffff : reserved
    000a0000-000bffff : PCI Bus 0000:00
    000c0000-000cafff : Video ROM
    000f0000-000fffff : reserved
       000f0000-000fffff : System ROM
    00100000-df61efff : System RAM
       01000000-01344304 : Kernel code
       01344305-014c5d7f : Kernel data
       01547000-015a9fff : Kernel bss
    df61f000-df62bfff : ACPI Tables
    df62c000-df62cfff : System RAM
    df62d000-e3ffffff : reserved
       e0000000-e3ffffff : pnp 00:01
    e7000000-fbffffff : PCI Bus 0000:00
       e7000000-e70fffff : PCI Bus 0000:04
         e7000000-e707ffff : 0000:04:00.0
       e7100000-e71fffff : PCI Bus 0000:0a
         e7100000-e710ffff : 0000:0a:00.0
       e7200000-e72fffff : PCI Bus 0000:07
         e7200000-e727ffff : 0000:07:00.0
       e7300000-e73fffff : PCI Bus 0000:02
         e7300000-e730ffff : 0000:02:00.0
         e7310000-e731ffff : 0000:02:00.1
       e8000000-efffffff : PCI Bus 0000:01
         e8000000-efffffff : 0000:01:03.0
       f1df0000-f1df03ff : 0000:00:1d.7
       f1e00000-f1ffffff : PCI Bus 0000:01
         f1e00000-f1e1ffff : 0000:01:03.0
         f1e20000-f1e2ffff : 0000:01:04.2
         f1ef0000-f1ef00ff : 0000:01:04.6
           f1ef0000-f1ef0001 : ipmi_si
         f1f00000-f1f7ffff : 0000:01:04.2
           f1f00000-f1f7ffff : hpilo
         f1fc0000-f1fc3fff : 0000:01:04.2
           f1fc0000-f1fc3fff : hpilo
         f1fd0000-f1fd07ff : 0000:01:04.2
           f1fd0000-f1fd07ff : hpilo
         f1fe0000-f1fe01ff : 0000:01:04.0
         f1ff0000-f1ffffff : 0000:01:03.0
       f2000000-f5ffffff : PCI Bus 0000:02
         f2000000-f3ffffff : 0000:02:00.1
           f2000000-f3ffffff : bnx2
         f4000000-f5ffffff : 0000:02:00.0
           f4000000-f5ffffff : bnx2
       f7900000-f7bfffff : PCI Bus 0000:04
         f79f0000-f79f0fff : 0000:04:00.0
           f79f0000-f79f0fff : hpsa
         f7a00000-f7bfffff : 0000:04:00.0
           f7a00000-f7bfffff : hpsa
       f7d00000-f7ffffff : PCI Bus 0000:07
         f7df0000-f7df0fff : 0000:07:00.0
           f7df0000-f7df0fff : hpsa
         f7e00000-f7ffffff : 0000:07:00.0
           f7e00000-f7ffffff : hpsa
       f8000000-fbffffff : PCI Bus 0000:0a
         f8000000-f9ffffff : 0000:0a:00.0
           f8000000-f9ffffff : iw_nes
         fbff0000-fbff0fff : 0000:0a:00.0
           fbff0000-fbff0fff : iw_nes
    fe000000-febfffff : pnp 00:01
    fec00000-fee0ffff : reserved
       fec00000-fec003ff : IOAPIC 0
       fec80000-fec803ff : IOAPIC 1
       fed00000-fed44fff : PCI Bus 0000:00
         fed00000-fed003ff : HPET 0
       fee00000-fee00fff : Local APIC
    ff800000-ffffffff : reserved
    100000000-61fffefff : System RAM
    61ffff000-61fffffff : RAM buffer

[7.5.] PCI information ('lspci -vvv' as root)

    00:00.0 Host bridge: Intel Corporation 5520 I/O Hub to ESI Port (rev 13)
             Subsystem: Hewlett-Packard Company Device 330b
             Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx-
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 128 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
    SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 2.5GT/s,
    EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

    00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
    Express Root Port 1 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
             I/O behind bridge: 00004000-00004fff
             Memory behind bridge: f7900000-f7bfffff
             Prefetchable memory behind bridge:
    00000000e7000000-00000000e70fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 5GT/s, Width x4, TrErr- Train-
    SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:02.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
    Express Root Port 2 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
             I/O behind bridge: 0000f000-00000fff
             Memory behind bridge: fff00000-000fffff
             Prefetchable memory behind bridge:
    00000000fff00000-00000000000fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 5GT/s, Width x0, TrErr- Train-
    SlotClk+ DLActive- BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 2.5GT/s,
    EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
    Express Root Port 3 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=10, subordinate=12, sec-latency=0
             I/O behind bridge: 0000f000-00000fff
             Memory behind bridge: fff00000-000fffff
             Prefetchable memory behind bridge:
    00000000fff00000-00000000000fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
    SlotClk+ DLActive- BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 2.5GT/s,
    EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:04.0 PCI bridge: Intel Corporation 5520/X58 I/O Hub PCI Express
    Root Port 4 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=13, subordinate=13, sec-latency=0
             I/O behind bridge: 0000f000-00000fff
             Memory behind bridge: fff00000-000fffff
             Prefetchable memory behind bridge:
    00000000fff00000-00000000000fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
    SlotClk+ DLActive- BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 2.5GT/s,
    EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:05.0 PCI bridge: Intel Corporation 5520/X58 I/O Hub PCI Express
    Root Port 5 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=14, subordinate=16, sec-latency=0
             I/O behind bridge: 0000f000-00000fff
             Memory behind bridge: fff00000-000fffff
             Prefetchable memory behind bridge:
    00000000fff00000-00000000000fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
    SlotClk+ DLActive- BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 2.5GT/s,
    EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:06.0 PCI bridge: Intel Corporation 5520/X58 I/O Hub PCI Express
    Root Port 6 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=17, subordinate=19, sec-latency=0
             I/O behind bridge: 0000f000-00000fff
             Memory behind bridge: fff00000-000fffff
             Prefetchable memory behind bridge:
    00000000fff00000-00000000000fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
    SlotClk+ DLActive- BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 2.5GT/s,
    EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
    Express Root Port 7 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=0d, subordinate=0f, sec-latency=0
             I/O behind bridge: 0000f000-00000fff
             Memory behind bridge: fff00000-000fffff
             Prefetchable memory behind bridge:
    00000000fff00000-00000000000fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
    SlotClk+ DLActive- BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 2.5GT/s,
    EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:08.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
    Express Root Port 8 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=0a, subordinate=0c, sec-latency=0
             I/O behind bridge: 0000f000-00000fff
             Memory behind bridge: f8000000-fbffffff
             Prefetchable memory behind bridge:
    00000000e7100000-00000000e71fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
    SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 2.5GT/s,
    EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:09.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
    Express Root Port 9 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=07, subordinate=09, sec-latency=0
             I/O behind bridge: 00005000-00005fff
             Memory behind bridge: f7d00000-f7ffffff
             Prefetchable memory behind bridge:
    00000000e7200000-00000000e72fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 5GT/s, Width x8, TrErr- Train-
    SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:0a.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
    Express Root Port 10 (rev 13) (prog-if 00 [Normal decode])
             Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx+
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Latency: 0, Cache Line Size: 64 bytes
             Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
             I/O behind bridge: 0000f000-00000fff
             Memory behind bridge: fff00000-000fffff
             Prefetchable memory behind bridge:
    00000000fff00000-00000000000fffff
             Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- <SERR- <PERR-
             BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
                     PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
             Capabilities: [40] Subsystem: Hewlett-Packard Company
    Device 330b
             Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
                     Address: 00000000  Data: 0000
                     Masking: 00000000  Pending: 00000000
             Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
                     DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag+ RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal+
    Fatal+ Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 256 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s
    L1, Latency L0 <512ns, L1 <4us
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
    Retrain- CommClk-
                             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                     LnkSta: Speed 5GT/s, Width x0, TrErr- Train-
    SlotClk+ DLActive- BWMgmt- ABWMgmt-
                     RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+
    PMEIntEna- CRSVisible-
                     RootCap: CRSVisible-
                     RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                     DevCap2: Completion Timeout: Range BCD, TimeoutDis+
    ARIFwd+
                     DevCtl2: Completion Timeout: 260ms to 900ms,
    TimeoutDis- ARIFwd-
                     LnkCtl2: Target Link Speed: 2.5GT/s,
    EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
                              Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                              Compliance De-emphasis: -6dB
                     LnkSta2: Current De-emphasis Level: -6dB
             Capabilities: [e0] Power Management version 3
                     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
                     Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
             Kernel driver in use: pcieport

    00:0d.0 Host bridge: Intel Corporation Device 343a (rev 13)
             Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
             Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
             Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
                     DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
    L0s <64ns, L1 <1us
                             ExtTag- RBE+ FLReset-
                     DevCtl: Report errors: Correctable- Non-Fatal-
    Fatal- Unsupported-
                             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                             MaxPayload 128 bytes, MaxReadReq 128 bytes
                     DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
    AuxPwr- TransPend-
                     LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                             ClockPM- Surprise+ LLActRep+ BwNot+
                     LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0d.1 Host bridge: Intel Corporation Device 343b (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0d.2 Host bridge: Intel Corporation Device 343c (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0d.3 Host bridge: Intel Corporation Device 343d (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0d.4 Host bridge: Intel Corporation 5520/5500/X58 Physical Layer
    Port 0 (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0d.5 Host bridge: Intel Corporation 5520/5500 Physical Layer Port
    1 (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0d.6 Host bridge: Intel Corporation Device 341a (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0e.0 Host bridge: Intel Corporation Device 341c (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0e.1 Host bridge: Intel Corporation Device 341d (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0e.2 Host bridge: Intel Corporation Device 341e (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0e.3 Host bridge: Intel Corporation Device 341f (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range BCD, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [60] #00 [0000]

    00:0e.4 Host bridge: Intel Corporation Device 3439 (rev 13)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Not Supported, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB

    00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System
    Management Registers (rev 13) (prog-if 00 [8259])
         Subsystem: Device 003c:000b
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Not Supported, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB

    00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and
    Scratch Pad Registers (rev 13) (prog-if 00 [8259])
         Subsystem: Device 003c:000b
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Not Supported, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB

    00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
    and RAS Registers (rev 13) (prog-if 00 [8259])
         Subsystem: Device 003c:000b
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Capabilities: [40] Express (v2) Root Complex Integrated
    Endpoint, MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed unknown, Width x0, ASPM L0s,
    Latency L0 unlimited, L1 unlimited
                 ClockPM- Surprise+ LLActRep+ BwNot+
             LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Not Supported, TimeoutDis-
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB

    00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
    Express Root Port 1 (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: f2000000-f5ffffff
         Prefetchable memory behind bridge:
    00000000e7300000-00000000e73fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
             PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal+ Fatal+
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
    TransPend-
             LnkCap:    Port #1, Speed 2.5GT/s, Width x2, ASPM L0s L1,
    Latency L0 <1us, L1 <4us
                 ClockPM- Surprise- LLActRep+ BwNot-
             LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain-
    CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed 2.5GT/s, Width x2, TrErr- Train- SlotClk+
    DLActive+ BWMgmt- ABWMgmt-
             RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna-
    CRSVisible-
             RootCap: CRSVisible-
             RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
             Address: 00000000  Data: 0000
         Capabilities: [90] Subsystem: Hewlett-Packard Company Device 330d
         Capabilities: [a0] Power Management version 2
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
             Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport

    00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
    Express Root Port 3 (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: fff00000-000fffff
         Prefetchable memory behind bridge:
    00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
             PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
             DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
    <64ns, L1 <1us
                 ExtTag- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal+ Fatal+
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 128 bytes, MaxReadReq 128 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
    TransPend-
             LnkCap:    Port #3, Speed 2.5GT/s, Width x2, ASPM L0s L1,
    Latency L0 <1us, L1 <4us
                 ClockPM- Surprise- LLActRep+ BwNot-
             LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled+ Retrain-
    CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed 2.5GT/s, Width x2, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna-
    CRSVisible-
             RootCap: CRSVisible-
             RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
             Address: 00000000  Data: 0000
         Capabilities: [90] Subsystem: Hewlett-Packard Company Device 330d
         Capabilities: [a0] Power Management version 2
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
             Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport

    00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
    UHCI Controller #1 (prog-if 00 [UHCI])
         Subsystem: Hewlett-Packard Company Device 330d
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 5
         Region 4: I/O ports at 1000 [size=32]
         Capabilities: [50] PCI Advanced Features
             AFCap: TP+ FLR+
             AFCtrl: FLR-
             AFStatus: TP-

    00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
    UHCI Controller #2 (prog-if 00 [UHCI])
         Subsystem: Hewlett-Packard Company Device 330d
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin B routed to IRQ 7
         Region 4: I/O ports at 1020 [size=32]
         Capabilities: [50] PCI Advanced Features
             AFCap: TP+ FLR+
             AFCtrl: FLR-
             AFStatus: TP-

    00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
    UHCI Controller #3 (prog-if 00 [UHCI])
         Subsystem: Hewlett-Packard Company Device 330d
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin C routed to IRQ 10
         Region 4: I/O ports at 1040 [size=32]
         Capabilities: [50] PCI Advanced Features
             AFCap: TP+ FLR+
             AFCtrl: FLR-
             AFStatus: TP-

    00:1d.3 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
    UHCI Controller #6 (prog-if 00 [UHCI])
         Subsystem: Hewlett-Packard Company Device 330d
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin D routed to IRQ 7
         Region 4: I/O ports at 1060 [size=32]
         Capabilities: [50] PCI Advanced Features
             AFCap: TP+ FLR+
             AFCtrl: FLR-
             AFStatus: TP-

    00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family)
    USB2 EHCI Controller #1 (prog-if 20 [EHCI])
         Subsystem: Hewlett-Packard Company Device 330d
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 5
         Region 0: Memory at f1df0000 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
             Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Capabilities: [98] PCI Advanced Features
             AFCap: TP+ FLR+
             AFCtrl: FLR-
             AFStatus: TP-

    00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
    (prog-if 01 [Subtractive decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
         I/O behind bridge: 00002000-00003fff
         Memory behind bridge: f1e00000-f1ffffff
         Prefetchable memory behind bridge:
    00000000e8000000-00000000efffffff
         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
             PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] Subsystem: Hewlett-Packard Company Device 330d

    00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface
    Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information: Len=0c <?>

    00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4
    port SATA IDE Controller #1 (prog-if 8f [Master SecP SecO PriP PriO])
         Subsystem: Hewlett-Packard Company Device 330d
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin B routed to IRQ 17
         Region 0: I/O ports at 1080 [size=8]
         Region 1: I/O ports at 1088 [size=4]
         Region 2: I/O ports at 1090 [size=8]
         Region 3: I/O ports at 1098 [size=4]
         Region 4: I/O ports at 10a0 [size=16]
         Region 5: I/O ports at 10b0 [size=16]
         Capabilities: [70] Power Management version 3
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0-,D1-,D2-,D3hot-,D3cold-)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [b0] PCI Advanced Features
             AFCap: TP+ FLR+
             AFCtrl: FLR-
             AFStatus: TP-
         Kernel driver in use: ata_piix

    01:03.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev
    02) (prog-if 00 [VGA controller])
         Subsystem: Hewlett-Packard Company Device 31fb
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping+ SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64 (2000ns min), Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 7
         Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
         Region 1: I/O ports at 3000 [size=256]
         Region 2: Memory at f1ff0000 (32-bit, non-prefetchable) [size=64K]
         [virtual] Expansion ROM at f1e00000 [disabled] [size=128K]
         Capabilities: [50] Power Management version 2
             Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
    PME(D0-,D1-,D2-,D3hot-,D3cold-)
             Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

    01:04.0 System peripheral: Compaq Computer Corporation Integrated
    Lights Out Controller (rev 03)
         Subsystem: Hewlett-Packard Company Device 3305
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin A routed to IRQ 10
         Region 0: I/O ports at 2800 [size=256]
         Region 1: Memory at f1fe0000 (32-bit, non-prefetchable) [size=512]
         Capabilities: [f0] Power Management version 3
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

    01:04.2 System peripheral: Compaq Computer Corporation Integrated
    Lights Out  Processor (rev 03)
         Subsystem: Hewlett-Packard Company Device 3305
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
    ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64, Cache Line Size: 64 bytes
         Interrupt: pin B routed to IRQ 22
         BIST result: 00
         Region 0: I/O ports at 3400 [size=256]
         Region 1: Memory at f1fd0000 (32-bit, non-prefetchable) [size=2K]
         Region 2: Memory at f1fc0000 (32-bit, non-prefetchable) [size=16K]
         Region 3: Memory at f1f00000 (32-bit, non-prefetchable) [size=512K]
         [virtual] Expansion ROM at f1e20000 [disabled] [size=64K]
         Capabilities: [f0] Power Management version 3
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: hpilo

    01:04.4 USB Controller: Hewlett-Packard Company Proliant iLO2/iLO3
    virtual USB controller (prog-if 00 [UHCI])
         Subsystem: Hewlett-Packard Company Device 3305
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64
         Interrupt: pin B routed to IRQ 10
         Region 4: I/O ports at 3800 [size=32]
         Capabilities: [f0] Power Management version 3
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

    01:04.6 IPMI SMIC interface: Hewlett-Packard Company Proliant iLO2
    virtual UART (prog-if 01)
         Subsystem: Hewlett-Packard Company Device 3305
         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
    ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
     >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin A routed to IRQ 21
         Region 0: Memory at f1ef0000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [f0] Power Management version 3
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: ipmi_si

    02:00.0 Ethernet controller: Broadcom Corporation NetXtreme II
    BCM5709 Gigabit Ethernet (rev 20)
         Subsystem: Hewlett-Packard Company NC382i Integrated Quad Port
    PCI Express Gigabit Server Adapter
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at f4000000 (64-bit, non-prefetchable) [size=32M]
         [virtual] Expansion ROM at e7300000 [disabled] [size=64K]
         Capabilities: [48] Power Management version 3
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [50] Vital Product Data
             Product Name: HP NC382i Multifunction Gigabit Server Adapter
             Read-only fields:
                 [PN] Part number: N/A
                 [EC] Engineering changes: N/A
                 [SN] Serial number: 0123456789
                 [MN] Manufacture ID: 31 30 33 43
                 [RV] Reserved: checksum good, 37 byte(s) reserved
             End
         Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
             Address: 0000000000000000  Data: 0000
         Capabilities: [a0] MSI-X: Enable+ Count=9 Masked-
             Vector table: BAR=0 offset=0000c000
             PBA: BAR=0 offset=0000e000
         Capabilities: [ac] Express (v2) Endpoint, MSI 00
             DevCap:    MaxPayload 512 bytes, PhantFunc 0, Latency L0s
    <4us, L1 <64us
                 ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal+ Fatal+
    Unsupported-
                 RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
                 MaxPayload 128 bytes, MaxReadReq 4096 bytes
             DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
    TransPend-
             LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1,
    Latency L0 <4us, L1 <4us
                 ClockPM- Surprise- LLActRep- BwNot-
             LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain-
    CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed 2.5GT/s, Width x2, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Kernel driver in use: bnx2

    02:00.1 Ethernet controller: Broadcom Corporation NetXtreme II
    BCM5709 Gigabit Ethernet (rev 20)
         Subsystem: Hewlett-Packard Company NC382i Integrated Quad Port
    PCI Express Gigabit Server Adapter
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin B routed to IRQ 17
         Region 0: Memory at f2000000 (64-bit, non-prefetchable) [size=32M]
         [virtual] Expansion ROM at e7310000 [disabled] [size=64K]
         Capabilities: [48] Power Management version 3
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
    PME(D0+,D1-,D2-,D3hot+,D3cold+)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [50] Vital Product Data
             Product Name: HP NC382i Multifunction Gigabit Server Adapter
             Read-only fields:
                 [PN] Part number: N/A
                 [EC] Engineering changes: N/A
                 [SN] Serial number: 0123456789
                 [MN] Manufacture ID: 31 30 33 43
                 [RV] Reserved: checksum good, 37 byte(s) reserved
             End
         Capabilities: [58] MSI: Enable- Count=1/16 Maskable- 64bit+
             Address: 0000000000000000  Data: 0000
         Capabilities: [a0] MSI-X: Enable+ Count=9 Masked-
             Vector table: BAR=0 offset=0000c000
             PBA: BAR=0 offset=0000e000
         Capabilities: [ac] Express (v2) Endpoint, MSI 00
             DevCap:    MaxPayload 512 bytes, PhantFunc 0, Latency L0s
    <4us, L1 <64us
                 ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal+ Fatal+
    Unsupported-
                 RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
                 MaxPayload 128 bytes, MaxReadReq 4096 bytes
             DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
    TransPend-
             LnkCap:    Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1,
    Latency L0 <4us, L1 <4us
                 ClockPM- Surprise- LLActRep- BwNot-
             LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain-
    CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed 2.5GT/s, Width x2, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Kernel driver in use: bnx2

    04:00.0 RAID bus controller: Hewlett-Packard Company Smart Array G6
    controllers (rev 01)
         Subsystem: Hewlett-Packard Company Smart Array P410i
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 28
         Region 0: Memory at f7a00000 (64-bit, non-prefetchable) [size=2M]
         Region 2: Memory at f79f0000 (64-bit, non-prefetchable) [size=4K]
         Region 4: I/O ports at 4000 [size=256]
         [virtual] Expansion ROM at e7000000 [disabled] [size=512K]
         Capabilities: [40] Power Management version 3
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
    PME(D0+,D1-,D2-,D3hot-,D3cold-)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
             Address: 0000000000000000  Data: 0000
         Capabilities: [70] Express (v2) Endpoint, MSI 00
             DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s
    <1us, L1 <8us
                 ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal+ Fatal+
    Unsupported-
                 RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                 MaxPayload 256 bytes, MaxReadReq 4096 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed 5GT/s, Width x8, ASPM unknown,
    Latency L0 <512ns, L1 <64us
                 ClockPM- Surprise- LLActRep- BwNot-
             LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain-
    CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed 5GT/s, Width x4, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Not Supported, TimeoutDis+
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [ac] MSI-X: Enable+ Count=16 Masked-
             Vector table: BAR=0 offset=001c2000
             PBA: BAR=0 offset=001c4000
         Kernel driver in use: hpsa

    07:00.0 RAID bus controller: Hewlett-Packard Company Smart Array G6
    controllers (rev 01)
         Subsystem: Hewlett-Packard Company Smart Array P812
         Physical Slot: 1
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 32
         Region 0: Memory at f7e00000 (64-bit, non-prefetchable) [size=2M]
         Region 2: Memory at f7df0000 (64-bit, non-prefetchable) [size=4K]
         Region 4: I/O ports at 5000 [size=256]
         [virtual] Expansion ROM at e7200000 [disabled] [size=512K]
         Capabilities: [40] Power Management version 3
             Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
    PME(D0+,D1-,D2-,D3hot-,D3cold-)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
             Address: 0000000000000000  Data: 0000
         Capabilities: [70] Express (v2) Endpoint, MSI 00
             DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s
    <1us, L1 <8us
                 ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal+ Fatal+
    Unsupported-
                 RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                 MaxPayload 256 bytes, MaxReadReq 4096 bytes
             DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed 5GT/s, Width x8, ASPM unknown,
    Latency L0 <512ns, L1 <64us
                 ClockPM- Surprise- LLActRep- BwNot-
             LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain-
    CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
             DevCap2: Completion Timeout: Not Supported, TimeoutDis+
             DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
             LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
    SpeedDis-, Selectable De-emphasis: -6dB
                  Transmit Margin: Normal Operating Range,
    EnterModifiedCompliance- ComplianceSOS-
                  Compliance De-emphasis: -6dB
             LnkSta2: Current De-emphasis Level: -6dB
         Capabilities: [ac] MSI-X: Enable+ Count=16 Masked-
             Vector table: BAR=0 offset=001c2000
             PBA: BAR=0 offset=001c4000
         Kernel driver in use: hpsa

    0a:00.0 Ethernet controller: NetEffect NE020 10Gb Accelerated
    Ethernet Adapter (iWARP RNIC) (rev 05)
         Subsystem: NetEffect NE020 10Gb Accelerated Ethernet Adapter
    (iWARP RNIC)
         Physical Slot: 2
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
    ParErr+ Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
    <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 31
         Region 0: Memory at fbff0000 (64-bit, non-prefetchable) [size=4K]
         Region 2: Memory at f8000000 (64-bit, non-prefetchable) [size=32M]
         [virtual] Expansion ROM at e7100000 [disabled] [size=64K]
         Capabilities: [40] Power Management version 3
             Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
    PME(D0-,D1-,D2-,D3hot-,D3cold-)
             Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
             Address: 0000000000000000  Data: 0000
         Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
             DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s
    <4us, L1 <32us
                 ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
             DevCtl:    Report errors: Correctable- Non-Fatal+ Fatal+
    Unsupported-
                 RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 MaxPayload 256 bytes, MaxReadReq 4096 bytes
             DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
    TransPend-
             LnkCap:    Port #0, Speed 2.5GT/s, Width x8, ASPM L0s,
    Latency L0 <1us, L1 <2us
                 ClockPM- Surprise- LLActRep- BwNot-
             LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain-
    CommClk-
                 ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
             LnkSta:    Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+
    DLActive- BWMgmt- ABWMgmt-
         Kernel driver in use: iw_nes

[7.6.] SCSI information (from /proc/scsi/scsi)
Not existing?!?

[7.7.] Other information that might be relevant to the problem (please 
look in /proc and include all information that you think to be relevant):

