Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab1IASiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 14:38:12 -0400
Received: from mail.gw90.de ([188.40.100.199]:57525 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab1IASiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 14:38:10 -0400
Subject: [PATCH] x86/PCI: use host bridge _CRS info on ASUS M2V-MX SE
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Sep 2011 20:37:44 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tJ2DsPShizY2MtRbFvJp"
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314902277.4277.1.camel@mattotaupa>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tJ2DsPShizY2MtRbFvJp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Date: Wed, 31 Aug 2011 17:07:10 +0200

Following commit 3e3da00c

        commit 3e3da00c01d050307e753fb7b3e84aefc16da0d0
        Author: Yinghai Lu <yinghai@kernel.org>
        Date:   Wed Feb 10 01:20:09 2010 -0800

            x86/pci: AMD one chain system to use pci read out res

Linux gives the following oops.

        [=E2=80=A6]
        [   41.265636] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
        [   41.680357] HDA Intel 0000:20:01.0: PCI INT A -> GSI 17 (level, =
low) -> IRQ 17
        [   41.680444] HDA Intel 0000:20:01.0: setting latency timer to 64
        [   41.680462] BUG: unable to handle kernel paging request at ffffc=
90011c08000
        [   41.680617] IP: [<ffffffffa0578402>] azx_probe+0x3ad/0x86b [snd_=
hda_intel]
        [   41.680728] PGD 13781a067 PUD 13781b067 PMD 1300ba067 PTE 800000=
fd00000173
        [   41.680956] Oops: 0009 [#1] SMP
        [   41.681098] last sysfs file: /sys/module/snd_pcm/initstate
        [   41.681159] CPU 0
        [   41.681203] Modules linked in: snd_hda_intel(+) snd_hda_codec sn=
d_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_=
midi_event tpm_tis tpm snd_seq tpm_bios psmouse parport_pc snd_timer snd_se=
q_device parport processor evdev snd i2c_viapro thermal_sys amd64_edac_mod =
k8temp i2c_core soundcore shpchp pcspkr serio_raw asus_atk0110 pci_hotplug =
edac_core button snd_page_alloc edac_mce_amd ext3 jbd mbcache sha256_generi=
c cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod raid1 md_mod usbhid hid=
 sg sd_mod crc_t10dif sr_mod cdrom ata_generic uhci_hcd sata_via pata_via l=
ibata ehci_hcd usbcore scsi_mod via_rhine mii nls_base [last unloaded: scsi=
_wait_scan]
        [   41.684180]
        [   41.684180] Pid: 1153, comm: work_for_cpu Not tainted 2.6.37-1-a=
md64 #1 M2V-MX SE/System Product Name
        [   41.684180] RIP: 0010:[<ffffffffa0578402>]  [<ffffffffa0578402>]=
 azx_probe+0x3ad/0x86b [snd_hda_intel]
        [   41.684180] RSP: 0018:ffff88013153fe50  EFLAGS: 00010286
        [   41.684180] RAX: ffffc90011c08000 RBX: ffff88013029ec00 RCX: 000=
0000000000006
        [   41.684180] RDX: 0000000000000000 RSI: 0000000000000246 RDI: 000=
0000000000246
        [   41.684180] RBP: ffff88013341d000 R08: 0000000000000000 R09: 000=
0000000000040
        [   41.684180] R10: 0000000000000286 R11: 0000000000003731 R12: fff=
f88013029c400
        [   41.684180] R13: 0000000000000000 R14: 0000000000000000 R15: fff=
f88013341d090
        [   41.684180] FS:  0000000000000000(0000) GS:ffff8800bfc00000(0000=
) knlGS:00000000f7610ab0
        [   41.684180] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
        [   41.684180] CR2: ffffc90011c08000 CR3: 0000000132f57000 CR4: 000=
00000000006f0
        [   41.684180] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
        [   41.684180] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
        [   41.684180] Process work_for_cpu (pid: 1153, threadinfo ffff8801=
3153e000, task ffff8801303c86c0)
        [   41.684180] Stack:
        [   41.684180]  0000000000000005 ffffffff8123ad65 00000000000136c0 =
ffff88013029c400
        [   41.684180]  ffff8801303c8998 ffff88013341d000 ffff88013341d090 =
ffff8801322d9dc8
        [   41.684180]  ffff88013341d208 0000000000000000 0000000000000000 =
ffffffff811ad232
        [   41.684180] Call Trace:
        [   41.684180]  [<ffffffff8123ad65>] ? __pm_runtime_set_status+0x16=
2/0x186
        [   41.684180]  [<ffffffff811ad232>] ? local_pci_probe+0x49/0x92
        [   41.684180]  [<ffffffff8105afc5>] ? do_work_for_cpu+0x0/0x1b
        [   41.684180]  [<ffffffff8105afc5>] ? do_work_for_cpu+0x0/0x1b
        [   41.684180]  [<ffffffff8105afd0>] ? do_work_for_cpu+0xb/0x1b
        [   41.684180]  [<ffffffff8105fd3f>] ? kthread+0x7a/0x82
        [   41.684180]  [<ffffffff8100a824>] ? kernel_thread_helper+0x4/0x1=
0
        [   41.684180]  [<ffffffff8105fcc5>] ? kthread+0x0/0x82
        [   41.684180]  [<ffffffff8100a820>] ? kernel_thread_helper+0x0/0x1=
0
        [   41.684180] Code: f4 01 00 00 ef 31 f6 48 89 df e8 29 dd ff ff 8=
5 c0 0f 88 2b 03 00 00 48 89 ef e8 b4 39 c3 e0 8b 7b 40 e8 fc 9d b1 e0 48 8=
b 43 38 <66> 8b 10 66 89 14 24 8b 43 14 83 e8 03 83 f8 01 77 32 31 d2 be
        [   41.684180] RIP  [<ffffffffa0578402>] azx_probe+0x3ad/0x86b [snd=
_hda_intel]
        [   41.684180]  RSP <ffff88013153fe50>
        [   41.684180] CR2: ffffc90011c08000
        [   41.684180] ---[ end trace 8d1f3ebc136437fd ]---
        [=E2=80=A6]

Trusting the ACPI _CRS information (`pci=3Duse_crs`) fixes this problem. Th=
e match has to be against the DMI board entries though.

        [    0.000000] DMI: System manufacturer System Product Name/M2V-MX =
SE, BIOS 0304    10/30/2007

This quirk should be removed when `pci=3Duse_crs` is enabled for machines f=
rom 2006 or earlier.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D30552

CC: stable@kernel.org (=E2=89=A5 2.6.34)
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
---
Bjorn is working on a real fix. But until he has time and this gets in it w=
ould be great to get this quirk in.
---
 arch/x86/pci/acpi.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index ae3cb23..8bdad33 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -43,6 +43,16 @@ static const struct dmi_system_id pci_use_crs_table[] __=
initconst =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ALiveSATA2-GLAN"),
                 },
         },
+        /* https://bugzilla.kernel.org/show_bug.cgi?id=3D30552 */
+	/* 2006 AMD HT/VIA system with two host bridges */
+        {
+		.callback =3D set_use_crs,
+		.ident =3D "ASUS M2V-MX SE",
+		.matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "M2V-MX SE"),
+                },
+        },
 	{}
 };
=20
--=20
1.7.5.4

--=-tJ2DsPShizY2MtRbFvJp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk5f0PgACgkQPX1aK2wOHVjk6ACfZWBQ3x2SmT41R9/C16n23ojG
bn0AmgNWBijyejwDxeB4HiRH9RXYpxUV
=1zW8
-----END PGP SIGNATURE-----

--=-tJ2DsPShizY2MtRbFvJp--

