Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2BJUwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:52:00 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:35952 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932440Ab2BJUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:51:58 -0500
Date: Fri, 10 Feb 2012 12:51:50 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 01/24] PCI: Add iobusn_resource
Message-ID: <20120210125150.3353237c@jbarnes-desktop>
In-Reply-To: <CAE9FiQXeRGXE2RCe5S1iOE=QY37wauM=WUevjXWkMqMOjV3t7A@mail.gmail.com>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
	<1328425088-6562-2-git-send-email-yinghai@kernel.org>
	<CAErSpo4HJH+3EQAWowyVxZFa5jVy1EOo=SoybJqqcjhVdo0nzw@mail.gmail.com>
	<CAE9FiQXeRGXE2RCe5S1iOE=QY37wauM=WUevjXWkMqMOjV3t7A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/M=dzPqIZawhCO/v/OZGvQkS"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/M=dzPqIZawhCO/v/OZGvQkS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Feb 2012 10:55:14 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On Mon, Feb 6, 2012 at 10:48 AM, Bjorn Helgaas <bhelgaas@google.com> wrot=
e:
> >> +struct resource iobusn_resource =3D {
> >> + =C2=A0 =C2=A0 =C2=A0 .name =C2=A0 =3D "PCI busn",
> >> + =C2=A0 =C2=A0 =C2=A0 .start =C2=A0=3D 0,
> >> + =C2=A0 =C2=A0 =C2=A0 .end =C2=A0 =C2=A0=3D 0xffffff,
> >> + =C2=A0 =C2=A0 =C2=A0 .flags =C2=A0=3D IORESOURCE_BUS,
> >> +};
> >
> > I'm not sure this should be global. =C2=A0iomem_resource and
> > ioport_resource *are* really global, because they refer to processor
> > address space that is the same for everybody. =C2=A0But PCI bus numbers=
 are
> > specific to PCI. =C2=A0Some machines don't have PCI at all, and there a=
re
> > different bus architectures to which this doesn't apply.
>=20
> that does not hurt them.

Yes but it's superfluous and confusing if you're porting to a new arch
or looking at changes in generic code that may affect you.

> > The 0-0xffffff range is misleading because it includes both the domain
> > and the bus number, and it's meaningless to allocate ranges that cross
> > domain boundaries. =C2=A0For example, [bus 0x0000f0-0x000120] includes =
bus
> > numbers from domain 0000 and domain 0001, which doesn't make any sense
> > because a bus can only be in one domain.
>=20
> allocation code will make sure it will be cross the boundary for domain.

But that means everyone reading it will do a double take, have to dig
into the implementation, and only then say "ah yeah ok it looks
correct" rather than it being obvious from the fact that the resource
is tracked on a per-domain basis.

> > I think it would make more sense to keep this bus number resource in a
> > per-host bridge structure. =C2=A0Then we wouldn't need to include the
> > domain number at all because the host bridge determines the domain.
>=20
> not sure. insert the all busn_res of all peer root buses into one
> global iobusn_resource
> looks more simple.

In what sense?  Simpler in the sense of your current implementation,
but not simpler at all to someone just reading the code...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/M=dzPqIZawhCO/v/OZGvQkS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNYNmAAoJEIEoDkX4Qk9hf58P/0eVO49mgMAHjjkImINiBeBA
pRSm9M0JoKxjHJXtXJa4SgvXkiFDiSeMossV0sjGiR5Cc047MPLPEOcRWNhf5HYu
IGAY4lor2wixEYuT+qRIULQhcYID2Oavvi6WYi39ONTA9yLzJTBGPhBNW0HIl0Wo
bk/p3wbjWSZ2tkspdvjkdNvGGYEIMiTeusGArE4B/Md7Cx8V8TlHlCtk4iQ6ObL8
dGUlb49c31xhy/vM5ln/kNtLY+gWBprwe5aMpeTqUXjjaKX3Ai72HxmWjqkCrIdy
v1inMr8hQYVzly1h+UWpB8LJ4NoPguZ1Jw/xE/pL0uV5Al/EPp4wpI1Qkn5Zkxwa
lXp1cUZOx/0QUd7MoHEw37BpOoPpmKPwC+43U6hGx/Al55rSV/UxFINluY7V7w71
EA5DVNSsao/K6DC9ouYlbtLDqBxmNI/oMAd1gn4ad2OCVg84fomvBrqz3IAyk+lU
nSLuPwV4z9ajEbONpqVB9mUbkwUKC074DgmGQLMFhvCMGUPVowS2/ESbtEhh8cVG
Q9H8S04lj46J3fnUnwTXKA7HhvH6ScTpMJXg8WNWGdv4vVFvsGl8vIBjqpwtDmnA
yPWu1MhFFVk3F/A3yqWZJU6kQuBr+x83JG4quduMASIoLZ87kP1qkL/uUrflfQPO
nQoxbGK3bXiwbh4Ravmv
=y0DF
-----END PGP SIGNATURE-----

--Sig_/M=dzPqIZawhCO/v/OZGvQkS--
