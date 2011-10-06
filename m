Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965023Ab1JFPtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:49:02 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:59973 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754929Ab1JFPs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:48:59 -0400
Date: Thu, 6 Oct 2011 08:48:53 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/3] PCI: Rework config space locking, add INTx masking
 services
Message-ID: <20111006084853.033d8d0f@jbarnes-desktop>
In-Reply-To: <cover.1315846441.git.jan.kiszka@siemens.com>
References: <cover.1315846441.git.jan.kiszka@siemens.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NixJ727_2l_meqealkDUGK3"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NixJ727_2l_meqealkDUGK3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Sep 2011 18:54:01 +0200
Jan Kiszka <jan.kiszka@siemens.com> wrote:

> This series tries to heal the currently broken locking scheme around PCI
> config space accesses.
>=20
> We have an interface lock out access via sysfs, but that service wrongly
> assumes it is only called by one instance at a time for some device. So
> two loops doing
>=20
> echo 1 > /sys/bus/pci/devices/<some-device>/reset
>=20
> in parallel will trigger a kernel BUG at the moment.
>=20
> Besides synchronizing with user space, we also need to manage config
> space access of generic PCI drivers. They need to mask legacy interrupt
> lines while the specific driver runs in user space or a guest OS.
>=20
> The approach taken here is provide mutex-like locking for general
> access - which still requires a special mechanism due to requirements of
> the IBM Power RAID SCSI driver. Furthermore, INTx masking is now
> available via the PCI core and synchronized via the internal pci_lock.
>=20
> Not sure who may want to take this, so I'm CC'ing broadly.

ISTR a bunch of discussion about this (just back from lots of work
travel and vacation, sorry I missed most of it).

Is this the agreed upon way of handling it?  If so, can I get some
Reviewed/Acked-bys from people?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/NixJ727_2l_meqealkDUGK3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIbBAEBAgAGBQJOjc3lAAoJEIEoDkX4Qk9h/24P9R98+ZFNqaAjdZhZ8sHDwo0S
Zh8bPLNAssSD9aSW4tXbDZI3aFCNabQOm/+uxi3mk7AdMLs7oLF9hlW5JZoGmvc9
dxKjEj/CI9MDm4rGC0wRknsZr9UnoUUIzErJ23bmhySRc0gox6jYSCignG/YMHAr
mnFO3jnwTylnTRdvI5ZxsCxVC/N1F1jnSAK2P7YLazwmwnak8ocb3ZfVLOBFH4F3
8VUaj6uAh1DN6d0hgeiuPM6OGMiIDHrktkM3q23w9086d1D/HYQIj/JeqOK2gVgW
CzlDg+X5MII5gssKYmpyGOq+6pTaWxBAO7I1sES0uzSL2TTMLN/slGg162qk6ZzI
omylnCkBwi9cTKKVBCWjsU+uAcQJlGfhSEwYH85qaKUkV2EGeaAphbp4X69I7Zpn
Ci2J4vNGD20GD61HzseLbja77TdXJAAAuYDvbX8nFZ1QrA8yPkl2r4Mnm0290OCn
S8jzvfABBVnox8xlyyyHJUta8Kt48bDUvGFwNFKym0m1+5R2k0xUknbgyTFwsnMh
1ibxrNaLYMGkbOtzvCfsDAm0D5sVk7FHtZDd3IrvB3XxQA9C1eC9DmYppkdiTUda
IWRQPQc6bUZMpYUw+NSs0fnHQNMUUWDIHm9IaSxrsurCNrDf7bkk8Vg8Wn1Y0v0O
46/BB5SQI5OR6U9vlMI=
=Slmy
-----END PGP SIGNATURE-----

--Sig_/NixJ727_2l_meqealkDUGK3--
