Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab0LMLsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:48:12 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:44413 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0LMLsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:48:11 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 06:48:10 EST
Date: Mon, 13 Dec 2010 12:42:02 +0100
From: Nico Schottelius <nico-kernel@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: filesystem: suspend issue / Trace 2.6.37-rc5-00062-g6313e3c
Message-ID: <20101213114202.GB30023@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.37-rc5-00062-g6313e3c x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Guys,

trying to suspend (after several times) gives me the following error:


[168459.057712] ------------[ cut here ]------------
[168459.057720] WARNING: at fs/dcache.c:1984 prepend_path+0x10c/0x122()
[168459.057722] Hardware name: 3626A14
[168459.057723] Root dentry has weird name <>
[168459.057724] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss su=
nrpc cdc_ether usbnet cdc_acm sr_mod cdrom nls_utf8 hfsplus nls_iso8859_1 n=
ls_cp437 vfat fat fbcon tileblit font bitblit fbcon_rotate fbcon_cw fbcon_u=
d fbcon_ccw softcursor ipv6 usb_storage usb_libusual uas uvcvideo videodev =
v4l2_compat_ioctl32 btusb bluetooth sha256_generic aesni_intel cryptd aes_x=
86_64 aes_generic cbc dm_crypt dm_mod arc4 ecb i915 iwlagn drm_kms_helper d=
rm iwlcore snd_hda_codec_hdmi snd_hda_codec_conexant mac80211 kvm_intel fb =
snd_pcm_oss thinkpad_acpi snd_mixer_oss fbdev cfg80211 i2c_algo_bit cfbcopy=
area ehci_hcd tpm_tis kvm i2c_i801 i2c_core snd_hda_intel sg usbcore joydev=
 mac_hid snd_hda_codec e1000e tpm snd_hwdep hwmon wmi snd_pcm nvram snd_tim=
er rfkill tpm_bios pcspkr snd video intel_ips soundcore snd_page_alloc inte=
l_agp intel_gtt backlight output cfbimgblt cfbfillrect rtc_cmos rtc_core rt=
c_lib
[168459.057793] Pid: 561, comm: lsof Not tainted 2.6.37-rc5-00062-g6313e3c =
#51
[168459.057794] Call Trace:
[168459.057802]  [<ffffffff81038ded>] warn_slowpath_common+0x80/0x98
[168459.057805]  [<ffffffff81038e99>] warn_slowpath_fmt+0x41/0x43
[168459.057808]  [<ffffffff810dc271>] prepend_path+0x10c/0x122
[168459.057810]  [<ffffffff810dc2f1>] path_with_deleted+0x6a/0x73
[168459.057813]  [<ffffffff810dc3a8>] d_path+0xae/0xdc
[168459.057816]  [<ffffffff81112dba>] proc_pid_readlink+0x6e/0xc4
[168459.057821]  [<ffffffff810cf93f>] sys_readlinkat+0x71/0x93
[168459.057823]  [<ffffffff810cf977>] sys_readlink+0x16/0x18
[168459.057827]  [<ffffffff8100293b>] system_call_fastpath+0x16/0x1b
[168459.057829] ---[ end trace 6476685f8c0cd3a4 ]---


I did a umount -lf /path/to/nfs before, because I suspended and resumed
with an nfs mount.

Not sure whether this is the reason, but now I'm unable to susepnd.

Cheers,

Nico


--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk0GBooACgkQ19zI5DGHffCfMwCdFDTkB7egZfKpqWL14hgRKOyK
BGoAnjJGSjsXE4woTvzEfJ6ouGU18KY3
=jP3k
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
