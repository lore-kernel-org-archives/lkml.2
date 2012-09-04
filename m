Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab2IDHlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 03:41:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:7230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab2IDHlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 03:41:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,365,1344236400"; 
   d="asc'?scan'208";a="188619927"
Message-ID: <1346744796.12610.6.camel@sauron.fi.intel.com>
Subject: Re: RCU warning during UBI file system mount
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Subodh Nijsure <snijsure@grid-net.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-mtd@lists.infradead.org,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Tue, 04 Sep 2012 10:46:36 +0300
In-Reply-To: <5042EC5D.1010207@grid-net.com>
References: <5042EC5D.1010207@grid-net.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-0pWY+RwNMLwGVzlGhmot"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0pWY+RwNMLwGVzlGhmot
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Let's CC LKML and Paul.

=20
On Sat, 2012-09-01 at 22:19 -0700, Subodh Nijsure wrote:
> Hello,
>=20
> I am running 3.6-rc4 kernel on my MX28 based board and every time I=20
> mount UBI file system I see following warning.
> Anybody else seen this errors, particularly those running it on MXS=20
> platform?
>=20
> I haven't debugged RCU warnings before any clues as to what is the=20
> source of this warning is, should I be looking at=20
> start_dma_without_bch_irq() code? Would appreciate any pointers in=20
> fixing this...
>=20
> [    4.280000] WARNING: at /opt/git/kernel-mainline/kernel/rcutiny.c:75=
=20
> rcu_idle_enter_common.clone.7+0x90/0xac()
> [    4.280000] Current pid: 1 comm: swapper / Idle pid: 0 comm: swapper
> [    4.280000] Modules linked in:
> [    4.280000] [<c0014eec>] (unwind_backtrace+0x0/0x130) from=20
> [<c001dd94>] (warn_slowpath_common+0x4c/0x64)
> [    4.280000] [<c001dd94>] (warn_slowpath_common+0x4c/0x64) from=20
> [<c001de40>] (warn_slowpath_fmt+0x30/0x40)
> [    4.280000] [<c001de40>] (warn_slowpath_fmt+0x30/0x40) from=20
> [<c0061618>] (rcu_idle_enter_common.clone.7+0x90/0xac)
> [    4.280000] [<c0061618>] (rcu_idle_enter_common.clone.7+0x90/0xac)=20
> from [<c0061670>] (rcu_irq_exit+0x3c/0x78)
> [    4.280000] [<c0061670>] (rcu_irq_exit+0x3c/0x78) from [<c000fe90>]=
=20
> (handle_IRQ+0x34/0x84)
> [    4.280000] [<c000fe90>] (handle_IRQ+0x34/0x84) from [<c000ec34>]=20
> (__irq_svc+0x34/0x58)
> [    4.280000] [<c000ec34>] (__irq_svc+0x34/0x58) from [<c0394c4c>]=20
> (schedule_timeout+0xdc/0x16c)
> [    4.280000] [<c0394c4c>] (schedule_timeout+0xdc/0x16c) from=20
> [<c0395f34>] (wait_for_common+0xb4/0x160)
> [    4.280000] [<c0395f34>] (wait_for_common+0xb4/0x160) from=20
> [<c02579d0>] (start_dma_without_bch_irq+0x6c/0xa8)
> [    4.280000] [<c02579d0>] (start_dma_without_bch_irq+0x6c/0xa8) from=
=20
> [<c0258660>] (gpmi_send_command+0x120/0x154)
> [    4.280000] [<c0258660>] (gpmi_send_command+0x120/0x154) from=20
> [<c0256fb4>] (gpmi_cmd_ctrl+0x44/0x6c)
> [    4.280000] [<c0256fb4>] (gpmi_cmd_ctrl+0x44/0x6c) from [<c024f8e0>]=
=20
> (nand_command_lp+0xe8/0x270)
> [    4.280000] [<c024f8e0>] (nand_command_lp+0xe8/0x270) from=20
> [<c0251e00>] (nand_do_read_ops+0x124/0x444)
> [    4.280000] [<c0251e00>] (nand_do_read_ops+0x124/0x444) from=20
> [<c0252558>] (nand_read+0x54/0x78)
> [    4.280000] [<c0252558>] (nand_read+0x54/0x78) from [<c02499a4>]=20
> (part_read+0x48/0x80)
> [    4.280000] [<c02499a4>] (part_read+0x48/0x80) from [<c0246910>]=20
> (mtd_read+0x88/0xb4)
> [    4.280000] [<c0246910>] (mtd_read+0x88/0xb4) from [<c026b188>]=20
> (ubi_io_read+0xb0/0x3e8)
> [    4.280000] [<c026b188>] (ubi_io_read+0xb0/0x3e8) from [<c026740c>]=
=20
> (ubi_eba_read_leb+0x198/0x4bc)
> [    4.280000] [<c026740c>] (ubi_eba_read_leb+0x198/0x4bc) from=20
> [<c0266800>] (ubi_leb_read+0xf4/0x16c)
> [    4.280000] [<c0266800>] (ubi_leb_read+0xf4/0x16c) from [<c0155550>]=
=20
> (ubifs_leb_read+0x24/0x88)
> [    4.280000] [<c0155550>] (ubifs_leb_read+0x24/0x88) from [<c01572f8>]=
=20
> (ubifs_read_node+0xa8/0x2e4)
> [    4.280000] [<c01572f8>] (ubifs_read_node+0xa8/0x2e4) from=20
> [<c0153c50>] (ubifs_read_sb_node+0x54/0x78)
> [    4.280000] [<c0153c50>] (ubifs_read_sb_node+0x54/0x78) from=20
> [<c0154940>] (ubifs_read_superblock+0xc8c/0x133c)
> [    4.280000] [<c0154940>] (ubifs_read_superblock+0xc8c/0x133c) from=20
> [<c01520ac>] (ubifs_mount+0x73c/0x1bc0)
> [    4.280000] [<c01520ac>] (ubifs_mount+0x73c/0x1bc0) from [<c00a49ec>]=
=20
> (mount_fs+0x44/0x184)
> [    4.280000] [<c00a49ec>] (mount_fs+0x44/0x184) from [<c00baf90>]=20
> (vfs_kern_mount+0x4c/0xc0)
> [    4.280000] [<c00baf90>] (vfs_kern_mount+0x4c/0xc0) from [<c00bb1a0>]=
=20
> (do_kern_mount+0x34/0xd0)
> [    4.280000] [<c00bb1a0>] (do_kern_mount+0x34/0xd0) from [<c00bc93c>]=
=20
> (do_mount+0x15c/0x73c)
> [    4.280000] [<c00bc93c>] (do_mount+0x15c/0x73c) from [<c00bcfa0>]=20
> (sys_mount+0x84/0xc4)
> [    4.280000] [<c00bcfa0>] (sys_mount+0x84/0xc4) from [<c04e4a04>]=20
> (do_mount_root+0x24/0xb0)
> [    4.280000] [<c04e4a04>] (do_mount_root+0x24/0xb0) from [<c04e4b78>]=
=20
> (mount_block_root+0xe8/0x214)
> [    4.280000] [<c04e4b78>] (mount_block_root+0xe8/0x214) from=20
> [<c04e4e28>] (prepare_namespace+0x8c/0x180)
> [    4.280000] [<c04e4e28>] (prepare_namespace+0x8c/0x180) from=20
> [<c04e4894>] (kernel_init+0x16c/0x1b4)
> [    4.280000] [<c04e4894>] (kernel_init+0x16c/0x1b4) from [<c000ff70>]=
=20
> (kernel_thread_exit+0x0/0x8)
> [    4.280000] ---[ end trace 4d36b722759fdc4f ]---
> [    4.950000] UBIFS DBG (pid 58): ubifs_bg_thread: background thread=20
> "ubifs_bgt0_0" started, PID 58
>=20
> -Subodh
>=20
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/

--=20
Best Regards,
Artem Bityutskiy

--=-0pWY+RwNMLwGVzlGhmot
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQRbHcAAoJECmIfjd9wqK0dtYP/2wMKq0gjRDEvDBpe3m9rRq3
+Ys/4FzdNFJE7Dvpiv/7FGihUAT1ubXw1fUQEu1HxyuJ+zEnSRZXpvBmGDcUhThN
4JTawNDh4mMckXDh+YSyyqsSCq60lHEpYyViC+g6B+bln3rO4KZiDN65hHtRV7TM
pckASQcOXKTN0WJJUuPoyK8hhj9RzZ2/d5rW1G63EEUyB2k4yYVBrv13pMR+ung0
e77INbT0026ZiFs4DgiZaR99XoaMPZ5Mh5O0916q8NApZ4fTarM8yUoWW4yM3IYA
FvxB4F8kF2Ki22tu7YUVu+Yr9IXT+zCY0m/cY63f7Cyxr43afRW7McCiEeFGUlcS
949z9pCnel90VdejvH/QZV9M4A+1PGRoSsZjwXWoLo0uttpg0FgmuC67TiVto4Go
Pb3SqLJ3fmu6CJlLNE9v0Gn0HRjyxdxe8UjSM1yLqNDs+YzMyKoO96M57nqsXehy
W82YFcdO45VHnOtMuXdXekSCBx4aM7HoQbIo6HTnYZaId0n1i4KKzItc7ALIeFZY
8As60FheE2+A9TSP3NY5WqSj+s0rWTIVCg6pTpyhAMa0ddi1kHH9gf9o7eRoZlpB
1GI5cZFuTIzsmACjorndeFpX+TtXsoBB6NYlc7H+sebl7S1rQwFx352k4z0N7l6c
Ubo6munO2bGldJhs3WfH
=ClU6
-----END PGP SIGNATURE-----

--=-0pWY+RwNMLwGVzlGhmot--

