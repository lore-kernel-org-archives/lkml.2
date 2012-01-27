Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab2A0R0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:26:30 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:55675 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751485Ab2A0R03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:26:29 -0500
Date: Fri, 27 Jan 2012 09:26:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pciehp: Disable/enable link during slot power off/on
Message-ID: <20120127092622.6d8c2ae8@jbarnes-desktop>
In-Reply-To: <4ED95AD0.7090003@oracle.com>
References: <4ED95AD0.7090003@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TZfY3mT0jBz1aohPCMGpoiR"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TZfY3mT0jBz1aohPCMGpoiR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 02 Dec 2011 15:10:08 -0800
Yinghai Lu <yinghai.lu@oracle.com> wrote:

>=20
> One system have repeater in system board to support gen2 hotplug.
>=20
> Found when EM is removed from some slots, /var/log/message will be full of
> "card present/not present" warning.
>=20
> It turns out root complex still try to train the link to repeater because
> repeater is not reset.
>=20
> This patch will disable link to make repeater could reset properly.
> Also could kill AER during EM removal.
>=20
> Recently when testing hotplug on one system under development, found if b=
oot
> the system without EM, and later hotplug does not work with Linux.
> But other OS is ok.
> The root cause is that bios left link disabled when slot is empty,
> and other OS is playing link disable bit in link ctrl during power on/off.
>=20
> So We could do the same thing to disable/enable link during power off/on.
>=20
> Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>

Ok I had to massage that commit message quite a bit, please let me know
if it's still accurate.

The 100ms delay still needs to be clarified; if it's really necessary
maybe we could move the delays into a delayed work handler?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/TZfY3mT0jBz1aohPCMGpoiR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIt4+AAoJEIEoDkX4Qk9hRY0QALBlxf/UWdxUQ+/70o8mXZpA
IkfV4HjlW+g1tb4tBy3gvHuDg7lsMaIOczxhlFtKFxmDK5lZ6mTXykU8/hQIoi3J
hkcoImz7behwxw/bSbh8BKYB90rceGJt3ULCN06V6pt2sZK11nIJRAqXIBt1TjTa
eDpWIbs+Fv3nVaXrGk8odOwj/qs2eq+FhnQi8w51rGlVtesgveJJTq5cNn0HP4o7
SODnJrSHCqeX4uDWZrFHOQAI9hQiaD7c86XHssCToDj4zE7NilxJtS9AV0mSmH+O
BQjoQwnWC6hS3l1DwnmNMWKMqCqEeDVfvcjv7EMLdCGEZzs40IvEovI41xkO0CZe
abHAPAsUmEtZ1rwnX4kM2oA0hHE04XZ3fibsG2SPaulfR7KbPn7oGc2J/YG/8v77
vsw5T+0lEWs7q3ZpmBkDKjtPngrWx6FPJJQe24V5fTUzLB64DNjsicgczW8OWWKs
WQCkYkK0YWvanaEuXkiMjArc0YsTRkjQFnTEQhr4nW0xwYp0OTXcSSZTjGz9Y5xn
hC0vX7scjyqTMv68Reo2vt1HNwYGgUBhv833tgkHS3V+aTFkhw/E+VMvBo9earZz
MW76gb/2v65rcEpG4tiH6gwEdI2bH7el85/Pz5k24lo0wUCdi8j4JTVJgwTiYFr5
ucWjuwVFL9t3fq9fzNfr
=1WZ0
-----END PGP SIGNATURE-----

--Sig_/TZfY3mT0jBz1aohPCMGpoiR--
