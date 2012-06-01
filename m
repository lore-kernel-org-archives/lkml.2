Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2FAG7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 02:59:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36620 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2FAG73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 02:59:29 -0400
Date: Fri, 1 Jun 2012 16:59:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: boot failuresfor next-20120601
Message-Id: <20120601165919.4693f733078c7214d7caac1e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Jun_2012_16_59_19_+1000_KqtXe32Gk_TTH_Oo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jun_2012_16_59_19_+1000_KqtXe32Gk_TTH_Oo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next fails to boot on my PowerPC boxes like this (one
example):

calling  .ipr_init+0x0/0x68 @ 1
ipr: IBM Power RAID SCSI Device Driver version: 2.5.3 (March 10, 2012)
ipr 0000:01:01.0: Found IOA with IRQ: 26
ipr 0000:01:01.0: Starting IOA initialization sequence.
ipr 0000:01:01.0: Adapter firmware version: 06160039
ipr 0000:01:01.0: IOA initialized.
scsi0 : IBM 572E Storage Adapter
async_waiting @ 1
async_continuing @ 1 after 0 usec
scsi 0:0:1:0: Direct-Access     IBM-ESXS MAY2036RC        T106 PQ: 0 ANSI: 5
async_waiting @ 1
async_continuing @ 1 after 0 usec
async_waiting @ 1
async_continuing @ 1 after 0 usec
	.
	.	(lots and lots of these)
	.
async_waiting @ 1
async_continuing @ 1 after 0 usec
scsi: unknown device type 31
scsi 0:255:255:255: No Device         IBM      572E001          0150 PQ: 0 =
ANSI: 0
initcall .ipr_init+0x0/0x68 returned 0 after 967815 usecs
	.
	.
	.
initcall 1_.sd_probe_async+0x0/0x1d0 returned 0 after 220331 usecs
INFO: rcu_sched self-detected stall on CPU { 2}  (t=3D6001 jiffies)
Call Trace:
[c00000007897b2a0] [c000000000013b40] .show_stack+0x70/0x1c0 (unreliable)
[c00000007897b350] [c00000000012937c] .__rcu_pending+0x20c/0x580
[c00000007897b410] [c000000000129844] .rcu_check_callbacks+0x154/0x250
[c00000007897b4b0] [c0000000000b1e64] .update_process_times+0x44/0xa0
[c00000007897b540] [c0000000000fbc6c] .tick_sched_timer+0x7c/0x100
[c00000007897b5e0] [c0000000000cee88] .__run_hrtimer+0xb8/0x270
[c00000007897b690] [c0000000000cf3a8] .hrtimer_interrupt+0x128/0x2c0
[c00000007897b7a0] [c00000000001cc98] .timer_interrupt+0x108/0x290
[c00000007897b850] [c000000000003b80] decrementer_common+0x180/0x200
--- Exception: 901 at .arch_local_irq_restore+0x74/0x90
    LR =3D .arch_local_irq_restore+0x74/0x90
[c00000007897bb40] [c000000000010108] .arch_local_irq_restore+0x38/0x90 (un=
reliable)
[c00000007897bbb0] [c00000000009de30] .console_unlock+0x370/0x460
[c00000007897bca0] [c00000000041c1ec] .fb_flashcursor+0x7c/0x180
[c00000007897bd50] [c0000000000c30ec] .process_one_work+0x19c/0x590
[c00000007897be10] [c0000000000c3a48] .worker_thread+0x188/0x4b0
[c00000007897bed0] [c0000000000c9cdc] .kthread+0xbc/0xd0
[c00000007897bf90] [c000000000020eb8] .kernel_thread+0x54/0x70
	.
	.=09
	.
calling  .initialize_hashrnd+0x0/0x40 @ 1
initcall .initialize_hashrnd+0x0/0x40 returned 0 after 1 usecs
async_waiting @ 1
async_continuing @ 1 after 0 usec
Freeing unused kernel memory: 468k freed
/init: 71: mknod: Permission denied
/init: 88: mknod: Permission denied
/init: 88: mknod: Permission denied
/init: 88: mknod: Permission denied
/init: 88: mknod: Permission denied
/init: 99: cannot open /proc/cmdline: No such file
/init: 103: mkdir: Permission denied
/init: 104: mkdir: Permission denied
/init: 108: udevadm: Permission denied
dracut: FATAL: No or empty root=3D argument
dracut: Refusing to continue


Signal caught!

Boot has failed, sleeping forever.
/init: 1: sleep: Permission denied
/init: 1: sleep: Permission denied
/init: 1: sleep: Permission denied
	.
	.
	.

Another machine did not use the ipr device and only got the init problems
at the end.

Anyone got any ideas?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Jun_2012_16_59_19_+1000_KqtXe32Gk_TTH_Oo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPyGhHAAoJEECxmPOUX5FEsR8P/0dPK7B2eYBJsyYiL+6WX4sm
GgRin/WPyoMtl+2Xzv/z36T1cDi+DK/PLfnwFPyZB80mkmhIk65zVTWdXe7XZEza
srb3arlvKf6zN1XJmF2zIr2DorPbJUuzSogThedm3gFfNmpwqnHQxOfxQRpCecE7
1Q0wLo01Oza90IcNOtUnJ716WNgZlPhUV7GLFgDvRGUrZoO1cvbIMD+EN5QlvGzj
JoYPuPc3y/S9gvbuUIlc1dZOq3lDvvXvRkwlNLG4aB/EGrVNATrAT0gtPpCryyM6
oPgiQypv0skHuJ6Zy4PlEzxRn2aZrNTRmAY+9xVZxW+rXarDwr/Z3fXsxx0hX4bu
ux5Rs3RfN6zHmwjdnvKrVL2umPkIEKzQbEFKxTqOOyiIobt0G5I4vS7Bb874qpth
QydExgtGvp6JbDJp7fU1k4WS2pDf6lHadDfSGHgfd3kesL1Osn3ZAD9oaNMLYbnu
jiCuiVoQGCd592lP1NMKLlHu65KfRFHCP4Vir+m3EEZZMR6rIDCIb8oU07gF6Spj
LAQ02njY2soXe64n4YPTtm9NMImgNH6kvhpSwgGQb5Fr/93cD/idgzJqh9tng/UX
hvnc1xkKADcb86lYzGaGDSnx5A40MNoEf6y93suelw+MEQSq5Cy2WjkgL7y8/9Ad
n7w3lQKEs/Dx70J/zZcl
=LY0h
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jun_2012_16_59_19_+1000_KqtXe32Gk_TTH_Oo--
