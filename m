Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab0KANZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:25:05 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:33963 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab0KANZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:25:03 -0400
Message-ID: <4CCEBFAC.1000809@web.de>
Date: Mon, 01 Nov 2010 14:25:00 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: kvm <kvm@vger.kernel.org>, Sheng Yang <sheng@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash on kvm_iommu_map_pages
References: <4CCEB7CF.8030207@web.de> <4CCEB946.7070103@web.de> <20101101132127.GF20959@amd.com>
In-Reply-To: <20101101132127.GF20959@amd.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCDD30A253397162F3C767FCA"
X-Provags-ID: V01U2FsdGVkX1/S/Iw3H+00uOukblftepKFjd5nl3xZhv9Q7fHY
	1QxLXyGI7U1pRqlXMLHtGDEtxvgTRSADXESvsKjan+rQn2Ez6m
	m8PWnT4vs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCDD30A253397162F3C767FCA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.11.2010 14:21, Roedel, Joerg wrote:
> The registers rax and rbx contain non-canonical addresses (if
> interpreted as pointers). The instruction where this happens is a mov s=
o
> I guess that the #GP is because of an non-canonical address.
> Can you find out the code-line where this happens and the exact
> assembler instruction? (haven't managed to decode the registers used).

In pfn_to_dma_pte, line 710:

                if (!dma_pte_present(pte)) {
ffffffff8121de8c:       f6 03 03                testb  $0x3,(%rbx)
ffffffff8121de8f:       0f 85 d8 00 00 00       jne    ffffffff8121df6d <=
pfn_to_dma_pte+0x154>

The first instruction raises the fault.

Jan

>=20
> 	Joerg
>=20
> On Mon, Nov 01, 2010 at 08:57:42AM -0400, Jan Kiszka wrote:
>> [ Forgot to CC LKML - maybe it's not KVM-specific.
>>   BTW, is anyone actually using current KVM device assigment on
>>   Intel? I'm starting to believe that can only very few lucky people..=
=2E
>> ]
>>
>> Am 01.11.2010 13:51, Jan Kiszka wrote:
>>> Hi again,
>>>
>>> OK, I swapped those two lines in intel_iommu_attach_device [1], fixed=

>>> another warning in the wbinvd emulation, but now I'm about to give up=
=2E
>>> This is freaky MMU stuff:
>>>
>>>
>>> general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>> last sysfs file: /sys/devices/pci0000:00/0000:00:1a.0/device
>>> CPU 1=20
>>> Modules linked in: kvm_intel kvm bluetooth snd_pcm_oss snd_mixer_oss =
snd_seq snd_seq_device edd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 i=
p6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6=
table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_de=
frag_ipv4 ip_tables ip6table_filter ip6_tables x_tables ipv6 fuse loop ma=
c80211 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_cod=
ec ath9k_common ath9k_hw snd_hwdep snd_pcm snd_timer snd ath pcmcia cfg80=
211 sdhci_pci tpm_infineon sdhci yenta_socket firewire_ohci tpm_tis mmc_c=
ore soundcore e1000e sg pcmcia_rsrc tpm firewire_core iTCO_wdt video snd_=
page_alloc pcmcia_core i2c_i801 rfkill tpm_bios intel_agp output fujitsu_=
laptop iTCO_vendor_support i2c_core serio_raw pcspkr led_class joydev crc=
_itu_t button battery intel_gtt ac ext4 mbcache jbd2 crc16 sha256_generic=
 aes_x86_64 aes_generic cbc dm_crypt linear sd_mod crc_t10dif dm_snapshot=
 dm_mod fan processor ahci libahci ata_ge
ne
>> ri
>>> c liba
>>> ta scsi_mod thermal thermal_sys hwmon
>>> Nov  1 13:19:11 mchn199C kernel:
>>> Pid: 2248, comm: qemu-system-x86 Not tainted 2.6.36+ #12 FJNB211W/CEL=
SIUS H700
>>> RIP: 0010:[<ffffffff8121de8c>]  [<ffffffff8121de8c>] pfn_to_dma_pte+0=
x73/0x190
>>> RSP: 0018:ffff8800bd4bdb68  EFLAGS: 00010202
>>> RAX: ffff1000bd4fe000 RBX: ffff1000bd4fec00 RCX: 0000000000000009
>>> RDX: 0000000000000180 RSI: ffff88012a940938 RDI: 0000000000000202
>>> RBP: ffff8800bd4bdba8 R08: ffffea00025ac2a0 R09: 0000000000000004
>>> R10: 0000000000000001 R11: 0000000000000000 R12: ffff880128dfee00
>>> R13: 0000000000000002 R14: 00000000000f0000 R15: 0000000000000009
>>> FS:  00007f4990d33710(0000) GS:ffff8800be680000(0000) knlGS:000000000=
0000000
>>> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>>> CR2: 0000000001408000 CR3: 00000000bd7db000 CR4: 00000000000026e0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Process qemu-system-x86 (pid: 2248, threadinfo ffff8800bd4bc000, task=
 ffff88012a940000)
>>> Stack:
>>> ffff8800bd4bdb88 ffff8800ac378000 00000000000000d2 00000000000f0000
>>> <0> ffff8800bd4bdce8 ffff8800ac2fc000 0000000000000003 00000000000f00=
01
>>> <0> ffff8800bd4bdbb8 ffffffff8121dfbe ffff8800bd4bdbc8 ffffffff812a95=
73
>>> Call Trace:
>>> [<ffffffff8121dfbe>] intel_iommu_iova_to_phys+0x15/0x2a
>>> [<ffffffff812a9573>] iommu_iova_to_phys+0x13/0x15
>>> [<ffffffffa04e91d0>] kvm_iommu_map_pages+0x77/0x194 [kvm]
>>> [<ffffffff8111404d>] ? __vmalloc_node+0x86/0x9b
>>> [<ffffffffa04e30e2>] __kvm_set_memory_region+0x4e5/0x787 [kvm]
>>> [<ffffffff81081ee8>] ? mark_held_locks+0x50/0x72
>>> [<ffffffff8137c983>] ? mutex_lock_nested+0x325/0x34d
>>> [<ffffffffa04e33bb>] kvm_set_memory_region+0x37/0x50 [kvm]
>>> [<ffffffffa04e4c15>] kvm_vm_ioctl_set_memory_region+0x18/0x1a [kvm]
>>> [<ffffffffa04e4e44>] kvm_vm_ioctl+0x22d/0x3b1 [kvm]
>>> [<ffffffff811355aa>] ? fget_light+0x17b/0x31f
>>> [<ffffffff81143bd7>] do_vfs_ioctl+0x4c6/0x507
>>> [<ffffffff81135732>] ? fget_light+0x303/0x31f
>>> [<ffffffff811355aa>] ? fget_light+0x17b/0x31f
>>> [<ffffffff8137ebb9>] ? retint_swapgs+0x13/0x1b
>>> [<ffffffff81143c6e>] sys_ioctl+0x56/0x7c
>>> [<ffffffff81002df2>] system_call_fastpath+0x16/0x1b
>>> Code: c7 31 db 47 8d 3c ff e9 1d 01 00 00 0f 0b 4c 89 f2 44 88 f9 48 =
d3 ea 81 e2 ff 01 00 00 41 83 fd 01 48 8d 1c d0 0f 84 0b 01 00 00 <f6> 03=
 03 0f 85 d8 00 00 00 41 8b 44 24 04 85 c0 79 08 65 8b 04=20
>>> RIP  [<ffffffff8121de8c>] pfn_to_dma_pte+0x73/0x190
>>> RSP <ffff8800bd4bdb68>
>>>
>>>
>>> Can anyone parse this? Is it Intel-specific or a generic issue? The
>>> kernel is current kvm.git + unrelated patch + [1].
>>>
>>> Jan
>>>
>>> [1] http://thread.gmane.org/gmane.comp.emulators.kvm.devel/61923
>>>
>>
>=20
>=20
>=20



--------------enigCDD30A253397162F3C767FCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzOv6wACgkQitSsb3rl5xS7qQCfVLjVgNISg2qDKxQtZZUGpxzs
lPYAoIBwkIAaKjQ+nJ/MsasdUTk+jCF+
=MW8s
-----END PGP SIGNATURE-----

--------------enigCDD30A253397162F3C767FCA--
