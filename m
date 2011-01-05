Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab1AERPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:15:47 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:33498 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1AERPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:15:45 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Joel Becker <joel.becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: 2.6.37-next - kernel BUG at fs/dcache.c:1363
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1294247741_7242P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Jan 2011 12:15:41 -0500
Message-ID: <8679.1294247741@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4D24A73D.0197,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1294247741_7242P
Content-Type: text/plain; charset=us-ascii

Saw this crash on a linux-next pulled yesterday at 2PM EST, kernel dies very
early (looks like first time it touches configfs for anything - trying to boot
with netconsole enabled caused it to die even faster).  I can bisect this if
it doesn't immediately ring a bell...

It dies here:

void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
{
        BUG_ON(dentry->d_op);

Am guessing configfs passed in a dentry that wasn't filled in enough.

(hand-transcribed from a crappy cellphone pic)

kernel BUG at fs/dcache.c:1363
invalid opcode: 0000 [#1] PREEMT SMP
last sysfs file:
CPU 0
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.37-rc8-next-2011 (edge of pic)
...

configfs_attach_item.clone.14+0x11d/0x254
configfs_attach_group.clone.15+0x1c/0x196
? _raw_spinlock_unlock+0x5c/0x69
configfs_register_subsystem_0xce/0x144
? init_netconsole+0x0/0x21f
init_netconsole+0x10d/0x21f
? init_netconsole+0x0/0x21f
do_one_initcall+0x52/0x12f
kernel_init+0x162/0x1e7
kernel_thread_helper+0x4/0x10
? finish_task_switch_0x3f/0xe3
? restore_args+0x0/0x30
? kernel_init+0x0/0x1e7
? kernel_thread_helper+0x0/0x10

I d_net_d_op+0x38/0xb0



--==_Exmh_1294247741_7242P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNJKc9cC3lWbTT17ARAsZCAJ4/odytCNjco7ebIVuVqfPmqHinFwCfSZsr
0VhR5hS6VUMT/3OIIk9Qx4c=
=pU2T
-----END PGP SIGNATURE-----

--==_Exmh_1294247741_7242P--

