Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1A1BYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:24:45 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:38058 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1A1BYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:24:44 -0500
X-Spam-ASN: 
Date: Fri, 28 Jan 2011 04:24:33 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: uClibc <uclibc@uclibc.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: timerfd incompatibility on mips
Message-ID: <20110128042433.7f4758f2@apollo.gnet>
In-Reply-To: <alpine.DEB.2.00.1101271651250.30861@localhost6.localdomain6>
References: <20110128032443.6f8b877e@apollo.gnet>
	<alpine.DEB.2.00.1101271651250.30861@localhost6.localdomain6>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/rjlyPc1TESdid29iPZA4Sd3"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rjlyPc1TESdid29iPZA4Sd3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Thu, 27 Jan 2011 16:53:39 -0800 (PST)
Davide Libenzi <davidel@xmailserver.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Fri, 28 Jan 2011, Alexander Gordeev wrote:
>=20
> > Hi!
> >=20
> > I've just found a problem with TFD_NONBLOCK flag that can be passed to
> > timerfd_create.
> >=20
> > <uclibc>/libc/sysdeps/linux/common/sys/timerfd.h which is installed
> > to /usr/include/sys/timerfd.h defines TFD_NONBLOCK as 04000 ie 0x800.
> > BTW glibc/eglibc headers do the same thing.
> >=20
> > <linux>/include/linux/timerfd.h declares it as O_NONBLOCK which is
> > defined in fcntl.h. Usually O_NONBLOCK is 0x800 too but some
> > architectures including MIPS it redefine it:
> >=20
> > arch/mips/include/asm/fcntl.h:#define O_NONBLOCK	0x0080
> > arch/alpha/include/asm/fcntl.h:#define O_NONBLOCK	00004
> > arch/sparc/include/asm/fcntl.h:#define O_NONBLOCK	0x4000
> > arch/parisc/include/asm/fcntl.h:#define O_NONBLOCK	000200004
> >=20
> > My tests show that kernel thinks that TFD_NONBLOCK is 0x80 on MIPS. I
> > get what I want when I pass 0x80 and EINVAL when I pass 0x800. I don't
> > know why there are such uncertain things in Linux. Probably the problem
> > should be fixed in the kernel.
> >=20
> > Right now one cannot use timerfd_create(..., TFD_NONBLOCK) on MIPS but
> > can use timerfd_create(..., O_NONBLOCK) instead.
>=20
> Ther kernel definition (include/linux/timerfd.h) maps it directly to=20
> O_NONBLOCK, but I am noticing that glibc bolt in the value.
> I don't think this is a kernel fix.

Yes, but linux/timerfd.h is not installed so timerfd.h from *libc
cannot include it. So adding it to include/linux/Kbuild would be a
first step to make them not hard-code the value. Right?

--=20
  Alexander

--Sig_/rjlyPc1TESdid29iPZA4Sd3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNQhrRAAoJEElrwznyooJblnAIAIeAmfP9xQ2Kst3Y5Pt+zbL8
8DOmWRFbNr0S+FVd9pWMDrxcGfvmKXqhgBaa7rCNr3wmhpPb5EF9K32+l9up14Da
/BUMEKSqryKmRsGmCCLRm3mYVu/CNTG1renYCG86p0RLIoS/7O/Y8Kr2t1zxbJr/
mh+YQzTAnFyK+wHsnGGJVEReYINmq6/4tA8aHYLExCYhGUwVPSKMvsD22TyGXDiG
NKTIlhTBXwst9/UbTLU3yU8E74eszWfBUoq3jCzntFh3PmADbs5L0lFl35Wzmne2
j5vGORO6QgRYFWr80Ey7nhzY4h3BcbODiEn/u07AssNInuS4+ZhXPVted5+HuMU=
=shx4
-----END PGP SIGNATURE-----

--Sig_/rjlyPc1TESdid29iPZA4Sd3--
