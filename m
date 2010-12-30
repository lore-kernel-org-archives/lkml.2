Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0L3Upq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 15:45:46 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:53004 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0L3Upm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 15:45:42 -0500
Date: Thu, 30 Dec 2010 21:45:22 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20101230204522.GC23219@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
References: <4D1A8200.4010609@lwfinger.net>
 <20101229195440.GD5838@darkside.kls.lan>
 <4D1BD2B0.4020101@lwfinger.net>
 <20101230012003.GA2665@darkside.kls.lan>
 <4D1BF056.3060909@lwfinger.net>
 <20101230143406.GA23219@darkside.kls.lan>
 <4D1CD161.4040107@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="phCU5ROyZO6kBE05"
Content-Disposition: inline
In-Reply-To: <4D1CD161.4040107@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--phCU5ROyZO6kBE05
Content-Type: multipart/mixed; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 30, 2010 at 12:37:21PM -0600, Larry Finger wrote:
> The head of the rng_list is damaged. It is initialized at compile time and
> should be OK. To help discover the order in which hwrng_register() is cal=
led,
> apply the attached patch. Run it once with commit 84c164a34ffe67908a inst=
alled,
> and once with it reverted.

All right, 3 dmesg excerpts attached...
2.6.37-rc7-vanilla.dmesg:
	2.6.37-rc7 vanilla (i.e. with 84c164a34ffe67908a), crashing
	via-rng is registered first, b43-rng second
2.6.37-rc7-without.dmesg:
	2.6.37-rc7 with 84c164a34ffe67908a reverted, not crashing
	b43-rng is registered first, via-rng second
2.6.37-rc7-without+modprobe.dmesg:
	2.6.37-rc7 with 84c164a34ffe67908a reverted, b43 blacklisted and
	manually modprobed after via-rng, crashing
	via-rng is registered first, b43-rng second

Seems like the crash shows up when b43-rng is registered second, but not
when via-rng is registered second.
Btw.: `cat rng_available' does also not crash when via-rng is registered
second.


regards
   Mario
--=20
> As Luke Leighton said once on samba-ntdom, "now, what was that about
> rebooting?   that was so long ago, i had to look it up with man -k."

--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.37-rc7-vanilla.dmesg"
Content-Transfer-Encoding: quoted-printable

[    2.048695] b43-pci-bridge 0000:02:00.0: PCI INT A -> GSI 28 (level, low=
) -> IRQ 28
[    2.048713] b43-pci-bridge 0000:02:00.0: setting latency timer to 64
=2E..
[    8.626419] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
[    8.805909] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    8.806815] Registered led device: b43-phy0::tx
[    8.806853] Registered led device: b43-phy0::rx
[    8.806894] Registered led device: b43-phy0::radio
[    8.806915] Broadcom 43xx driver loaded [ Features: PMLS, Firmware-ID: F=
W13 ]
[   11.977267] VIA RNG detected
[   11.977272] Calling hwrng_register
[   11.977278] Pid: 889, comm: modprobe Not tainted 2.6.37-rc7-self #3
[   11.977282] Call Trace:
[   11.977295]  [<f8f4e3ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   11.977303]  [<f9246023>] ? mod_init+0x23/0x3b [via_rng]
[   11.977312]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   11.977323]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   11.977354]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
=2E..
[   24.752102] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:3=
2:10)
=2E..
[   30.292235] b43-pci-bridge 0000:02:00.0: PCI: Disallowing DAC for device
[   30.292246] b43-phy0: DMA mask fallback from 64-bit to 32-bit
[   30.312705] Calling hwrng_register
[   30.312719] Pid: 1742, comm: NetworkManager Not tainted 2.6.37-rc7-self =
#3
[   30.312727] Call Trace:
[   30.312756]  [<f8f4e3ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   30.312799]  [<f8fab870>] ? b43_wireless_core_init+0xd0c/0xdd6 [b43]
[   30.312827]  [<f8fabd67>] ? b43_op_start+0xf8/0x142 [b43]
[   30.312866]  [<f8c273da>] ? cfg80211_netdev_notifier_call+0x342/0x355 [c=
fg80211]
[   30.312924]  [<f8e8e889>] ? ieee80211_do_open+0xed/0x45f [mac80211]
[   30.312956]  [<f8e8de7a>] ? ieee80211_check_concurrent_iface+0x1c/0x135 =
[mac80211]
[   30.312978]  [<c1203247>] ? __dev_open+0x7d/0xa7
[   30.312992]  [<c1201c10>] ? __dev_change_flags+0x9a/0x10d
[   30.313004]  [<c120319f>] ? dev_change_flags+0x10/0x3b
[   30.313020]  [<c120d207>] ? do_setlink+0x23e/0x532
[   30.313041]  [<c129ced6>] ? schedule+0x579/0x5b6
[   30.313052]  [<c120d5cb>] ? rtnl_setlink+0xd0/0xe1
[   30.313073]  [<c114f000>] ? clear_user+0x2b/0x43
[   30.313084]  [<c120d4fb>] ? rtnl_setlink+0x0/0xe1
[   30.313096]  [<c120cd32>] ? rtnetlink_rcv_msg+0x186/0x19c
[   30.313108]  [<c120cbac>] ? rtnetlink_rcv_msg+0x0/0x19c
[   30.313123]  [<c121bda8>] ? netlink_rcv_skb+0x2d/0x72
[   30.313134]  [<c120cba6>] ? rtnetlink_rcv+0x18/0x1e
[   30.313145]  [<c121bbfc>] ? netlink_unicast+0xba/0x10e
[   30.313156]  [<c121c700>] ? netlink_sendmsg+0x23d/0x256
[   30.313171]  [<c11f53a6>] ? __sock_sendmsg+0x48/0x4e
[   30.313181]  [<c11f560f>] ? sock_sendmsg+0x78/0x8f
[   30.313193]  [<c11f560f>] ? sock_sendmsg+0x78/0x8f
[   30.313207]  [<c10cf5dd>] ? d_kill+0x38/0x3d
[   30.313225]  [<c11fd48c>] ? verify_iovec+0x3d/0x79
[   30.313235]  [<c11f5e0d>] ? sys_sendmsg+0x15f/0x1c1
[   30.313247]  [<c11f5a44>] ? sockfd_lookup_light+0x13/0x3f
[   30.313258]  [<c11f60a5>] ? sys_sendto+0xfd/0x121
[   30.313273]  [<c10079ee>] ? __switch_to+0x6f/0xe2
[   30.313285]  [<c129ced6>] ? schedule+0x579/0x5b6
[   30.313296]  [<c11f5ca3>] ? sys_recvmsg+0x3c/0x47
[   30.313308]  [<c11f707d>] ? sys_socketcall+0x17f/0x1cb
[   30.313321]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
[   30.313362] BUG: unable to handle kernel paging request at 60870667
[   30.313372] IP: [<f8f4e3df>] hwrng_register+0x5f/0x14d [rng_core]
[   30.313391] *pdpt =3D 0000000036c34001 *pde =3D 0000000000000000=20
[   30.313403] Oops: 0000 [#1] SMP=20
[   30.313411] last sysfs file: /sys/module/bluetooth/initstate
[   30.313420] Modules linked in: l2cap crc16 parport_pc ppdev lp parport s=
bs sbshc power_meter pci_slot hed fan container acpi_cpufreq mperf cpufreq_=
conservative cpufreq_userspace cpufreq_stats cpufreq_powersave dm_crypt fus=
e loop eeprom via_cputemp i2c_dev nvram padlock_aes aes_i586 aes_generic pa=
dlock_sha sha256_generic sha1_generic via_rng msr cpuid snd_hda_codec_realt=
ek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd=
_pcm ecb snd_seq_midi snd_rawmidi snd_seq_midi_event b43 snd_seq snd_timer =
rng_core uvcvideo video snd_seq_device joydev mac80211 videodev ideapad_lap=
top output btusb battery processor bluetooth tpm_tis snd v4l1_compat ac tpm=
 wmi power_supply cfg80211 soundcore snd_page_alloc tpm_bios rfkill button =
shpchp pcspkr i2c_viapro evdev i2c_core psmouse serio_raw pci_hotplug ext3 =
jbd mbcache raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xo=
r async_memcpy async_tx raid1 raid0 multipath linear md_mod dm_mirror dm_re=
gion_hash dm_log dm_mod btrfs zlib_deflate crc32c libcrc32c sd_mod crc_t10d=
if ata_generic pata_via libata uhci_hcd ssb ehci_hcd tg3 via_sdmmc usbcore =
scsi_mod pcmcia thermal mmc_core pcmcia_core libphy thermal_sys nls_base [l=
ast unloaded: scsi_wait_scan]
[   30.313670]=20
[   30.313681] Pid: 1742, comm: NetworkManager Not tainted 2.6.37-rc7-self =
#3 MoutCook/20021,2959
[   30.313692] EIP: 0060:[<f8f4e3df>] EFLAGS: 00010216 CPU: 0
[   30.313706] EIP is at hwrng_register+0x5f/0x14d [rng_core]
[   30.313715] EAX: 00000001 EBX: f4f13010 ECX: f8f4e589 EDX: f4f13035
[   30.313725] ESI: 6087064b EDI: 00000000 EBP: 00000036 ESP: f4fe7b54
[   30.313735]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   30.313745] Process NetworkManager (pid: 1742, ti=3Df4fe6000 task=3Df6d2=
e8a0 task.ti=3Df4fe6000)
[   30.313753] Stack:
[   30.313757]  f4f12fc0 f4f13035 f8fab870 f4f13035 0000001f f8fc10bb f8fc0=
9f0 f6dcce20
[   30.313775]  0000000f f6dcac00 f6dcac00 f6f27400 f4f122c0 f4f10240 f4f12=
fc8 f8fabd67
[   30.313793]  f8c273da f4f122c0 f6ec0400 f8e9ee48 f6ec0000 f8e8e889 f8e8d=
e7a 00000000
[   30.313810] Call Trace:
[   30.313835]  [<f8fab870>] ? b43_wireless_core_init+0xd0c/0xdd6 [b43]
[   30.313863]  [<f8fabd67>] ? b43_op_start+0xf8/0x142 [b43]
[   30.313889]  [<f8c273da>] ? cfg80211_netdev_notifier_call+0x342/0x355 [c=
fg80211]
[   30.313926]  [<f8e8e889>] ? ieee80211_do_open+0xed/0x45f [mac80211]
[   30.313958]  [<f8e8de7a>] ? ieee80211_check_concurrent_iface+0x1c/0x135 =
[mac80211]
[   30.313975]  [<c1203247>] ? __dev_open+0x7d/0xa7
[   30.313986]  [<c1201c10>] ? __dev_change_flags+0x9a/0x10d
[   30.313998]  [<c120319f>] ? dev_change_flags+0x10/0x3b
[   30.314011]  [<c120d207>] ? do_setlink+0x23e/0x532
[   30.314026]  [<c129ced6>] ? schedule+0x579/0x5b6
[   30.314037]  [<c120d5cb>] ? rtnl_setlink+0xd0/0xe1
[   30.314052]  [<c114f000>] ? clear_user+0x2b/0x43
[   30.314063]  [<c120d4fb>] ? rtnl_setlink+0x0/0xe1
[   30.314074]  [<c120cd32>] ? rtnetlink_rcv_msg+0x186/0x19c
[   30.314086]  [<c120cbac>] ? rtnetlink_rcv_msg+0x0/0x19c
[   30.314098]  [<c121bda8>] ? netlink_rcv_skb+0x2d/0x72
[   30.314109]  [<c120cba6>] ? rtnetlink_rcv+0x18/0x1e
[   30.314120]  [<c121bbfc>] ? netlink_unicast+0xba/0x10e
[   30.314132]  [<c121c700>] ? netlink_sendmsg+0x23d/0x256
[   30.314145]  [<c11f53a6>] ? __sock_sendmsg+0x48/0x4e
[   30.314155]  [<c11f560f>] ? sock_sendmsg+0x78/0x8f
[   30.314167]  [<c11f560f>] ? sock_sendmsg+0x78/0x8f
[   30.314179]  [<c10cf5dd>] ? d_kill+0x38/0x3d
[   30.314192]  [<c11fd48c>] ? verify_iovec+0x3d/0x79
[   30.314203]  [<c11f5e0d>] ? sys_sendmsg+0x15f/0x1c1
[   30.314214]  [<c11f5a44>] ? sockfd_lookup_light+0x13/0x3f
[   30.314225]  [<c11f60a5>] ? sys_sendto+0xfd/0x121
[   30.314237]  [<c10079ee>] ? __switch_to+0x6f/0xe2
[   30.314250]  [<c129ced6>] ? schedule+0x579/0x5b6
[   30.314261]  [<c11f5ca3>] ? sys_recvmsg+0x3c/0x47
[   30.314272]  [<c11f707d>] ? sys_socketcall+0x17f/0x1cb
[   30.314284]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
[   30.314292] Code: 34 c8 8b 35 1c e6 f4 f8 59 83 ee 1c eb 1d 8b 13 8b 06 =
e8 84 06 20 c8 85 c0 75 0a be ef ff ff ff e9 d3 00 00 00 8b 76 1c 83 ee 1c =
<8b> 46 1c 0f 18 00 90 81 fe 00 e6 f4 f8 75 d4 83 3d 2c e8 f4 f8=20
[   30.314376] EIP: [<f8f4e3df>] hwrng_register+0x5f/0x14d [rng_core] SS:ES=
P 0068:f4fe7b54
[   30.314395] CR2: 0000000060870667
[   30.314404] ---[ end trace f498f4a4e1f00415 ]---

--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.37-rc7-without.dmesg"

[    2.034921] b43-pci-bridge 0000:02:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    2.034939] b43-pci-bridge 0000:02:00.0: setting latency timer to 64
...
[    8.363363] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
[    8.377768] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input7
[    8.563088] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    8.564034] Registered led device: b43-phy0::tx
[    8.564073] Registered led device: b43-phy0::rx
[    8.564111] Registered led device: b43-phy0::radio
[    8.564115] Calling hwrng_register
[    8.564121] Pid: 471, comm: modprobe Not tainted 2.6.37-rc7-self #4
[    8.564124] Call Trace:
[    8.564137]  [<f8fa83ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[    8.564176]  [<f8fe0b23>] ? b43_probe+0x9e5/0xa85 [b43]
[    8.564189]  [<c11047aa>] ? sysfs_find_dirent+0x25/0x36
[    8.564195]  [<c11049dc>] ? __sysfs_add_one+0x25/0x72
[    8.564202]  [<c1104fb5>] ? sysfs_addrm_finish+0x13/0x8f
[    8.564208]  [<c11050e6>] ? sysfs_add_one+0x10/0xc7
[    8.564215]  [<c1105506>] ? sysfs_do_create_link+0x34/0x150
[    8.564246]  [<f859948d>] ? ssb_device_probe+0x2c/0x47 [ssb]
[    8.564258]  [<c11d9954>] ? driver_probe_device+0x8c/0x110
[    8.564264]  [<c11d9a18>] ? __driver_attach+0x40/0x5b
[    8.564273]  [<c11d91b5>] ? bus_for_each_dev+0x37/0x5f
[    8.564281]  [<c11d980a>] ? driver_attach+0x11/0x13
[    8.564287]  [<c11d99d8>] ? __driver_attach+0x0/0x5b
[    8.564293]  [<c11d9530>] ? bus_add_driver+0x87/0x1bb
[    8.564299]  [<c1148c2a>] ? kset_find_obj_hinted+0x12/0x7d
[    8.564317]  [<f9000000>] ? b43_init+0x0/0x62 [b43]
[    8.564323]  [<c11d9c34>] ? driver_register+0x7a/0xd9
[    8.564339]  [<f9000000>] ? b43_init+0x0/0x62 [b43]
[    8.564355]  [<f9000026>] ? b43_init+0x26/0x62 [b43]
[    8.564362]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[    8.564372]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[    8.564392]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
[    8.564502] Broadcom 43xx driver loaded [ Features: PMLS, Firmware-ID: FW13 ]
...
[   11.786812] VIA RNG detected
[   11.786817] Calling hwrng_register
[   11.786823] Pid: 776, comm: modprobe Not tainted 2.6.37-rc7-self #4
[   11.786827] Call Trace:
[   11.786840]  [<f8fa83ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   11.786848]  [<f9202023>] ? mod_init+0x23/0x3b [via_rng]
[   11.786858]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   11.786868]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   11.786899]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
...
[   24.596098] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
...
[   30.136244] b43-pci-bridge 0000:02:00.0: PCI: Disallowing DAC for device
[   30.136257] b43-phy0: DMA mask fallback from 64-bit to 32-bit
[   30.158623] ADDRCONF(NETDEV_UP): wlan0: link is not ready

--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.37-rc7-without+modprobe.dmesg"
Content-Transfer-Encoding: quoted-printable

[    2.032560] b43-pci-bridge 0000:02:00.0: PCI INT A -> GSI 28 (level, low=
) -> IRQ 28
[    2.032577] b43-pci-bridge 0000:02:00.0: setting latency timer to 64
=2E..
[   11.649390] VIA RNG detected
[   11.649395] Calling hwrng_register
[   11.649401] Pid: 745, comm: modprobe Not tainted 2.6.37-rc7-self #4
[   11.649405] Call Trace:
[   11.649415]  [<f90b13ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   11.649423]  [<f90be023>] ? mod_init+0x23/0x3b [via_rng]
[   11.649433]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   11.649443]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   11.649470]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
=2E..
[   92.861343] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
[   92.986756] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   92.993027] Registered led device: b43-phy0::tx
[   92.993696] Registered led device: b43-phy0::rx
[   92.994271] Registered led device: b43-phy0::radio
[   92.994278] Calling hwrng_register
[   92.994284] Pid: 2622, comm: modprobe Not tainted 2.6.37-rc7-self #4
[   92.994287] Call Trace:
[   92.994312]  [<f90b13ac>] ? hwrng_register+0x2c/0x14d [rng_core]
[   92.994351]  [<f84b4b23>] ? b43_probe+0x9e5/0xa85 [b43]
[   92.994364]  [<c11047aa>] ? sysfs_find_dirent+0x25/0x36
[   92.994370]  [<c11049dc>] ? __sysfs_add_one+0x25/0x72
[   92.994377]  [<c1104fb5>] ? sysfs_addrm_finish+0x13/0x8f
[   92.994383]  [<c11050e6>] ? sysfs_add_one+0x10/0xc7
[   92.994390]  [<c1105506>] ? sysfs_do_create_link+0x34/0x150
[   92.994432]  [<f850348d>] ? ssb_device_probe+0x2c/0x47 [ssb]
[   92.994445]  [<c11d9954>] ? driver_probe_device+0x8c/0x110
[   92.994451]  [<c11d9a18>] ? __driver_attach+0x40/0x5b
[   92.994464]  [<c11d91b5>] ? bus_for_each_dev+0x37/0x5f
[   92.994476]  [<c11d980a>] ? driver_attach+0x11/0x13
[   92.994482]  [<c11d99d8>] ? __driver_attach+0x0/0x5b
[   92.994488]  [<c11d9530>] ? bus_add_driver+0x87/0x1bb
[   92.994495]  [<c1148c2a>] ? kset_find_obj_hinted+0x12/0x7d
[   92.994512]  [<f8393000>] ? b43_init+0x0/0x62 [b43]
[   92.994518]  [<c11d9c34>] ? driver_register+0x7a/0xd9
[   92.994534]  [<f8393000>] ? b43_init+0x0/0x62 [b43]
[   92.994549]  [<f8393026>] ? b43_init+0x26/0x62 [b43]
[   92.994556]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   92.994565]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   92.994608]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
[   92.994627] BUG: unable to handle kernel paging request at 44b3442d
[   92.994632] IP: [<f90b13df>] hwrng_register+0x5f/0x14d [rng_core]
[   92.994642] *pdpt =3D 0000000033c0e001 *pde =3D 0000000000000000=20
[   92.994648] Oops: 0000 [#1] SMP=20
[   92.994652] last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:0=
2:00.0/ssb0:0/leds/b43-phy0::radio/uevent
[   92.994658] Modules linked in: arc4 ecb b43(+) mac80211 cfg80211 uinput =
sco bnep rfcomm l2cap crc16 via drm parport_pc ppdev lp parport sbs sbshc p=
ower_meter pci_slot hed fan container acpi_cpufreq mperf cpufreq_conservati=
ve cpufreq_userspace cpufreq_stats cpufreq_powersave dm_crypt fuse loop eep=
rom via_cputemp i2c_dev nvram padlock_aes aes_i586 aes_generic padlock_sha =
sha256_generic sha1_generic via_rng rng_core msr cpuid snd_hda_codec_realte=
k snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm s=
nd_seq_midi snd_rawmidi snd_seq_midi_event joydev uvcvideo snd_seq btusb vi=
deodev snd_timer bluetooth tpm_tis tpm snd_seq_device v4l1_compat ideapad_l=
aptop tpm_bios battery ac i2c_viapro snd rfkill power_supply soundcore snd_=
page_alloc processor psmouse evdev video i2c_core serio_raw pcspkr shpchp w=
mi output button pci_hotplug ext3 jbd mbcache raid10 raid456 async_raid6_re=
cov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multi=
path linear md_mod dm_mirror dm_region_hash dm_log dm_mod btrfs zlib_deflat=
e crc32c libcrc32c sd_mod crc_t10dif ata_generic uhci_hcd pata_via ehci_hcd=
 libata ssb tg3 usbcore scsi_mod via_sdmmc pcmcia mmc_core pcmcia_core libp=
hy thermal thermal_sys nls_base [last unloaded: scsi_wait_scan]
[   92.994792]=20
[   92.994798] Pid: 2622, comm: modprobe Not tainted 2.6.37-rc7-self #4 Mou=
tCook/20021,2959
[   92.994803] EIP: 0060:[<f90b13df>] EFLAGS: 00010206 CPU: 0
[   92.994810] EIP is at hwrng_register+0x5f/0x14d [rng_core]
[   92.994815] EAX: 00000001 EBX: f7143010 ECX: f90b1589 EDX: f7143035
[   92.994819] ESI: 44b34411 EDI: f7142fc0 EBP: 00000000 ESP: f3c17e04
[   92.994824]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   92.994829] Process modprobe (pid: 2622, ti=3Df3c16000 task=3Df3cba080 t=
ask.ti=3Df3c16000)
[   92.994833] Stack:
[   92.994836]  f7143035 f3caec00 f84b4b23 f7143035 0000001f f84cae30 f84ca=
9f0 f3ced0d8
[   92.994844]  2206017f f6d31c64 6161d6ee f4fa9f01 f3ced0d0 c11047aa f3d21=
210 f3c17e05
[   92.994853]  f3d21210 c11049dc c1104fb5 f4fa9e00 c11050e6 00000000 00004=
61c f6d31c00
[   92.994862] Call Trace:
[   92.994879]  [<f84b4b23>] ? b43_probe+0x9e5/0xa85 [b43]
[   92.994886]  [<c11047aa>] ? sysfs_find_dirent+0x25/0x36
[   92.994892]  [<c11049dc>] ? __sysfs_add_one+0x25/0x72
[   92.994898]  [<c1104fb5>] ? sysfs_addrm_finish+0x13/0x8f
[   92.994904]  [<c11050e6>] ? sysfs_add_one+0x10/0xc7
[   92.994910]  [<c1105506>] ? sysfs_do_create_link+0x34/0x150
[   92.994929]  [<f850348d>] ? ssb_device_probe+0x2c/0x47 [ssb]
[   92.994936]  [<c11d9954>] ? driver_probe_device+0x8c/0x110
[   92.994942]  [<c11d9a18>] ? __driver_attach+0x40/0x5b
[   92.994954]  [<c11d91b5>] ? bus_for_each_dev+0x37/0x5f
[   92.994967]  [<c11d980a>] ? driver_attach+0x11/0x13
[   92.994972]  [<c11d99d8>] ? __driver_attach+0x0/0x5b
[   92.994978]  [<c11d9530>] ? bus_add_driver+0x87/0x1bb
[   92.994984]  [<c1148c2a>] ? kset_find_obj_hinted+0x12/0x7d
[   92.995000]  [<f8393000>] ? b43_init+0x0/0x62 [b43]
[   92.995005]  [<c11d9c34>] ? driver_register+0x7a/0xd9
[   92.995021]  [<f8393000>] ? b43_init+0x0/0x62 [b43]
[   92.995036]  [<f8393026>] ? b43_init+0x26/0x62 [b43]
[   92.995042]  [<c1003069>] ? do_one_initcall+0x68/0x10f
[   92.995048]  [<c105f0d3>] ? sys_init_module+0xca5/0xe36
[   92.995086]  [<c1008b1f>] ? sysenter_do_call+0x12/0x28
[   92.995090] Code: 1e c8 8b 35 1c 16 0b f9 59 83 ee 1c eb 1d 8b 13 8b 06 =
e8 84 d6 09 c8 85 c0 75 0a be ef ff ff ff e9 d3 00 00 00 8b 76 1c 83 ee 1c =
<8b> 46 1c 0f 18 00 90 81 fe 00 16 0b f9 75 d4 83 3d 2c 18 0b f9=20
[   92.995132] EIP: [<f90b13df>] hwrng_register+0x5f/0x14d [rng_core] SS:ES=
P 0068:f3c17e04
[   92.995143] CR2: 0000000044b3442d
[   92.995148] ---[ end trace 66162330d52e4fa4 ]---
[   93.444122] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:3=
2:10)
[   98.960305] b43-pci-bridge 0000:02:00.0: PCI: Disallowing DAC for device
[   98.960316] b43-phy0: DMA mask fallback from 64-bit to 32-bit
[   98.990133] ADDRCONF(NETDEV_UP): wlan0: link is not ready

--6WlEvdN9Dv0WHSBl--

--phCU5ROyZO6kBE05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTRzvYhS+e2HeSPbpAQLKWQf/W5+9fW+UWNnu9HKRUxbit3tuAhgjl2UA
ezK272hxbVXwfgO85qkjIDk9sNwzJi7EmDcQVesrmpaA+hDkWbTPPnwV8PvjLmOg
0UsvIuIEu0bCL6s2plbPESVvpTf7ul3HRq7PN6dNHzmifceH59AxX5YeimT/nD4F
nOUeRj+rQFsWOYG5o7jBX8n0HIlpFpchZnTTOur1+2UsKjqzZqxJrkhihLolnUjE
J/W2SViEq/G16w/dlCEKOXR/TsNZXQBJGIpMfp4ddPRpLdTB4NflEX9wJs2b4z2q
htFJ/htNHFNcP5qdj+y1RFxgwmFOeNKU31rogcykzZgERanpVRZw/Q==
=c2DE
-----END PGP SIGNATURE-----

--phCU5ROyZO6kBE05--
