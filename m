Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0DTUAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:00:06 -0400
Received: from mail.copilotco.com ([216.105.40.123]:44236 "EHLO
	mail.copilotco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab0DTUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:00:04 -0400
Date: Tue, 20 Apr 2010 13:00:04 -0700
From: Tracy Reed <treed@edirectpublishing.com>
To: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: xen-devel@lists.xensource.com, Aoetools-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420200004.GQ5660@tracyreed.org>
Mail-Followup-To: Tracy Reed <treed@edirectpublishing.com>,
	Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
	xen-devel@lists.xensource.com,
	Aoetools-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20100420080958.GN5660@tracyreed.org>
 <20100420084955.GV1878@reaktio.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YNEMMPJXay2VNSoy"
Content-Disposition: inline
In-Reply-To: <20100420084955.GV1878@reaktio.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YNEMMPJXay2VNSoy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2010 at 11:49:55AM +0300, Pasi K=E4rkk=E4inen spake thusly:
> Are you using filesystems on normal partitions, or LVM in the domU?=20
> I'm pretty sure this is a domU partitioning problem.

Also: What changes in the view of the partitioning between domU and
dom0? Wouldn't a partitioning error manifest itself in tests in the
dom0 as well as in the domU?

BTW: The dd from the last time in my last email finally finished:

# dd if=3D/dev/zero of=3D/dev/xvdg1 bs=3D4096 count=3D3000000
3000000+0 records in
3000000+0 records out
12288000000 bytes (12 GB) copied, 734.714 seconds, 16.7 MB/s

If I run that very same dd as above (the last test in my previous
email) with the same partition setup again but this time from the
dom0:

# dd if=3D/dev/zero of=3D/dev/etherd/e6.1 bs=3D4096 count=3D3000000
3000000+0 records in
3000000+0 records out
12288000000 bytes (12 GB) copied, 107.352 seconds, 114 MB/s

# /sbin/sfdisk -d /dev/etherd/e6.1=20
# partition table of /dev/etherd/e6.1
unit: sectors

/dev/etherd/e6.1p1 : start=3D       64, size=3D566226926, Id=3D83
/dev/etherd/e6.1p2 : start=3D        0, size=3D        0, Id=3D 0
/dev/etherd/e6.1p3 : start=3D        0, size=3D        0, Id=3D 0
/dev/etherd/e6.1p4 : start=3D        0, size=3D        0, Id=3D 0

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz
avgqu-sz   await  svctm  %util
sda               0.00 17350.80  0.60 275.60    22.40 72540.00
525.43    97.94  344.01   3.62 100.02
sdb               0.00 17374.80  1.20 256.00    28.00 74848.00
582.24   136.20  527.72   3.89 100.02

72MB/s and 74MB/s per disk in the stripe. Nice. Wish I could get that in a =
domU!

--=20
Tracy Reed
http://tracyreed.org

--YNEMMPJXay2VNSoy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFLzgfE9PIYKZYVAq0RAsrgAJwKQgG2DIjKwVjl02w6RtMCwBYRQwCeIUO7
jE25k86r32OE10/2O4IVGLE=
=xMKX
-----END PGP SIGNATURE-----

--YNEMMPJXay2VNSoy--
