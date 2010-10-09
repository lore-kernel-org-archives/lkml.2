Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab0JIEat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 00:30:49 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:37646 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750756Ab0JIEaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 00:30:46 -0400
Message-ID: <4CAFEFF1.8010202@example.com>
Date: Sat, 09 Oct 2010 06:30:41 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: What is this? Should I worry?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17290163396550684952
X-Ovh-Remote: 83.24.80.30 (dmy30.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# uname -a
Linux aapi205 2.6.36-rc7-git1 #1 SMP PREEMPT Fri Oct 8 10:49:47 CEST 
2010 x86_64 GNU/Linux

This is what I have in syslog:

Oct  9 03:09:34 aapi205 kernel: [57001.468028] INFO: rcu_bh_state 
detected stall on CPU 1 (t=0 jiffies)
Oct  9 03:09:34 aapi205 kernel: [57001.468035] sending NMI to all CPUs:
Oct  9 03:09:34 aapi205 kernel: [57001.468050] NMI backtrace for cpu 3
Oct  9 03:09:34 aapi205 kernel: [57001.468053] CPU 3
Oct  9 03:09:34 aapi205 kernel: [57001.468055] Modules linked in: 
nvidia(P) binfmt_misc sco bnep rfcomm l2cap bluetooth rfkill ppdev lp 
fuse ext3 jbd coretemp it87 hwmon_vid sbp2 loop snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device snd parport_pc soundcore i2c_i801 
shpchp parport evdev pci_hotplug pcspkr snd_page_alloc psmouse serio_raw 
i2c_core button intel_agp processor ext4 mbcache jbd2 crc16 sg sd_mod 
sr_mod cdrom ata_piix ata_generic ahci libahci ide_pci_generic libata 
ohci1394 ieee1394 jmicron thermal ide_core floppy scsi_mod uhci_hcd 
r8169 mii thermal_sys ehci_hcd [last unloaded: nvidia]
Oct  9 03:09:34 aapi205 kernel: [57001.468114]
Oct  9 03:09:34 aapi205 kernel: [57001.468117] Pid: 0, comm: kworker/0:1 
Tainted: P        W   2.6.36-rc7-git1 #1 EP45-UD3/EP45-UD3
Oct  9 03:09:34 aapi205 kernel: [57001.468119] RIP: 
0010:[<ffffffff81023948>]  [<ffffffff81023948>] native_safe_halt+0x6/0x8
Oct  9 03:09:34 aapi205 kernel: [57001.468127] RSP: 
0018:ffff88012f725e38  EFLAGS: 00000246
Oct  9 03:09:34 aapi205 kernel: [57001.468129] RAX: 0000000000000000 
RBX: ffff88012f090468 RCX: 0000000032101a16
Oct  9 03:09:34 aapi205 kernel: [57001.468131] RDX: 000000004cafc0ce 
RSI: 0000000225c17d03 RDI: ffff88012f090468
Oct  9 03:09:34 aapi205 kernel: [57001.468134] RBP: ffff88012f725e38 
R08: 000000000000e980 R09: 0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468136] R10: ffff88012f725e48 
R11: 00000003810396ac R12: ffff88012f090000
Oct  9 03:09:34 aapi205 kernel: [57001.468138] R13: 11dadfac561ea616 
R14: 0000000000000000 R15: 0000000000000003
Oct  9 03:09:34 aapi205 kernel: [57001.468141] FS: 
0000000000000000(0000) GS:ffff880001b80000(0000) knlGS:0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468144] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Oct  9 03:09:34 aapi205 kernel: [57001.468146] CR2: 00007fb6a5b91628 
CR3: 000000012c9fd000 CR4: 00000000000006e0
Oct  9 03:09:34 aapi205 kernel: [57001.468148] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468151] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  9 03:09:34 aapi205 kernel: [57001.468153] Process kworker/0:1 (pid: 
0, threadinfo ffff88012f724000, task ffff88012f707000)
Oct  9 03:09:34 aapi205 kernel: [57001.468155] Stack:
Oct  9 03:09:34 aapi205 kernel: [57001.468157]  ffff88012f725e48 
ffffffffa00f4f76 ffff88012f725e98 ffffffffa00f5012
Oct  9 03:09:34 aapi205 kernel: [57001.468161] <0> 0000000000000400 
ffff88012f090020 ffff88012f725e98 ffffffff81274dc3
Oct  9 03:09:34 aapi205 kernel: [57001.468164] <0> ffff88012f090020 
ffff88012f090020 ffff88012f090090 ffffffff816b9c78
Oct  9 03:09:34 aapi205 kernel: [57001.468169] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.468177]  [<ffffffffa00f4f76>] 
acpi_idle_do_entry+0x39/0x62 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468182]  [<ffffffffa00f5012>] 
acpi_idle_enter_c1+0x73/0xc2 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81274dc3>] ? 
menu_select+0x17c/0x2ac
Oct  9 03:09:34 aapi205 kernel: [57001.468191]  [<ffffffff81273ecf>] 
cpuidle_idle_call+0xae/0x127
Oct  9 03:09:34 aapi205 kernel: [57001.468194]  [<ffffffff81001c57>] 
cpu_idle+0xb2/0x148
Oct  9 03:09:34 aapi205 kernel: [57001.468198]  [<ffffffff8130ba26>] 
start_secondary+0x25b/0x2a1
Oct  9 03:09:34 aapi205 kernel: [57001.468201] Code: ff ff c9 c3 90 90 
90 55 48 89 e5 9c 58 c9 c3 55 48 89 e5 57 9d c9 c3 55 48 89 e5 fa c9 c3 
55 48 89 e5 fb c9 c3 55 48 89 e5 fb f4 <c9> c3 55 48 89 e5 f4 c9 c3 55 
48 89 e5 0f 06 c9 c3 55 48 89 e5
Oct  9 03:09:34 aapi205 kernel: [57001.468237] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.468242]  [<ffffffffa00f4f76>] 
acpi_idle_do_entry+0x39/0x62 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468247]  [<ffffffffa00f5012>] 
acpi_idle_enter_c1+0x73/0xc2 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468250]  [<ffffffff81274dc3>] ? 
menu_select+0x17c/0x2ac
Oct  9 03:09:34 aapi205 kernel: [57001.468254]  [<ffffffff81273ecf>] 
cpuidle_idle_call+0xae/0x127
Oct  9 03:09:34 aapi205 kernel: [57001.468257]  [<ffffffff81001c57>] 
cpu_idle+0xb2/0x148
Oct  9 03:09:34 aapi205 kernel: [57001.468260]  [<ffffffff8130ba26>] 
start_secondary+0x25b/0x2a1
Oct  9 03:09:34 aapi205 kernel: [57001.468263] Pid: 0, comm: kworker/0:1 
Tainted: P        W   2.6.36-rc7-git1 #1
Oct  9 03:09:34 aapi205 kernel: [57001.468265] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.468267]  <NMI> 
[<ffffffff8100aba8>] ? show_regs+0x26/0x2b
Oct  9 03:09:34 aapi205 kernel: [57001.468273]  [<ffffffff8101c9f0>] 
nmi_watchdog_tick+0xaa/0x19a
Oct  9 03:09:34 aapi205 kernel: [57001.468276]  [<ffffffff810048ea>] 
do_nmi+0xdb/0x291
Oct  9 03:09:34 aapi205 kernel: [57001.468280]  [<ffffffff81313ba0>] 
nmi+0x20/0x30
Oct  9 03:09:34 aapi205 kernel: [57001.468283]  [<ffffffff81023948>] ? 
native_safe_halt+0x6/0x8
Oct  9 03:09:34 aapi205 kernel: [57001.468285]  <<EOE>> 
[<ffffffffa00f4f76>] acpi_idle_do_entry+0x39/0x62 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468294]  [<ffffffffa00f5012>] 
acpi_idle_enter_c1+0x73/0xc2 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468297]  [<ffffffff81274dc3>] ? 
menu_select+0x17c/0x2ac
Oct  9 03:09:34 aapi205 kernel: [57001.468301]  [<ffffffff81273ecf>] 
cpuidle_idle_call+0xae/0x127
Oct  9 03:09:34 aapi205 kernel: [57001.468304]  [<ffffffff81001c57>] 
cpu_idle+0xb2/0x148
Oct  9 03:09:34 aapi205 kernel: [57001.468307]  [<ffffffff8130ba26>] 
start_secondary+0x25b/0x2a1
Oct  9 03:09:34 aapi205 kernel: [57001.468316] NMI backtrace for cpu 0
Oct  9 03:09:34 aapi205 kernel: [57001.468318] CPU 0
Oct  9 03:09:34 aapi205 kernel: [57001.468320] Modules linked in: 
nvidia(P) binfmt_misc sco bnep rfcomm l2cap bluetooth rfkill ppdev lp 
fuse ext3 jbd coretemp it87 hwmon_vid sbp2 loop snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device snd parport_pc soundcore i2c_i801 
shpchp parport evdev pci_hotplug pcspkr snd_page_alloc psmouse serio_raw 
i2c_core button intel_agp processor ext4 mbcache jbd2 crc16 sg sd_mod 
sr_mod cdrom ata_piix ata_generic ahci libahci ide_pci_generic libata 
ohci1394 ieee1394 jmicron thermal ide_core floppy scsi_mod uhci_hcd 
r8169 mii thermal_sys ehci_hcd [last unloaded: nvidia]
Oct  9 03:09:34 aapi205 kernel: [57001.468368]
Oct  9 03:09:34 aapi205 kernel: [57001.468370] Pid: 0, comm: swapper 
Tainted: P        W   2.6.36-rc7-git1 #1 EP45-UD3/EP45-UD3
Oct  9 03:09:34 aapi205 kernel: [57001.468372] RIP: 
0010:[<ffffffff81023948>]  [<ffffffff81023948>] native_safe_halt+0x6/0x8
Oct  9 03:09:34 aapi205 kernel: [57001.468377] RSP: 
0018:ffffffff81601e38  EFLAGS: 00000246
Oct  9 03:09:34 aapi205 kernel: [57001.468380] RAX: 0000000000000000 
RBX: ffff88012d4ddc68 RCX: 00000000323bd4d3
Oct  9 03:09:34 aapi205 kernel: [57001.468382] RDX: 000000004cafc0ce 
RSI: 0000000225c17d03 RDI: ffff88012d4ddc68
Oct  9 03:09:34 aapi205 kernel: [57001.468384] RBP: ffffffff81601e38 
R08: 0000000000000f86 R09: 0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468387] R10: ffff88012d4dd800 
R11: ffffffff810396ac R12: ffff88012d4dd800
Oct  9 03:09:34 aapi205 kernel: [57001.468389] R13: 11dadfac564a60d3 
R14: ffffffffffffffff R15: 0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468392] FS: 
0000000000000000(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468394] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Oct  9 03:09:34 aapi205 kernel: [57001.468396] CR2: 00007fb6ab1d1000 
CR3: 00000001088bd000 CR4: 00000000000006f0
Oct  9 03:09:34 aapi205 kernel: [57001.468399] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468401] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  9 03:09:34 aapi205 kernel: [57001.468404] Process swapper (pid: 0, 
threadinfo ffffffff81600000, task ffffffff81629020)
Oct  9 03:09:34 aapi205 kernel: [57001.468405] Stack:
Oct  9 03:09:34 aapi205 kernel: [57001.468407]  ffffffff81601e48 
ffffffffa00f4f76 ffffffff81601e98 ffffffffa00f5012
Oct  9 03:09:34 aapi205 kernel: [57001.468410] <0> 0000000000000000 
ffff88012d4dd820 ffffffff81601e98 ffffffff81274dc3
Oct  9 03:09:34 aapi205 kernel: [57001.468414] <0> ffff88012d4dd820 
ffff88012d4dd820 ffff88012d4dd890 ffffffff816b9c78
Oct  9 03:09:34 aapi205 kernel: [57001.468418] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.468424]  [<ffffffffa00f4f76>] 
acpi_idle_do_entry+0x39/0x62 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468429]  [<ffffffffa00f5012>] 
acpi_idle_enter_c1+0x73/0xc2 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468433]  [<ffffffff81274dc3>] ? 
menu_select+0x17c/0x2ac
Oct  9 03:09:34 aapi205 kernel: [57001.468436]  [<ffffffff81273ecf>] 
cpuidle_idle_call+0xae/0x127
Oct  9 03:09:34 aapi205 kernel: [57001.468440]  [<ffffffff81001c57>] 
cpu_idle+0xb2/0x148
Oct  9 03:09:34 aapi205 kernel: [57001.468443]  [<ffffffff812fc4be>] 
rest_init+0x92/0x96
Oct  9 03:09:34 aapi205 kernel: [57001.468447]  [<ffffffff816d3d62>] 
start_kernel+0x3d6/0x3e1
Oct  9 03:09:34 aapi205 kernel: [57001.468451]  [<ffffffff816d32ac>] 
x86_64_start_reservations+0xb3/0xb7
Oct  9 03:09:34 aapi205 kernel: [57001.468454]  [<ffffffff816d33ab>] 
x86_64_start_kernel+0xfb/0x10a
Oct  9 03:09:34 aapi205 kernel: [57001.468456] Code: ff ff c9 c3 90 90 
90 55 48 89 e5 9c 58 c9 c3 55 48 89 e5 57 9d c9 c3 55 48 89 e5 fa c9 c3 
55 48 89 e5 fb c9 c3 55 48 89 e5 fb f4 <c9> c3 55 48 89 e5 f4 c9 c3 55 
48 89 e5 0f 06 c9 c3 55 48 89 e5
Oct  9 03:09:34 aapi205 kernel: [57001.468492] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.468497]  [<ffffffffa00f4f76>] 
acpi_idle_do_entry+0x39/0x62 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468502]  [<ffffffffa00f5012>] 
acpi_idle_enter_c1+0x73/0xc2 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468505]  [<ffffffff81274dc3>] ? 
menu_select+0x17c/0x2ac
Oct  9 03:09:34 aapi205 kernel: [57001.468509]  [<ffffffff81273ecf>] 
cpuidle_idle_call+0xae/0x127
Oct  9 03:09:34 aapi205 kernel: [57001.468512]  [<ffffffff81001c57>] 
cpu_idle+0xb2/0x148
Oct  9 03:09:34 aapi205 kernel: [57001.468515]  [<ffffffff812fc4be>] 
rest_init+0x92/0x96
Oct  9 03:09:34 aapi205 kernel: [57001.468518]  [<ffffffff816d3d62>] 
start_kernel+0x3d6/0x3e1
Oct  9 03:09:34 aapi205 kernel: [57001.468521]  [<ffffffff816d32ac>] 
x86_64_start_reservations+0xb3/0xb7
Oct  9 03:09:34 aapi205 kernel: [57001.468524]  [<ffffffff816d33ab>] 
x86_64_start_kernel+0xfb/0x10a
Oct  9 03:09:34 aapi205 kernel: [57001.468527] Pid: 0, comm: swapper 
Tainted: P        W   2.6.36-rc7-git1 #1
Oct  9 03:09:34 aapi205 kernel: [57001.468529] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.468531]  <NMI> 
[<ffffffff8100aba8>] ? show_regs+0x26/0x2b
Oct  9 03:09:34 aapi205 kernel: [57001.468536]  [<ffffffff8101c9f0>] 
nmi_watchdog_tick+0xaa/0x19a
Oct  9 03:09:34 aapi205 kernel: [57001.468539]  [<ffffffff810048ea>] 
do_nmi+0xdb/0x291
Oct  9 03:09:34 aapi205 kernel: [57001.468542]  [<ffffffff81313ba0>] 
nmi+0x20/0x30
Oct  9 03:09:34 aapi205 kernel: [57001.468546]  [<ffffffff810396ac>] ? 
dequeue_task+0x75/0x85
Oct  9 03:09:34 aapi205 kernel: [57001.468549]  [<ffffffff81023948>] ? 
native_safe_halt+0x6/0x8
Oct  9 03:09:34 aapi205 kernel: [57001.468551]  <<EOE>> 
[<ffffffffa00f4f76>] acpi_idle_do_entry+0x39/0x62 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468560]  [<ffffffffa00f5012>] 
acpi_idle_enter_c1+0x73/0xc2 [processor]
Oct  9 03:09:34 aapi205 kernel: [57001.468563]  [<ffffffff81274dc3>] ? 
menu_select+0x17c/0x2ac
Oct  9 03:09:34 aapi205 kernel: [57001.468567]  [<ffffffff81273ecf>] 
cpuidle_idle_call+0xae/0x127
Oct  9 03:09:34 aapi205 kernel: [57001.468570]  [<ffffffff81001c57>] 
cpu_idle+0xb2/0x148
Oct  9 03:09:34 aapi205 kernel: [57001.468573]  [<ffffffff812fc4be>] 
rest_init+0x92/0x96
Oct  9 03:09:34 aapi205 kernel: [57001.468576]  [<ffffffff816d3d62>] 
start_kernel+0x3d6/0x3e1
Oct  9 03:09:34 aapi205 kernel: [57001.468580]  [<ffffffff816d32ac>] 
x86_64_start_reservations+0xb3/0xb7
Oct  9 03:09:34 aapi205 kernel: [57001.468583]  [<ffffffff816d33ab>] 
x86_64_start_kernel+0xfb/0x10a
Oct  9 03:09:34 aapi205 kernel: [57001.468187] NMI backtrace for cpu 1
Oct  9 03:09:34 aapi205 kernel: [57001.468187] CPU 1
Oct  9 03:09:34 aapi205 kernel: [57001.468187] Modules linked in: 
nvidia(P) binfmt_misc sco bnep rfcomm l2cap bluetooth rfkill ppdev lp 
fuse ext3 jbd coretemp it87 hwmon_vid sbp2 loop snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device snd parport_pc soundcore i2c_i801 
shpchp parport evdev pci_hotplug pcspkr snd_page_alloc psmouse serio_raw 
i2c_core button intel_agp processor ext4 mbcache jbd2 crc16 sg sd_mod 
sr_mod cdrom ata_piix ata_generic ahci libahci ide_pci_generic libata 
ohci1394 ieee1394 jmicron thermal ide_core floppy scsi_mod uhci_hcd 
r8169 mii thermal_sys ehci_hcd [last unloaded: nvidia]
Oct  9 03:09:34 aapi205 kernel: [57001.468187]
Oct  9 03:09:34 aapi205 kernel: [57001.468187] Pid: 8181, comm: 
firefox-bin Tainted: P        W   2.6.36-rc7-git1 #1 EP45-UD3/EP45-UD3
Oct  9 03:09:34 aapi205 kernel: [57001.468187] RIP: 
0010:[<ffffffff811a2506>]  [<ffffffff811a2506>] __const_udelay+0x2f/0x3d
Oct  9 03:09:34 aapi205 kernel: [57001.468187] RSP: 
0000:ffff880001a83dd8  EFLAGS: 00000002
Oct  9 03:09:34 aapi205 kernel: [57001.468187] RAX: 0000000001062560 
RBX: 0000000000000001 RCX: ffff880001a80000
Oct  9 03:09:34 aapi205 kernel: [57001.468187] RDX: 00000000227cb1d2 
RSI: 0000000000000002 RDI: 0000000000418958
Oct  9 03:09:34 aapi205 kernel: [57001.468187] RBP: ffff880001a83dd8 
R08: 0000000000000002 R09: 00000000ffffffff
Oct  9 03:09:34 aapi205 kernel: [57001.468187] R10: 000000000000001f 
R11: 0000000000000000 R12: ffff880001a8f450
Oct  9 03:09:34 aapi205 kernel: [57001.468187] R13: ffffffff8163f000 
R14: 0000000000000000 R15: ffff880001a83f48
Oct  9 03:09:34 aapi205 kernel: [57001.468187] FS: 
00007fb6c5516710(0000) GS:ffff880001a80000(0000) knlGS:0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468187] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Oct  9 03:09:34 aapi205 kernel: [57001.468187] CR2: 00007fb6ab1c9000 
CR3: 00000000a8358000 CR4: 00000000000006e0
Oct  9 03:09:34 aapi205 kernel: [57001.468187] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468187] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  9 03:09:34 aapi205 kernel: [57001.468187] Process firefox-bin (pid: 
8181, threadinfo ffff8800933e2000, task ffff8800ac1b3000)
Oct  9 03:09:34 aapi205 kernel: [57001.468187] Stack:
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  ffff880001a83df8 
ffffffff8101c813 0000000000000018 ffffffff8163f000
Oct  9 03:09:34 aapi205 kernel: [57001.468187] <0> ffff880001a83e48 
ffffffff81091de0 ffff880001a83e38 ffffffff8103901e
Oct  9 03:09:34 aapi205 kernel: [57001.468187] <0> 00000000000129c0 
0000000000000001 0000000000000001 0000000000000001
Oct  9 03:09:34 aapi205 kernel: [57001.468187] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  <IRQ>
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8101c813>] 
arch_trigger_all_cpu_backtrace+0x51/0x5d
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81091de0>] 
__rcu_pending+0x83/0x35c
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8103901e>] ? 
account_user_time+0x6c/0x75
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff810921eb>] 
rcu_check_callbacks+0x132/0x163
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8104d54e>] 
update_process_times+0x3c/0x5b
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81067275>] 
tick_sched_timer+0x6a/0x94
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8105d800>] 
__run_hrtimer+0xcf/0x146
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8106720b>] ? 
tick_sched_timer+0x0/0x94
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8105dabe>] 
hrtimer_interrupt+0xc9/0x1c5
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81038cc8>] ? 
add_preempt_count+0xad/0xb2
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8101c286>] 
smp_apic_timer_interrupt+0x82/0x95
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81003513>] 
apic_timer_interrupt+0x13/0x20
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  <EOI>
Oct  9 03:09:34 aapi205 kernel: [57001.468187] Code: bd 00 00 00 00 48 
89 e5 48 c7 c2 80 28 01 00 65 8b 0c 25 00 d4 00 00 48 63 c9 48 8b 0c cd 
a0 96 6b 81 48 6b 94 0a 98 00 00 00 3e <f7> e2 48 8d 7a 01 ff 15 2e 31 
4b 00 c9 c3 55 48 69 ff c7 10 00
Oct  9 03:09:34 aapi205 kernel: [57001.468187] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  <IRQ> 
[<ffffffff8101c813>] arch_trigger_all_cpu_backtrace+0x51/0x5d
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81091de0>] 
__rcu_pending+0x83/0x35c
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8103901e>] ? 
account_user_time+0x6c/0x75
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff810921eb>] 
rcu_check_callbacks+0x132/0x163
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8104d54e>] 
update_process_times+0x3c/0x5b
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81067275>] 
tick_sched_timer+0x6a/0x94
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8105d800>] 
__run_hrtimer+0xcf/0x146
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8106720b>] ? 
tick_sched_timer+0x0/0x94
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8105dabe>] 
hrtimer_interrupt+0xc9/0x1c5
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81038cc8>] ? 
add_preempt_count+0xad/0xb2
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8101c286>] 
smp_apic_timer_interrupt+0x82/0x95
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81003513>] 
apic_timer_interrupt+0x13/0x20
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  <EOI> Pid: 8181, comm: 
firefox-bin Tainted: P        W   2.6.36-rc7-git1 #1
Oct  9 03:09:34 aapi205 kernel: [57001.468187] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  <NMI> 
[<ffffffff8100aba8>] ? show_regs+0x26/0x2b
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8101c9f0>] 
nmi_watchdog_tick+0xaa/0x19a
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff810048ea>] 
do_nmi+0xdb/0x291
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81313ba0>] 
nmi+0x20/0x30
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff811a2506>] ? 
__const_udelay+0x2f/0x3d
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  <<EOE>>  <IRQ> 
[<ffffffff8101c813>] arch_trigger_all_cpu_backtrace+0x51/0x5d
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81091de0>] 
__rcu_pending+0x83/0x35c
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8103901e>] ? 
account_user_time+0x6c/0x75
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff810921eb>] 
rcu_check_callbacks+0x132/0x163
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8104d54e>] 
update_process_times+0x3c/0x5b
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81067275>] 
tick_sched_timer+0x6a/0x94
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8105d800>] 
__run_hrtimer+0xcf/0x146
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8106720b>] ? 
tick_sched_timer+0x0/0x94
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8105dabe>] 
hrtimer_interrupt+0xc9/0x1c5
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81038cc8>] ? 
add_preempt_count+0xad/0xb2
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff8101c286>] 
smp_apic_timer_interrupt+0x82/0x95
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  [<ffffffff81003513>] 
apic_timer_interrupt+0x13/0x20
Oct  9 03:09:34 aapi205 kernel: [57001.468187]  <EOI>
Oct  9 03:09:34 aapi205 kernel: [57001.468909] NMI backtrace for cpu 2
Oct  9 03:09:34 aapi205 kernel: [57001.468911] CPU 2
Oct  9 03:09:34 aapi205 kernel: [57001.468913] Modules linked in: 
nvidia(P) binfmt_misc sco bnep rfcomm l2cap bluetooth rfkill ppdev lp 
fuse ext3 jbd coretemp it87 hwmon_vid sbp2 loop snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device snd parport_pc soundcore i2c_i801 
shpchp parport evdev pci_hotplug pcspkr snd_page_alloc psmouse serio_raw 
i2c_core button intel_agp processor ext4 mbcache jbd2 crc16 sg sd_mod 
sr_mod cdrom ata_piix ata_generic ahci libahci ide_pci_generic libata 
ohci1394 ieee1394 jmicron thermal ide_core floppy scsi_mod uhci_hcd 
r8169 mii thermal_sys ehci_hcd [last unloaded: nvidia]
Oct  9 03:09:34 aapi205 kernel: [57001.468964]
Oct  9 03:09:34 aapi205 kernel: [57001.468967] Pid: 8180, comm: 
firefox-bin Tainted: P        W   2.6.36-rc7-git1 #1 EP45-UD3/EP45-UD3
Oct  9 03:09:34 aapi205 kernel: [57001.468970] RIP: 
0033:[<00007fb6b595322b>]  [<00007fb6b595322b>] 0x7fb6b595322b
Oct  9 03:09:34 aapi205 kernel: [57001.468977] RSP: 
002b:00007fb6b47fdc40  EFLAGS: 00000246
Oct  9 03:09:34 aapi205 kernel: [57001.468979] RAX: 0000000000000000 
RBX: 00007fb6b4da4ae0 RCX: 00007fb6af5f4000
Oct  9 03:09:34 aapi205 kernel: [57001.468982] RDX: 00007fb6af5f4000 
RSI: 00007fb6b47fdc10 RDI: 00007fb6bbdb96a0
Oct  9 03:09:34 aapi205 kernel: [57001.468984] RBP: 00007fb6af5f40d8 
R08: 0000000000000048 R09: 00007fb6af5f4020
Oct  9 03:09:34 aapi205 kernel: [57001.468987] R10: 0000000000000003 
R11: 0000000000000805 R12: 0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468989] R13: 0000000000000003 
R14: 00000000020100cc R15: 00000000000000cc
Oct  9 03:09:34 aapi205 kernel: [57001.468992] FS: 
00007fb6b47ff710(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.468995] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Oct  9 03:09:34 aapi205 kernel: [57001.468998] CR2: 00007fb6ab1c4000 
CR3: 00000000a8358000 CR4: 00000000000006e0
Oct  9 03:09:34 aapi205 kernel: [57001.469000] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Oct  9 03:09:34 aapi205 kernel: [57001.469003] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  9 03:09:34 aapi205 kernel: [57001.469006] Process firefox-bin (pid: 
8180, threadinfo ffff880052192000, task ffff88005969e000)
Oct  9 03:09:34 aapi205 kernel: [57001.469008]
Oct  9 03:09:34 aapi205 kernel: [57001.469009] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.469012] Pid: 8180, comm: 
firefox-bin Tainted: P        W   2.6.36-rc7-git1 #1
Oct  9 03:09:34 aapi205 kernel: [57001.469014] Call Trace:
Oct  9 03:09:34 aapi205 kernel: [57001.469015]  <NMI> 
[<ffffffff8100aba8>] ? show_regs+0x26/0x2b
Oct  9 03:09:34 aapi205 kernel: [57001.469022]  [<ffffffff8101c9f0>] 
nmi_watchdog_tick+0xaa/0x19a
Oct  9 03:09:34 aapi205 kernel: [57001.469025]  [<ffffffff810048ea>] 
do_nmi+0xdb/0x291
Oct  9 03:09:34 aapi205 kernel: [57001.469028]  [<ffffffff81313ba0>] 
nmi+0x20/0x30

Should I worry?

Regards,

Piotr Hosowicz

-- 
Janusz Korwin-Mikke:
"ZUS z pewno¶ci± jest instytucj± przestêpcz±,
ale nie mo¿na nazwaæ jej zorganizowan±."
NP: Patrick O'Hearn - Facing the Sun
NB: 2.6.36-rc7-git1
