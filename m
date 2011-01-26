Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1AZPXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:23:20 -0500
Received: from skl2.ukl.uni-freiburg.de ([193.196.199.2]:40236 "EHLO
	relay2.uniklinik-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab1AZPXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:23:19 -0500
X-Greylist: delayed 1690 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2011 10:23:18 EST
Subject: Linux 2.6.37 x86 ncpfs regression: kernel BUG at
 include/linux/dcache.h:340 with >1366 files in directory
From: "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-dAwL1q8jC0DASK1ZUknt"
Date: Wed, 26 Jan 2011 15:55:00 +0100
Message-ID: <1296053700.2684.19.camel@pst15.ukl.uni-freiburg.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
X-NAI-Spam-Flag: NO
X-NAI-Spam-Level: *
X-NAI-Spam-Threshold: 5
X-NAI-Spam-Score: 1.2
X-NAI-Spam-Report: 3 Rules triggered
	*  1 -- FROM_ALIAS_QUOTES_EVOL_2
	*  0.2 -- RCVD_FROM_BY_ENVFRM_1_AT_2
	*  0 -- RV3749
X-NAI-Spam-Version: 2.2.0.9286 : core <3749> : streams <589540> : uri
 <788129>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dAwL1q8jC0DASK1ZUknt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On 2.6.37 I get the following when listing one of our Novell directories
containing 9499 files (no subdirs; note that this works fine on
2.6.36.x):

kernel: kernel BUG at include/linux/dcache.h:340!
kernel: invalid opcode: 0000 [#1] SMP=20
kernel: last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_f=
req
kernel: Modules linked in: nls_cp437 nls_iso8859_1 ncpfs coretemp cpufreq_o=
ndemand nfs lockd nfs_acl auth_rpcgss sunrpc ipv6 autofs4 snd_seq_oss snd_s=
eq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ext3 jbd mbc=
ache ext2 dm_crypt dm_mod crypto_blkcipher crypto_algapi fuse vboxnetflt vb=
oxdrv fbcon font bitblit softcursor usbhid usb_storage uas snd_hda_codec_an=
alog radeon ttm drm_kms_helper drm sr_mod snd_hda_intel psmouse cdrom snd_h=
da_codec snd_pcm snd_timer sg uhci_hcd i2c_algo_bit cfbcopyarea cfbimgblt c=
fbfillrect parport_pc parport ehci_hcd dcdbas i2c_i801 snd soundcore snd_pa=
ge_alloc usbcore
kernel:=20
kernel: Pid: 4226, comm: ls Not tainted 2.6.37-gentoo #3 0GM819/OptiPlex 75=
5                =20
kernel: EIP: 0060:[<c108e2b6>] EFLAGS: 00010246 CPU: 1
kernel: EIP is at d_validate+0x6c/0x99
kernel: EAX: 00000000 EBX: f14952a8 ECX: 00000011 EDX: f14952a8
kernel: ESI: f5d675c0 EDI: f21a2aa0 EBP: 0272e622 ESP: f1a45ef0
kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
kernel: Process ls (pid: 4226, ti=3Df1a44000 task=3Df3793ba0 task.ti=3Df1a4=
4000)
kernel: Stack:
kernel: 00000011 0001ffff f14952a8 00000000 00000000 f1e37300 f813f6a6 b933=
9067
kernel: f21a2aa0 f75228c0 00000555 ff8a0000 f21ea7b8 f1a45f90 c108b804 f21e=
a870
kernel: f21a2adc 4d4028b4 0000c2cd 00000556 00000001 f7515620 ff9d7000 0000=
0557
kernel: Call Trace:
kernel: [<f813f6a6>] ? ncp_readdir+0x246/0x544 [ncpfs]
kernel: [<c108b804>] ? filldir64+0x0/0xcb
kernel: [<c108b804>] ? filldir64+0x0/0xcb
kernel: [<c108ba9b>] ? vfs_readdir+0x5c/0x80
kernel: [<c108bc11>] ? sys_getdents64+0x66/0xa5
kernel: [<c100270c>] ? sysenter_do_call+0x12/0x22
kernel: Code: 4f 81 f2 01 00 37 9e c1 ea 06 8d 2c 2a 89 e8 35 01 00 37 9e d=
3 e8 31 e8 23 44 24 04 8d 04 86 eb 11 85 db 74 22 8b 03 85 c0 75 02 <0f> 0b=
 f0 ff 03 eb 15 8b 00 85 c0 74 16 8b 10 0f 18 02 90 8d 50=20
kernel: EIP: [<c108e2b6>] d_validate+0x6c/0x99 SS:ESP 0068:f1a45ef0
kernel: ---[ end trace 4a1258c426b4363e ]---

I then created empty files in an empty directory on the server using the
attached script. For me, files up to 1363 could be handled without crash
while the addition of one more file showed the crash at the next ls.
I.e., the directory could have no more than 1366 entries including the
script, '.' and '..'.

Steps to reproduce:
cd /path/to/mounted/ncp/dir
mkdir tst; cd tst
cp ~/Mail/create_files .
bash create_files # Will create 2000 empty files 0001-2000 to be on the saf=
e side ;-)
ls

I assumed that the changes to ncpfs in 2.6.37 caused this, but reverting
them did not solve the problem. Turning off preemption and group
scheduling did not help either. So I'm lost and my spare time is running
out, thought I'd report it nonetheless.

Thanks for your time,
Bernd

--=-dAwL1q8jC0DASK1ZUknt
Content-Type: application/x-shellscript; name="create_files"
Content-Disposition: attachment; filename="create_files"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCmk9MQp3aGlsZSBbWyAkaSAtbGUgMjAwMCBdXTsgZG8KIHByaW50ZiAtdiBv
ICIlMDRkIiAkaQogZWNobyAkbwogdG91Y2ggJG8KIGxldCBpPSRpKzEKZG9uZQo=


--=-dAwL1q8jC0DASK1ZUknt--
