Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1ALRel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:34:41 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:60315 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1ALRei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:34:38 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Alexander Viro <viro@zeniv.linux.org.uk>, Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294853673_4778P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Jan 2011 12:34:33 -0500
Message-ID: <16069.1294853673@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4D2DE62A.01FA,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294853673_4778P
Content-Type: text/plain; charset=us-ascii

Seen in a boot of yesterday's linux-next.   The 'W' flag was due to the
already-reported 'WARNING: at kernel/workqueue.c:1202 worker_enter_idle'.
Not sure if it's a block_dev or dm/LVM issue, so I'm cc:'ing both groups.  I wonder
if the fact I still have 'CONFIG_DEVTMPFS=n' is involved (it's apparently ticking off
dracut before and after the warning).

[   16.840333] dracut: Found volume group "vg_blackice" using metadata type lvm2
[   16.892282] dracut: The link /dev/vg_blackice/opt should had been created by udev but it was not found.  Falling back to direct link creation.
[   16.912627] ------------[ cut here ]------------
[   16.912635] WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
[   16.912638] Hardware name: Latitude E6500
[   16.912640] Modules linked in:
[   16.912644] Pid: 1920, comm: lvm Tainted: G        W   2.6.37-next-20110111 #1
[   16.912647] Call Trace:
[   16.912653]  [<ffffffff8103a989>] ? warn_slowpath_common+0x80/0x98
[   16.912657]  [<ffffffff8103a9b6>] ? warn_slowpath_null+0x15/0x17
[   16.912660]  [<ffffffff8111fb03>] ? bd_link_disk_holder+0x92/0x1ac
[   16.912665]  [<ffffffff8139b875>] ? open_dev+0x76/0x9e
[   16.912668]  [<ffffffff8139bc9d>] ? dm_get_device+0x147/0x1dc
[   16.912672]  [<ffffffff8139d088>] ? linear_ctr+0x98/0xd4
[   16.912676]  [<ffffffff8139c289>] ? dm_table_add_target+0x149/0x1d4
[   16.912679]  [<ffffffff8139e57c>] ? table_load+0xf0/0x27b
[   16.912683]  [<ffffffff8139e48c>] ? table_load+0x0/0x27b
[   16.912686]  [<ffffffff8139f326>] ? ctl_ioctl+0x1c6/0x21e
[   16.912690]  [<ffffffff8139f38c>] ? dm_ctl_ioctl+0xe/0x12
[   16.912695]  [<ffffffff8110258e>] ? do_vfs_ioctl+0x4c4/0x505
[   16.912699]  [<ffffffff81102626>] ? sys_ioctl+0x57/0x95
[   16.912703]  [<ffffffff8100253b>] ? system_call_fastpath+0x16/0x1b
[   16.912706] ---[ end trace 4eaa2a86a8e2da24 ]---
[   16.925289] dracut: The link /dev/vg_blackice/src should had been created by udev but it was not found.  Falling back to direct link creation.


--==_Exmh_1294853673_4778P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNLeYpcC3lWbTT17ARAgZTAJ9ANtKMam01zeEQcrSePvARkO1a/gCg2OQ1
qNJroZRFZurx2Z8n3ZrUEOE=
=OhP/
-----END PGP SIGNATURE-----

--==_Exmh_1294853673_4778P--

