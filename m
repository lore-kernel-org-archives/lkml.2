Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2ADXsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:48:50 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58860 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2ADXsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:48:47 -0500
Date: Thu, 5 Jan 2012 10:48:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-Id: <20120105104835.fd6c0fd173622af59d11012f@canb.auug.org.au>
In-Reply-To: <20120104230720.GD24583@kroah.com>
References: <20111228174518.721624fad9d048f9f85b3d50@canb.auug.org.au>
	<20120104230720.GD24583@kroah.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_10_48_35_+1100__S=vRLqHpgAmhm29"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_10_48_35_+1100__S=vRLqHpgAmhm29
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 4 Jan 2012 15:07:20 -0800 Greg KH <greg@kroah.com> wrote:
>
> Ok, I'll take off the warn_unused_result flag for device_create_file for
> now, which should solve this, and your other build problems with the
> driver-core tree.

Yes, I think that is it.

> > drivers/base/cpu.c: In function 'cpu_is_hotpluggable':
> > drivers/base/cpu.c:272:9: error: implicit declaration of function 'get_=
cpu_sysdev' [-Werror=3Dimplicit-function-declaration]
> > drivers/base/cpu.c:272:27: warning: initialization makes pointer from i=
nteger without a cast [enabled by default]
> > drivers/base/cpu.c:273:16: error: 'struct cpu' has no member named 'sys=
dev'
> > drivers/base/cpu.c:273:16: warning: initialization from incompatible po=
inter type [enabled by default]
> > drivers/base/cpu.c:273:16: error: 'struct cpu' has no member named 'sys=
dev'
> > drivers/base/cpu.c:274:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
> >=20
> > Caused by the above commit interacting with commit 2987557f52b9
> > ("driver-core/cpu: Expose hotpluggability to the rest of the kernel")
> > from the tip tree.  This is will fix up in the merge commit next time.
>=20
> Yeah, nothing I can do here about this, sorry.

Kay, Greg, any hints would be nice.  The tip tree commit is adding this:

bool cpu_is_hotpluggable(unsigned cpu)
{
        struct sys_device *dev =3D get_cpu_sysdev(cpu);
        return dev && container_of(dev, struct cpu, sysdev)->hotpluggable;
}

and, of course, all the sys_device stuff has now gone ...

So is this correct?

bool cpu_is_hotpluggable(unsigned cpu)
{
        struct device *dev =3D get_cpu_device(cpu);
        return dev && container_of(dev, struct cpu, dev)->hotpluggable;
}
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_10_48_35_+1100__S=vRLqHpgAmhm29
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBOVTAAoJEECxmPOUX5FEkrwP/iUsfoRBKlVZYr6yBE0d8pON
rqsbuvC9lqnRtuvMmLmEGtSYvbtNdrPzeWfHrqLufW8HeBj0afbSywtlgAhDzPpG
zbjpK4Yo1Dc/58Biq2jQrpwiumkDstbU4a5DPyP7+iMBgGS3DpvAtlXrNyc97F4R
v3cUlLhE/0s96zdIiXF5PmVb1rhYLI35nP7Gs5KflIN07wqPFyZTeB2VwCPi8ZZ1
33zDvVXGVoQezUC7+8V/ItLEBvbFuytRu0g6di81P0oAprfHPpKtW09gy5Zi41CD
Nw6braEqMHzuVIcYwnNysl5cFewWgKRHdpJ3f2qtxRhT+6QiGNx/tKgMeVyMzG8w
xe+GxeikHWt/eRMYscJy1POgFJhKEDX2Fzu/pw6wcGCngFZvjJyOZc325JgXXqZ5
NznkDJHpAhfY0l2/hHxsD0XnzLoVDgAKOhoRaoIIKjwTQ7cEMIzAonZsUsvdnlzU
G5NgAjHS/yZM4wbyRk0DuThL/qfpvqzCJGCecWgo314N7Z108lACZZIHZs0uiT3W
6EUGHY99sHNyXrv5/4Gyx1Ujly3vzFIGTrARHdvhQ/nzwLJucTiLCOLNPw7160p9
oCmpIlY6nqe03br+bWqxSyuSMskCRpys3J0W71/g+o670tM2WUVk25AmKOTb2/rf
8t5DU3uRQpq+lHyNrTcp
=pWAb
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_10_48_35_+1100__S=vRLqHpgAmhm29--
