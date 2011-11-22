Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab1KVPv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:51:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39107 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab1KVPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:51:55 -0500
Date: Tue, 22 Nov 2011 09:51:50 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: linux-kernel@vger.kernel.org, ecryptfs@vger.kernel.org
Subject: Re: 3.2.0-rc2: kernel BUG at fs/ecryptfs/crypto.c:348! regression?
Message-ID: <20111122155149.GB6006@boyd>
References: <4ECB62F4.6060602@arndnet.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Qbvjkv9qwOGw/5Fx"
Content-Disposition: inline
In-Reply-To: <4ECB62F4.6060602@arndnet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qbvjkv9qwOGw/5Fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2011-11-22 09:53:08, Arnd Hannemann wrote:
> Hi,
>=20
> I'm regularly hitting below BUG (also with yesterdays Linus git):
> 3.1.1 is working.

Please give this patch a try:

http://article.gmane.org/gmane.comp.file-systems.ecryptfs.general/18

Here's a link directly to the patch in the eCryptfs git tree but the
link might not stay around for much longer:

http://git.kernel.org/?p=3Dlinux/kernel/git/tyhicks/ecryptfs.git;a=3Dpatch;=
h=3D45608c8eb41a6deab47876ae2679117820006d25

I plan on upstreaming this patch in the next day or two, so please let
me know whether or not it fixes your problem.

Tyler

>=20
> [  198.285682] ------------[ cut here ]------------
> [  198.285716] kernel BUG at /home/arnd/Projekte/kernel/linux-2.6/fs/ecry=
ptfs/crypto.c:348!
> [  198.285762] invalid opcode: 0000 [#1] SMP
> [  198.285789] CPU 1
> [  198.285801] Modules linked in: ip6table_filter ip6_tables bnep rfcomm =
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state=
 nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filte=
r ip_tables x_tables bridge stp llc kvm_intel kvm joydev dm_crypt arc4 qcse=
rial usb_wwan thinkpad_acpi binfmt_misc usbserial snd_hda_codec_hdmi snd_hd=
a_codec_conexant psmouse serio_raw snd_seq_midi snd_rawmidi iwlwifi snd_hda=
_intel snd_seq_midi_event snd_hda_codec snd_hwdep snd_seq snd_pcm mac80211 =
btusb bluetooth snd_seq_device intel_ips cfg80211 snd_timer snd_page_alloc =
snd mei(C) soundcore tpm_tis nvram btrfs zlib_deflate libcrc32c mxm_wmi i91=
5 firewire_ohci ahci firewire_core crc_itu_t libahci drm_kms_helper drm sdh=
ci_pci i2c_algo_bit sdhci e1000e video wmi
> [  198.286283]
> [  198.286294] Pid: 2138, comm: dconf-service Tainted: G         C   3.2.=
0-rc2-aha+ #6 LENOVO 4384GEG/4384GEG
> [  198.286352] RIP: 0010:[<ffffffff8126ff70>]  [<ffffffff8126ff70>] ecryp=
tfs_encrypt_extent+0x290/0x3a0
> [  198.286412] RSP: 0018:ffff88021e681b98  EFLAGS: 00010246
> [  198.286442] RAX: 0000000000000000 RBX: ffff88021e597aa0 RCX: 000000000=
0000000
> [  198.286482] RDX: ffff88021e681c10 RSI: 0000000000000000 RDI: ffff88021=
e681bf8
> [  198.286522] RBP: ffff88021e681c58 R08: 0000000000000000 R09: ffff88021=
e681bd8
> [  198.286562] R10: 0000000000000000 R11: 0000000090b4df2a R12: ffffea000=
81b8c00
> [  198.286602] R13: 0000000000000000 R14: 0000000000000000 R15: ffffea000=
8b0ea00
> [  198.286641] FS:  00007ff9051e67c0(0000) GS:ffff88023bc80000(0000) knlG=
S:0000000000000000
> [  198.286679] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  198.286705] CR2: 00007f991e58b150 CR3: 000000021e927000 CR4: 000000000=
00006e0
> [  198.286740] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  198.286777] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
> [  198.286814] Process dconf-service (pid: 2138, threadinfo ffff88021e680=
000, task ffff88022d1396f0)
> [  198.286856] Stack:
> [  198.286864]  0000000000001000 0000100000001000 0000000000000000 ffff88=
023bffcc08
> [  198.286888]  ffffea00081b8c02 0000100000000000 0000000000000000 000000=
0000000000
> [  198.286912]  ffffea0008b0ea02 0000100000000000 0000000000000000 000000=
0000000000
> [  198.286937] Call Trace:
> [  198.286948]  [<ffffffff8127060d>] ecryptfs_encrypt_page+0xcd/0x190
> [  198.286968]  [<ffffffff8126e6c2>] ecryptfs_writepage+0x32/0x90
> [  198.286989]  [<ffffffff81117f87>] __writepage+0x17/0x40
> [  198.287005]  [<ffffffff811185cd>] write_cache_pages+0x20d/0x460
> [  198.287023]  [<ffffffff81117f70>] ? set_page_dirty_lock+0x60/0x60
> [  198.287042]  [<ffffffff8111886a>] generic_writepages+0x4a/0x70
> [  198.287060]  [<ffffffff81119f55>] do_writepages+0x35/0x40
> [  198.287077]  [<ffffffff8110ff2b>] __filemap_fdatawrite_range+0x5b/0x60
> [  198.287097]  [<ffffffff81110e1f>] filemap_fdatawrite+0x1f/0x30
> [  198.287114]  [<ffffffff81110e65>] filemap_write_and_wait+0x35/0x60
> [  198.287132]  [<ffffffff8126b6f4>] ecryptfs_flush+0x24/0x30
> [  198.287152]  [<ffffffff8116b23f>] filp_close+0x3f/0x90
> [  198.287168]  [<ffffffff8116b342>] sys_close+0xb2/0x120
> [  198.287185]  [<ffffffff8160c2c2>] system_call_fastpath+0x16/0x1b
> [  198.287202] Code: 00 00 00 48 8b 95 50 ff ff ff 89 c1 48 c7 c6 a0 5a 8=
3 81 48 c7 c7 98 9b a0 81 31 c0 e8 3a d6 ff ff e9 38 ff ff ff e8 80 28 df f=
f <0f> 0b e8 17 dd 38 00 48 8b 95 50 ff ff ff 31 c9 31 c0 48 c7 c6
> [  198.287338] RIP  [<ffffffff8126ff70>] ecryptfs_encrypt_extent+0x290/0x=
3a0
> [  198.287360]  RSP <ffff88021e681b98>
> [  198.352203] ---[ end trace 6ba081ed2539e444 ]---
>=20
>=20
> Best regards
> Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Qbvjkv9qwOGw/5Fx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOy8UVAAoJENaSAD2qAscKu/EQAIlt4c597n7M1RffZoiuv5pI
Ayo7PPEIQmOFp/ClvZg/1y+4yB5sXrB+jlll7eGCf7LFCR5uthsMGJ+QWq82jqGt
Ajy4IvcNTtvcDOxG6UkMzy63nw9Cr9buqDUuVAJRKLo8K59qawriu4g2cMG0j5BG
ZntVE4GC6xHCaJ85bFrVubha+Svn3s80LqYPEq/PlyRob3uENZIxyVDldoJtzCzb
WPCe8XgBnnuVMGZaYh5mNbqmb0YtmfyDS09rfWphGiJWmIF1/f9xQ1DJEDoGNipE
yjQ5gKX9CC8+N5inIrMb6WnzfTtvykDb3NpOaXfW8hfwZdBgcSSPSOkNbi5jat9X
nAZwIDRqjC4vdYuehcUNy5Wqah56YN7V+wNivt5cRG4Q9VpPgAT+gEhmm6DNJCjh
FjWI9go3so2KCamDM2WEneLcCtpw1p7LkDHyeUW4wsTyuZC2OK43uH1FcpsJ0xyW
DZIgoS2wKjGZlB2S86A7KvYMh+K7+47fVbopP7l556kxBJdU8toV5Vpbi2kinBB6
/TepQRwGkp/JKeiC1kZQpwfzrMvrQyCCiDQz4RHBYC6JmrQQejOf+ygVQuqBQNLn
PF255UC1hyAeXTSn+MjQbwmZjHYGbepMk+THNFHMt5L4+GpZIg41k53elBelOy1T
KV0muG2eFG3b2OKIpUqy
=EhfO
-----END PGP SIGNATURE-----

--Qbvjkv9qwOGw/5Fx--
