Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab0L3WtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 17:49:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38932 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0L3WtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 17:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sqzcL+ORe4KWPYx2PpmcNFEdmcm89/JKnoqLvoxkxNKQM3dVSfp1fD3NuKi5iRkv5k
         XgkuLYqsenho3kLij/eJrlUhA23ftn3umv3+B8a1Oka5Pfebyqzll3naIqWhbviIT1SJ
         yJWqqfjFUStCo3jLimKsK0tPuVHKUxJmcu9iE=
Message-ID: <4D1D0C61.9050800@lwfinger.net>
Date: Thu, 30 Dec 2010 16:49:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
References: <4D1A8200.4010609@lwfinger.net> <20101229195440.GD5838@darkside.kls.lan> <4D1BD2B0.4020101@lwfinger.net> <20101230012003.GA2665@darkside.kls.lan> <4D1BF056.3060909@lwfinger.net> <20101230143406.GA23219@darkside.kls.lan> <4D1CD161.4040107@lwfinger.net> <20101230204522.GC23219@darkside.kls.lan>
In-Reply-To: <20101230204522.GC23219@darkside.kls.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the two listed maintainers for hardware randon-number generators and
dropped the wireless and b43 lists.

Matt and Herbert:

There is a regression in 2.6.37-rcX relative to 2.6.36. The problem shows as the
following kernel BUG:

[   30.313362] BUG: unable to handle kernel paging request at 60870667
[   30.313372] IP: [<f8f4e3df>] hwrng_register+0x5f/0x14d [rng_core]
[   30.313391] *pdpt = 0000000036c34001 *pde = 0000000000000000
[   30.313403] Oops: 0000 [#1] SMP
[   30.313411] last sysfs file: /sys/module/bluetooth/initstate
[   30.313420] Modules linked in: l2cap crc16 parport_pc ppdev lp parport sbs
sbshc power_meter pci_slot hed fan container acpi_cpufreq mperf
cpufreq_conservative cpufreq_userspace cpufreq_stats cpufreq_powersave dm_crypt
fuse loop eeprom via_cputemp i2c_dev nvram padlock_aes aes_i586 aes_generic
padlock_sha sha256_generic sha1_generic via_rng msr cpuid snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm ecb
snd_seq_midi snd_rawmidi snd_seq_midi_event b43 snd_seq snd_timer rng_core
uvcvideo video snd_seq_device joydev mac80211 videodev ideapad_laptop output
btusb battery processor bluetooth tpm_tis snd v4l1_compat ac tpm wmi
power_supply cfg80211 soundcore snd_page_alloc tpm_bios rfkill button shpchp
pcspkr i2c_viapro evdev i2c_core psmouse serio_raw pci_hotplug ext3 jbd mbcache
raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
async_tx raid1 raid0 multipath linear md_mod dm_mirror dm_region_hash dm_log
dm_mod btrfs zlib_deflate crc32c libcrc32c sd_mod crc_t10dif ata_generic
pata_via libata uhci_hcd ssb ehci_hcd tg3 via_sdmmc usbcore scsi_mod pcmcia
thermal mmc_core pcmcia_core libphy thermal_sys nls_base [last unloaded:
scsi_wait_scan]
[   30.313670]
[   30.313681] Pid: 1742, comm: NetworkManager Not tainted 2.6.37-rc7-self #3
MoutCook/20021,2959
[   30.313692] EIP: 0060:[<f8f4e3df>] EFLAGS: 00010216 CPU: 0
[   30.313706] EIP is at hwrng_register+0x5f/0x14d [rng_core]
[   30.313715] EAX: 00000001 EBX: f4f13010 ECX: f8f4e589 EDX: f4f13035
[   30.313725] ESI: 6087064b EDI: 00000000 EBP: 00000036 ESP: f4fe7b54
[   30.313735]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   30.313745] Process NetworkManager (pid: 1742, ti=f4fe6000 task=f6d2e8a0
task.ti=f4fe6000)
[   30.313753] Stack:
[   30.313757]  f4f12fc0 f4f13035 f8fab870 f4f13035 0000001f f8fc10bb f8fc09f0
f6dcce20
[   30.313775]  0000000f f6dcac00 f6dcac00 f6f27400 f4f122c0 f4f10240 f4f12fc8
f8fabd67
[   30.313793]  f8c273da f4f122c0 f6ec0400 f8e9ee48 f6ec0000 f8e8e889 f8e8de7a
00000000
[   30.313810] Call Trace:
[   30.313835]  [<f8fab870>] ? b43_wireless_core_init+0xd0c/0xdd6 [b43]
[   30.313863]  [<f8fabd67>] ? b43_op_start+0xf8/0x142 [b43]
[   30.313889]  [<f8c273da>] ? cfg80211_netdev_notifier_call+0x342/0x355 [cfg80211]
[   30.313926]  [<f8e8e889>] ? ieee80211_do_open+0xed/0x45f [mac80211]
[   30.313958]  [<f8e8de7a>] ? ieee80211_check_concurrent_iface+0x1c/0x135
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
[   30.314292] Code: 34 c8 8b 35 1c e6 f4 f8 59 83 ee 1c eb 1d 8b 13 8b 06 e8 84
06 20 c8 85 c0 75 0a be ef ff ff ff e9 d3 00 00 00 8b 76 1c 83 ee 1c <8b> 46 1c
0f 18 00 90 81 fe 00 e6 f4 f8 75 d4 83 3d 2c e8 f4 f8
[   30.314376] EIP: [<f8f4e3df>] hwrng_register+0x5f/0x14d [rng_core] SS:ESP
0068:f4fe7b54
[   30.314395] CR2: 0000000060870667
[   30.314404] ---[ end trace f498f4a4e1f00415 ]---

Mario's box with this fault has two RNG devices - b43 and the one provided by
via-rng. Experimentation has shown that if b43 is registered first, then there
is no problem; however if via-rng is first, then the above BUG is triggered when
b43 registers its hardware rng. This problem is a regression in that one of the
changes in 2.6.37 has b43 registering its rng later in the startup sequence.

Are you the correct people to contact? If not, who is maintaining via-rng? I did
not find any entries in MAINTAINERS.

Do you see any problems in the code in drivers/net/wireless/b43/main.c or
drivers/char/hw_random/via-rng.c. As the latter seems to make b43 fail, I am
suspecting via-rng, but I have no proof.

Thanks,

Larry



On 12/30/2010 02:45 PM, Mario 'BitKoenig' Holbe wrote:
> On Thu, Dec 30, 2010 at 12:37:21PM -0600, Larry Finger wrote:
>> The head of the rng_list is damaged. It is initialized at compile time and
>> should be OK. To help discover the order in which hwrng_register() is called,
>> apply the attached patch. Run it once with commit 84c164a34ffe67908a installed,
>> and once with it reverted.
> 
> All right, 3 dmesg excerpts attached...
> 2.6.37-rc7-vanilla.dmesg:
> 	2.6.37-rc7 vanilla (i.e. with 84c164a34ffe67908a), crashing
> 	via-rng is registered first, b43-rng second
> 2.6.37-rc7-without.dmesg:
> 	2.6.37-rc7 with 84c164a34ffe67908a reverted, not crashing
> 	b43-rng is registered first, via-rng second
> 2.6.37-rc7-without+modprobe.dmesg:
> 	2.6.37-rc7 with 84c164a34ffe67908a reverted, b43 blacklisted and
> 	manually modprobed after via-rng, crashing
> 	via-rng is registered first, b43-rng second
> 
> Seems like the crash shows up when b43-rng is registered second, but not
> when via-rng is registered second.
> Btw.: `cat rng_available' does also not crash when via-rng is registered
> second.
> 
> 
> regards
>    Mario

