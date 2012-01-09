Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab2AITWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:22:14 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43455 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932851Ab2AITWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:22:13 -0500
Date: Mon, 9 Jan 2012 11:22:07 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?B?Um9n6XJpbw==?= Brito <rbrito@ime.usp.br>,
        bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?B?TeFyY2lh?= Coutinho de Brito 
	<mcbrito@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, Ram Pai <linuxram@us.ibm.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
Message-ID: <20120109112207.7f993845@jbarnes-desktop>
In-Reply-To: <CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
	<CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/f5ZmzJ6v4ZXW8eKw5JJKcxb"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/f5ZmzJ6v4ZXW8eKw5JJKcxb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Jan 2012 14:23:29 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Jan 8, 2012 at 2:13 PM, Rog=E9rio Brito <rbrito@ime.usp.br> wrote:
> >
> > It doesn't boot with a vanilla kernel. It only boots when I pass the op=
tions
> > above *and* compile the kernel with the following patch applied:
> >
> > ,----[ do_not_size_subtractive_decoding_transparent_pci_to_pci_bridges.=
patch ]
> > | diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> > | index 86b69f85..84543f5 100644
> > | --- a/drivers/pci/setup-bus.c
> > | +++ b/drivers/pci/setup-bus.c
> > | @@ -849,6 +849,10 @@ void __ref __pci_bus_size_bridges(struct pci_bus=
 *bus,
> > | =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> > |
> > | =A0 =A0 =A0 case PCI_CLASS_BRIDGE_PCI:
> > | + =A0 =A0 =A0 =A0 =A0 =A0 /* don't size subtractive decoding (transpa=
rent)
> > | + =A0 =A0 =A0 =A0 =A0 =A0 =A0* PCI-to-PCI bridges */
> > | + =A0 =A0 =A0 =A0 =A0 =A0 if (bus->self->transparent)
> > | + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> > | =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_bridge_check_ranges(bus);
> > | =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bus->self->is_hotplug_bridge) {
> > | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 additional_io_size =A0=3D=
 pci_hotplug_io_size;
> > `----
>=20
> Ahh. I'd forgotten about that particular PCI patch.
>=20
> That is definitely the right thing to do, and commit 8fa5913d54f3
> ("PCI: remove transparent bridge sizing") did exactly that, but then
> we reverted it in commit 12c22d6ef299 because it caused some odd
> problems for some people.
>=20
> I think we should try to re-do that "avoid sizing transparent bridges"
> commit, because it really should make it much easier to do PCI
> allocations under some very common situations (there's a *lot* of
> common intel transparent PCI bridges).
>=20
> Jesse, Yinghai, Ram - should we try to just re-do that commit in this
> merge window, and see how that goes? We can always revert it again if
> it causes problems..

I don't remember what problems we hit, but if Ram and Yinghai are
willing to take a look at them we should go ahead and try again.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/f5ZmzJ6v4ZXW8eKw5JJKcxb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPCz5fAAoJEIEoDkX4Qk9hiIQP/1QSLKJqK2iMG4V6mvTlE42a
l3GOrYtieUHl4PdC2XdyrJdXlTB7zdUadzXLcwVqnZCIaYHV6+UI4ZTeSczYqpsG
MCpvwVLt+R+IHQWk/ovyCF8hS5OwVUXi9IU74jYVPtFvZyqg6xL9lV9ZtMO7dSZF
9Bea2XqKCuSNfRNq+j09WEW52iRb3OuqeEiQsJGRapeA5zEOThSNba3RXeKU5H8U
Wp14SI695kwU1dDEFGTvYHRvWXd70u7LLiqXm1Am0rDxVzJnFJq2qnbhHMfjAmGd
u/sdsr7c+0z3FK6XPFKk1yM9gb0x7HfAW2TSwd4rQH0h4kupIyLKIw6O6CcpZs6H
cOxhc9ycikb92q6a7TqHs8j5VjNZlWm1UHBCqI2qENxPHEdCc/OSF3w9ED+LpHSi
uB6HAKevjAsZC+2oSlu4yGw9c8S00SQ9kI6gGS72v91df/60EOIJPj7cgSTnbNGc
VHFiJvTYm4E7cW92fmxN7CzylS1jE4bnHCnMpBy9O/9EJ4WhRyV3U2CrKgYSJSnt
7uD+2usJwGPStJVYr2aiW115H/ed5sRaF7jeoe6xedde+nKH3UtOWB+fkazZp02H
sMVT9uvYIpxDHIZKgsANqfMR8p3gZ0qFCvFc+Q7mbieb54r+DHxaDvY+g8QRxMw+
Ih3bjRPVOD6lWQwA1HYc
=EsZV
-----END PGP SIGNATURE-----

--Sig_/f5ZmzJ6v4ZXW8eKw5JJKcxb--
