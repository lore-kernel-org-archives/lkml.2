Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1LES0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:26:16 -0500
Received: from nm21-vm6.bullet.mail.ird.yahoo.com ([212.82.109.246]:21863 "HELO
	nm21-vm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756454Ab1LES0N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:26:13 -0500
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Dec 2011 13:26:13 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 284511.34339.bm@omp1026.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=wozliWo7EFEWeuKOjgdBJc8CxH1NVGDT5Wa+CraHuLMKpNBm2dnyWiWx7FXS5Lpg/oW+h1pov9VWl5r0AuF2bZbjA5PDxK7wm/CmE1afRAc3MRCB5+yMZZi3VkhBGnZ9+TnCrWruIdBw9WUa4+j7DasrrmSJc0boIBK81OLbD3w=;
X-YMail-OSG: GZHXvjMVM1neQnY1Yo6ovvRyohIkf9PuGKIujPCl.i7GSBY
 BBvx.eGMh3Hh268byQyTo87l6PT3T_XYzkb6CtT.6nAhETkE3huvQaLiXCsC
 FVzkH6JXbTGLhGfh2B548zQqIBIr53e7jaDf1WtoKVx4a21tvkQzuphh0mqu
 6rLPgxISmfZD2oD9NpJDBomkjGvm0f6jSAm91J3HmOdOz8RCxUtQbUDMJwB.
 WPUSyPTR2HN0qwWerGEZWSYfOOj9r0mISfeXZbaaetNjAG5WVAdHvzWBn_Ud
 OFky8aluKttlqCtGW4Z1mb5GzE9lKD_ulkE_wE728PXQAEzqH.QFTRTB4DHX
 ipr4e0NIqyNZoiI.1L0kHxzgqrLJwhFQvLthnl6xjFj6gLunsuKu3cqxytXi
 ImRGR7LWFd0SB_jURGdd4yfIefb_y6nvST3J20h6TobmhMYg9vXZ5yPbHTs5
 8ebE355p1eITkBQ0UyV.DtEmg0NnVORbEmx.Pauppigjeh2hNza9olCFcdk8
 o4MrQonHa9DLqBDQ-
X-Mailer: YahooMailWebService/0.8.115.325013
Message-ID: <1323109235.85169.YahooMailNeo@web24612.mail.ird.yahoo.com>
Date: Mon, 5 Dec 2011 18:20:35 +0000 (GMT)
From: Ewan Higgs <ewan_higgs@yahoo.co.uk>
Reply-To: Ewan Higgs <ewan_higgs@yahoo.co.uk>
Subject: [Bug?] Machine hangs, rtl8192se possible cause
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Yaroslav Fedevych <jaroslaw.fedewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello LKML,
I appear to be having trouble which resembles Jaroslaw Fedewicz's problems with the rtl8192se driver from August[1]. I was curious if there was progress on the problem and what I might be able to do to help.

Multiple times a day, my machine hangs with the most recent activity in the syslog being a disconnect, a reconnect, and then a root cron job which accesses the network. Sometimes I get a kernel BUG trace from corrupt memory. syslog also reports that the most recent thing before the memory corruption was the disconnect and reconnect.

Here are some examples of the syslog details from a hang (with some judicious cutting) [3].

Here's another hang I had later in the day: [4]


Between these two hangs, I had lot of kernel BUG trace: [5]. This kernel stack trace message on several times across the entire process and several times, for each core. If you'd like, I can attach the entire syslog file.


Finally, here's the uname output on this Debian box:

$ uname -a
Linux scarlet 3.1.0-1-amd64 #1 SMP Mon Nov 14 08:02:25 UTC 2011 x86_64 GNU/Linux

Thanks for any help and/or guidance you can offer here.
Yours,Ewan Higgs

Please CC me on further discussion of this issue.


[1] https://lkml.org/lkml/2011/8/1/158

[2] Here is the output from lspci:

$ lspci
00:00.0 Host bridge: ATI Technologies Inc RD890 Northbridge only single slot PCI-e GFX Hydra part (rev 02)
00:02.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI express gpp port B)
00:04.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI express gpp port D)
00:05.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI express gpp port E)
00:06.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI express gpp port F)
00:07.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI express gpp port G)
00:0b.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (NB-SB link)
00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode] (rev 40)
00:12.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 41)
00:14.1 IDE interface: ATI Technologies Inc SB7x0/SB8x0/SB9x0 IDE Controller (rev 40)
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
00:14.5 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
00:16.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:16.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller (rev 10)
03:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
05:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6315 Series Firewire Controller
06:00.0 SATA controller: JMicron Technology Corp. JMB361 AHCI/IDE (rev 02)
06:00.1 IDE interface: JMicron Technology Corp. JMB361 AHCI/IDE (rev 02)
07:00.0 VGA compatible controller: nVidia Corporation GF104 [GeForce GTX 460] (rev a1)
07:00.1 Audio device: nVidia Corporation GF104 High Definition Audio Controller (rev a1)

[3]
Dec  5 11:14:18 scarlet wpa_supplicant[2332]: CTRL-EVENT-DISCONNECTED bssid=00:fe:f4:21:58:b0 reason=6

Dec  5 11:14:33 scarlet wpa_supplicant[2332]: WPA: Key negotiation completed with 00:fe:f4:21:58:b0 [PTK=CCMP GTK=TKIP]

Dec  5 11:14:33 scarlet wpa_supplicant[2332]: CTRL-EVENT-CONNECTED - Connection to 00:fe:f4:21:58:b0 completed (reauth) [id=0 id_str=]

Dec  5 11:28:19 scarlet wpa_supplicant[2332]: CTRL-EVENT-DISCONNECTED bssid=00:fe:f4:21:58:b0 reason=6

Dec  5 11:28:39 scarlet wpa_supplicant[2332]: WPA: Key negotiation completed with 00:fe:f4:21:58:b0 [PTK=CCMP GTK=TKIP]

Dec  5 11:28:39 scarlet wpa_supplicant[2332]: CTRL-EVENT-CONNECTED - Connection to 00:fe:f4:21:58:b0 completed (reauth) [id=0 id_str=]

...
Dec  5 11:29:00 scarlet dbus[1635]: [system] Activating service name='org.freedesktop.nm_dispatcher' (using servicehelper)
Dec  5 11:29:00 scarlet dbus[1635]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Dec  5 11:29:11 scarlet ntpdate[25710]: adjust time server 193.40.133.142 offset -0.303122 sec
Dec  5 11:30:01 scarlet /USR/SBIN/CRON[25725]: (root) CMD (if [ -x /etc/munin/plugins/apt_all ]; then /etc/munin/plugins/apt_all update 7200 12 >/dev/null; elif [ -x /etc/munin/plugins/apt ]; then /etc/munin/plugins/apt update 7200 12 >/dev/null; fi)
Dec  5 11:34:39 scarlet wpa_supplicant[2332]: WPA: Group rekeying completed with 00:fe:f4:21:58:b0 [GTK=TKIP]
Dec  5 11:35:01 scarlet /USR/SBIN/CRON[25750]: (root) CMD (if [ -x /etc/munin/plugins/apt_all ]; then /etc/munin/plugins/apt_all update 7200 12 >/dev/null; elif [ -x /etc/munin/plugins/apt ]; then /etc/munin/plugins/apt update 7200 12 >/dev/null; fi)
Dec  5 11:52:23 scarlet kernel: imklog 5.8.6, log source = /proc/kmsg started.
Dec  5 11:52:23 scarlet rsyslogd: [origin software="rsyslogd" swVersion="5.8.6" x-pid="1570" x-info="http://www.rsyslog.com"] start
Dec  5 11:52:23 scarlet kernel: [    0.000000] Initializing cgroup subsys cpuset
Dec  5 11:52:23 scarlet kernel: [    0.000000] Initializing cgroup subsys cpu


[4]
Dec  5 15:14:38 scarlet wpa_supplicant[2019]: WPA: Group rekeying completed with 00:fe:f4:21:58:b0 [GTK=TKIP]
Dec  5 15:15:01 scarlet /USR/SBIN/CRON[3781]: (root) CMD (if [ -x /etc/munin/plugins/apt_all ]; then /etc/munin/plugins/apt_all update 7200 12 >/dev/null; elif [ -x /etc/munin/pl
ugins/apt ]; then /etc/munin/plugins/apt update 7200 12 >/dev/null; fi)
Dec  5 15:17:01 scarlet /USR/SBIN/CRON[3798]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Dec  5 15:20:01 scarlet /USR/SBIN/CRON[3817]: (root) CMD (if [ -x /etc/munin/plugins/apt_all ]; then /etc/munin/plugins/apt_all update 7200 12 >/dev/null; elif [ -x /etc/munin/pl
ugins/apt ]; then /etc/munin/plugins/apt update 7200 12 >/dev/null; fi)
Dec  5 15:24:28 scarlet kernel: imklog 5.8.6, log source = /proc/kmsg started.
Dec  5 15:24:28 scarlet rsyslogd: [origin software="rsyslogd" swVersion="5.8.6" x-pid="1536" x-info="http://www.rsyslog.com"] start
Dec  5 15:24:28 scarlet kernel: [    0.000000] Initializing cgroup subsys cpuset
Dec  5 15:24:28 scarlet kernel: [    0.000000] Initializing cgroup subsys cpu


[5]
Dec  5 14:51:06 scarlet wpa_supplicant[2280]: Associated with 00:fe:f4:21:58:b0
Dec  5 14:51:06 scarlet NetworkManager[1829]: <info> (wlan0): supplicant interface state: associating -> associated
Dec  5 14:51:06 scarlet NetworkManager[1829]: <info> (wlan0): supplicant interface state: associated -> 4-way handshake
Dec  5 14:51:06 scarlet wpa_supplicant[2280]: WPA: Key negotiation completed with 00:fe:f4:21:58:b0 [PTK=CCMP GTK=TKIP]
Dec  5 14:51:06 scarlet wpa_supplicant[2280]: CTRL-EVENT-CONNECTED - Connection to 00:fe:f4:21:58:b0 completed (reauth) [id=0 id_str=]
Dec  5 14:51:06 scarlet NetworkManager[1829]: <info> (wlan0): supplicant interface state: 4-way handshake -> completed
Dec  5 14:54:38 scarlet wpa_supplicant[2280]: WPA: Group rekeying completed with 00:fe:f4:21:58:b0 [GTK=TKIP]
Dec  5 14:54:56 scarlet kernel: [11015.129050] /build/buildd-linux-2.6_3.1.1-1-amd64-A9YWBe/linux-2.6-3.1.1/debian/build/source_amd64_none/mm/memory.c:414: bad pmd ffff880232daa180(0000000232dac077).
Dec  5 14:54:56 scarlet kernel: [11015.129168] ------------[ cut here ]------------
Dec  5 14:54:56 scarlet kernel: [11015.129177] kernel BUG at /build/buildd-linux-2.6_3.1.1-1-amd64-A9YWBe/linux-2.6-3.1.1/debian/build/source_amd64_none/mm/mmap.c:2274!
Dec  5 14:54:56 scarlet kernel: [11015.129186] invalid opcode: 0000 [#1] SMP 
Dec  5 14:54:56 scarlet kernel: [11015.129194] CPU 4 
Dec  5 14:54:56 scarlet kernel: [11015.129197] Modules linked in: nls_utf8 nls_cp437 vfat fat cryptd aes_x86_64 aes_generic ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables parport_pc ppdev lp parport bnep powernow_k8 rfcomm mperf bluetooth cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative crc16 binfmt_misc fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc firewire_sbp2 loop kvm_amd kvm snd_hda_codec_hdmi joydev nvidia(P) snd_hda_codec_realtek snd_hda_intel snd_hda_codec arc4 snd_pcm_oss snd_hwdep snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq rtl8192se rtlwifi mac80211 snd_timer snd_seq_device sp5100_tco snd psmouse pcspkr edac_core soundcore evdev serio_raw cfg80211 i2c_piix4 edac_mce_amd snd_page_alloc k10temp i2c_core rfkill asus_atk0110 processor wmi button thermal_sys ext3 jbd mbcache btrfs zlib_deflate crc32c libcrc32c dm_mod usb_storage uas sr_mod usbhid hid
 cdrom sd_mod ata_generic crc_t10dif ohci_hcd xhci_hcd pata_jmic
Dec  5 14:54:56 scarlet kernel: ron firewire_ohci ehci_hcd r8169 pata_atiixp mii firewire_core crc_itu_t ahci libahci usbcore libata scsi_mod [last unloaded: scsi_wait_scan]
Dec  5 14:54:56 scarlet kernel: [11015.129374] 
Dec  5 14:54:56 scarlet kernel: [11015.129381] Pid: 16269, comm: sh Tainted: P           O 3.1.0-1-amd64 #1 System manufacturer System Product Name/M4A89TD PRO USB3
Dec  5 14:54:56 scarlet kernel: [11015.129395] RIP: 0010:[<ffffffff810d02be>]  [<ffffffff810d02be>] exit_mmap+0xd6/0xe1
Dec  5 14:54:56 scarlet kernel: [11015.129412] RSP: 0018:ffff880232da3c58  EFLAGS: 00010202
Dec  5 14:54:56 scarlet kernel: [11015.129419] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000008
Dec  5 14:54:56 scarlet kernel: [11015.129426] RDX: 0000000000000072 RSI: ffff8800bc802768 RDI: 0000000000000282
Dec  5 14:54:56 scarlet kernel: [11015.129432] RBP: ffff88041e210c00 R08: 0000000000000000 R09: fffffffffffffff9
Dec  5 14:54:56 scarlet kernel: [11015.129439] R10: ffff880232da3c58 R11: ffff880232da3c58 R12: 00007fffce2d3000
Dec  5 14:54:56 scarlet kernel: [11015.129445] R13: ffff88041dd53d80 R14: ffff88041e210c00 R15: 0000000000000004
Dec  5 14:54:56 scarlet kernel: [11015.129454] FS:  00002ac2c657bb20(0000) GS:ffff88042fd00000(0000) knlGS:0000000000000000
Dec  5 14:54:56 scarlet kernel: [11015.129461] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec  5 14:54:56 scarlet kernel: [11015.129467] CR2: 00002af4791f2520 CR3: 0000000232f63000 CR4: 00000000000006e0
Dec  5 14:54:56 scarlet kernel: [11015.129474] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  5 14:54:56 scarlet kernel: [11015.129480] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec  5 14:54:56 scarlet kernel: [11015.129488] Process sh (pid: 16269, threadinfo ffff880232da2000, task ffff8802410e8730)
Dec  5 14:54:56 scarlet kernel: [11015.129493] Stack:
Dec  5 14:54:56 scarlet kernel: [11015.129497]  ffff88041e210c00 000000014009ef44 ffff880232da3c70 0000000000000000
Dec  5 14:54:56 scarlet kernel: [11015.129511]  0000000800000000 ffffea000e5ce140 ffffea000e5ce178 ffffea000e5bc080
Dec  5 14:54:56 scarlet kernel: [11015.129522]  ffffea000e6d81b0 ffffea000e6dc158 ffffea000e5d4d50 ffffea000ea6a4a0
Dec  5 14:54:56 scarlet kernel: [11015.129533] Call Trace:
Dec  5 14:54:56 scarlet kernel: [11015.129545]  [<ffffffff81043574>] ? mmput+0x56/0xf8
Dec  5 14:54:56 scarlet kernel: [11015.129555]  [<ffffffff810f8bf7>] ? flush_old_exec+0x4b0/0x5a1
Dec  5 14:54:56 scarlet kernel: [11015.129567]  [<ffffffff8112cfe3>] ? load_elf_binary+0x2b0/0x1761
Dec  5 14:54:56 scarlet kernel: [11015.129581]  [<ffffffffa0fdb8ac>] ? load_misc_binary+0x6e/0x2e4 [binfmt_misc]
Dec  5 14:54:56 scarlet kernel: [11015.129590]  [<ffffffff810f80ec>] ? get_arg_page+0x7a/0xbf
Dec  5 14:54:56 scarlet kernel: [11015.129601]  [<ffffffff8103538b>] ? should_resched+0x5/0x23
Dec  5 14:54:56 scarlet kernel: [11015.129611]  [<ffffffff8132c02f>] ? _cond_resched+0x7/0x1c
Dec  5 14:54:56 scarlet kernel: [11015.129619]  [<ffffffff810f8165>] ? get_user_arg_ptr.isra.20+0x34/0x48
Dec  5 14:54:56 scarlet kernel: [11015.129629]  [<ffffffff8103538b>] ? should_resched+0x5/0x23
Dec  5 14:54:56 scarlet kernel: [11015.129638]  [<ffffffff810f85a7>] ? search_binary_handler+0xa7/0x237
Dec  5 14:54:56 scarlet kernel: [11015.129647]  [<ffffffff8112cd33>] ? load_elf_library+0x228/0x228
Dec  5 14:54:56 scarlet kernel: [11015.129656]  [<ffffffff810f9306>] ? do_execve_common.isra.26+0x1d2/0x2d1
Dec  5 14:54:56 scarlet kernel: [11015.129673]  [<ffffffff810148ba>] ? sys_execve+0x3f/0x54
Dec  5 14:54:56 scarlet kernel: [11015.129682]  [<ffffffff811a277d>] ? __put_user_4+0x1d/0x30
Dec  5 14:54:56 scarlet kernel: [11015.129692]  [<ffffffff8133272c>] ? stub_execve+0x6c/0xc0
Dec  5 14:54:56 scarlet kernel: [11015.129699] Code: d5 9c ff ff 4c 89 e2 31 f6 48 89 e7 e8 d0 97 ff ff 48 89 df e8 bf eb ff ff 48 85 c0 48 89 c3 75 f0 48 83 bd d8 00 00 00 00 74 02 <0f> 0b 48 83 c4 70 5b 5d 41 5c c3 55 48 89 fd 53 48 89 f3 48 83 
Dec  5 14:54:56 scarlet kernel: [11015.129772] RIP  [<ffffffff810d02be>] exit_mmap+0xd6/0xe1
Dec  5 14:54:56 scarlet kernel: [11015.129781]  RSP <ffff880232da3c58>
Dec  5 14:54:56 scarlet kernel: [11015.129788] ---[ end trace d35d20c63f7f9c1b ]---
Dec  5 14:54:56 scarlet kernel: [11015.148797] BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
Dec  5 14:54:56 scarlet kernel: [11015.148812] IP: [<ffffffff810dae06>] valid_swaphandles+0x65/0xd5
Dec  5 14:54:56 scarlet kernel: [11015.148828] PGD 22dc6c067 PUD 234fa3067 PMD 0 
Dec  5 14:54:56 scarlet kernel: [11015.148838] Oops: 0000 [#2] SMP 
Dec  5 14:54:56 scarlet kernel: [11015.148847] CPU 4 
Dec  5 14:54:56 scarlet kernel: [11015.148850] Modules linked in: nls_utf8 nls_cp437 vfat fat cryptd aes_x86_64 aes_generic ip6table_filter ip6_tables iptable_filter ip_tables eb
table_nat ebtables x_tables parport_pc ppdev lp parport bnep powernow_k8 rfcomm mperf bluetooth cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative crc16 binfm
t_misc fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc firewire_sbp2 loop kvm_amd kvm snd_hda_codec_hdmi joydev nvidia(P) snd_hda_codec_realtek snd_hda_intel snd_hda_codec arc4 snd_pcm_oss snd_hwdep snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq rtl8192se rtlwifi mac80211 snd_timer snd_seq_device sp5100_tco snd psmouse pcspkr edac_core soundcore evdev serio_raw cfg80211 i2c_piix4 edac_mce_amd snd_page_alloc k10temp i2c_core rfkill asus_atk0110 processor wmi button thermal_sys ext3 jbd mbcache btrfs zlib_deflate crc32c libcrc32c dm_mod usb_storage uas sr_mod usbhid hid cdrom sd_mod ata_generic crc_t10dif ohci_hcd xhci_hcd pata_jmic
Dec  5 14:54:56 scarlet kernel: ron firewire_ohci ehci_hcd r8169 pata_atiixp mii firewire_core crc_itu_t ahci libahci usbcore libata scsi_mod [last unloaded: scsi_wait_scan]
Dec  5 14:54:56 scarlet kernel: [11015.149025] 
Dec  5 14:54:56 scarlet kernel: [11015.149032] Pid: 16271, comm: sh Tainted: P      D    O 3.1.0-1-amd64 #1 System manufacturer System Product Name/M4A89TD PRO USB3
Dec  5 14:54:56 scarlet kernel: [11015.149044] RIP: 0010:[<ffffffff810dae06>]  [<ffffffff810dae06>] valid_swaphandles+0x65/0xd5
Dec  5 14:54:56 scarlet kernel: [11015.149056] RSP: 0000:ffff880230117d38  EFLAGS: 00010246
Dec  5 14:54:56 scarlet kernel: [11015.149062] RAX: 0000000000000e0c RBX: 0000000000000001 RCX: 0000000000000003
Dec  5 14:54:56 scarlet kernel: [11015.149069] RDX: 0000000000000e0c RSI: ffff880230117d70 RDI: ffffffff817d2270
Dec  5 14:54:56 scarlet kernel: [11015.149075] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000028
Dec  5 14:54:56 scarlet kernel: [11015.149082] R10: 00002b6fba94ae90 R11: 00002b6fba94ae90 R12: 0000000000000000
Dec  5 14:54:56 scarlet kernel: [11015.149088] R13: ffff880230117d70 R14: 0000000000000008 R15: 00000000000200da
Dec  5 14:54:56 scarlet kernel: [11015.149096] FS:  00002b6fbac67b20(0000) GS:ffff88042fd00000(0000) knlGS:0000000000000000
Dec  5 14:54:56 scarlet kernel: [11015.149103] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  5 14:54:56 scarlet kernel: [11015.149109] CR2: 000000000000000c CR3: 0000000232f63000 CR4: 00000000000006e0
Dec  5 14:54:56 scarlet kernel: [11015.149116] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  5 14:54:56 scarlet kernel: [11015.149123] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec  5 14:54:56 scarlet kernel: [11015.149130] Process sh (pid: 16271, threadinfo ffff880230116000, task ffff880256b6cfa0)
Dec  5 14:54:56 scarlet kernel: [11015.149135] Stack:
Dec  5 14:54:56 scarlet kernel: [11015.149139]  4000000000000000 4000000000000000 00002b6fba9253c0 ffff8802b6d0b3f8
Dec  5 14:54:56 scarlet kernel: [11015.149151]  00002b6fba9253c0 ffffffff810d842a ffffffff810edf8b ffff8802449b4440
Dec  5 14:54:56 scarlet kernel: [11015.149162]  0000000000000001 ffff8802b6d0b3f8 ffff880232daa928 00002b6fba9253c0
Dec  5 14:54:56 scarlet kernel: [11015.149173] Call Trace:
Dec  5 14:54:56 scarlet kernel: [11015.149184]  [<ffffffff810d842a>] ? swapin_readahead+0x2f/0x99
Dec  5 14:54:56 scarlet kernel: [11015.149194]  [<ffffffff810edf8b>] ? try_get_mem_cgroup_from_mm+0x28/0x32
Dec  5 14:54:56 scarlet kernel: [11015.149205]  [<ffffffff810cbb41>] ? handle_pte_fault+0x347/0x79f
Dec  5 14:54:56 scarlet kernel: [11015.149214]  [<ffffffff810c8ffd>] ? set_pmd+0x5/0x8
Dec  5 14:54:56 scarlet kernel: [11015.149223]  [<ffffffff810ca0b0>] ? __pte_alloc+0x87/0x11e
Dec  5 14:54:56 scarlet kernel: [11015.149232]  [<ffffffff810c908d>] ? pte_offset_kernel+0x16/0x35
Dec  5 14:54:56 scarlet kernel: [11015.149242]  [<ffffffff813302c0>] ? do_page_fault+0x312/0x337
Dec  5 14:54:56 scarlet kernel: [11015.149250]  [<ffffffff810cf4a6>] ? vma_link+0x6d/0x8b
Dec  5 14:54:56 scarlet kernel: [11015.149258]  [<ffffffff810d07ad>] ? do_brk+0x22d/0x280
Dec  5 14:54:56 scarlet kernel: [11015.149266]  [<ffffffff8132d8f5>] ? page_fault+0x25/0x30
Dec  5 14:54:56 scarlet kernel: [11015.149272] Code: 80 22 7d 81 48 89 eb b8 01 00 00 00 48 d3 eb d3 e0 48 d3 e3 48 98 4c 8d 34 03 48 85 db b8 01 00 00 00 48 0f 44 d8 e8 00 25 25 00 
Dec  5 14:54:56 scarlet kernel: [11015.149347] RIP  [<ffffffff810dae06>] valid_swaphandles+0x65/0xd5
Dec  5 14:54:56 scarlet kernel: [11015.149355]  RSP <ffff880230117d38>
Dec  5 14:54:56 scarlet kernel: [11015.149359] CR2: 000000000000000c
Dec  5 14:54:56 scarlet kernel: [11015.149366] ---[ end trace d35d20c63f7f9c1c ]---
