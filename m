Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2BJUxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:53:05 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:46921 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932214Ab2BJUxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:53:02 -0500
Date: Fri, 10 Feb 2012 12:52:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] PCI: Fix cardbus bridge resources as optional size
 handling
Message-ID: <20120210125258.55c1f339@jbarnes-desktop>
In-Reply-To: <CAE9FiQUYg8V8RSeh+xiWYxEfSxwEhp9KRXAjVkyhT94Enkqc3Q@mail.gmail.com>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-5-git-send-email-yinghai@kernel.org>
	<20120208043517.GD8930@ram-ThinkPad-T61>
	<CAE9FiQUdRLmc-_hHWtaz=8QZiu4Ma6ZY7zavByJnwMDTBQLtzg@mail.gmail.com>
	<20120208050119.GE8930@ram-ThinkPad-T61>
	<CAE9FiQUYg8V8RSeh+xiWYxEfSxwEhp9KRXAjVkyhT94Enkqc3Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xD+bwy2Mh.Es8SEK6xItDRZ"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xD+bwy2Mh.Es8SEK6xItDRZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2012 22:11:22 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On Tue, Feb 7, 2012 at 9:01 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> >
> > ..snip..
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0* If we have prefetchable memory support, a=
llocate
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0* two regions. =C2=A0Otherwise, allocate on=
e region of
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0* twice the size.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> =C2=A0 =C2=A0 =C2=A0 if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b_res[2].start =3D pc=
i_cardbus_mem_size;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b_res[2].end =3D b_re=
s[2].start + pci_cardbus_mem_size - 1;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b_res[2].flags |=3D I=
ORESOURCE_MEM | IORESOURCE_PREFETCH |
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IORESOURCE_STARTALIGN;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (realloc_head) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 b_res[2].end -=3D pci_cardbus_mem_size;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 add_to_list(realloc_head, bridge, b_res+2,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pci_cardbus_mem_size, pci_cardbus_=
mem_size);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* reduce that to hal=
f */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b_res_3_size =3D pci_=
cardbus_mem_size;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >
> > ACK. Ok. got it. This looks correct.
>=20
> Good, So we have
>=20
> Acked-by: Ram Pai <linuxram@us.ibm.com>
> Tested-by: Dominik Brodowski <linux@dominikbrodowski.net>
>=20
> Hope Jesse will not miss to add them

Yeah looks fine.  I'd like to see an ack from Dominik on 5/9 as well
though.  Can you include the acks and tested-bys when you re-post 3-9
with bug references and any other comments included?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/xD+bwy2Mh.Es8SEK6xItDRZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNYOrAAoJEIEoDkX4Qk9hylsQALhuaQZwFfVFObk0Aw945+4h
qu9SPRm+H25S0cxhHUH6jNHeCU6LYAXpArG1KyLNRy6SZxaL/t465h0eVO32G8et
W937GZgsIdMtCRKx9rdPu1nL3hWRz6tlnPtk8ah3/ti4JjRgOxFmK+zXDt1vnf5C
Y3BOIm5Q4P0KNKOrKl8V9BnzMs/Es7SNPmImA22dBEhX5XeOJtRpe7Bx3O0bxy/F
9kxCz4Q+tg+Xjt/s5XVerH8J6DMflTK/T68WPho4CT0dOTpDMjxgWLW2fubSEi81
s4iItnI6S7+3CK9Wa5BTYgF1PlacnMrRpuFkNRKpfuuEznMUSqU3vvOgEP1diXbF
mXfiQ/1OPX7c/3QVC1kztrl/ni3siMwdLyIdi+Ut9m1vle0eMAqSB4qBY0D2Ax1E
q60tVeBMe3JkLZq/E8PlCXnVSPUenUbXuoOYBUBTwFzff/TlLOSbsQMjOQT1g/Hi
7bel/GHe1yEpNO28eRi1LhfC20ml2iBXfYNFWlPA8XxrLsENPbFhzjOhUyiPDedD
hzOYHGDvt7ZARj3uiQZMWOYIJBtAcL4/jh8F/QPjQIbNeyervHG0Ag1RzpJjvCv8
QIbosUdxn7y6CkblY9zX7oT/fpUV27Y0sUn45dR+jI/Bxlh2RAcnDwcEpYRIoGWK
eVAlNuk8MobsQ7TZ/9/K
=e9bl
-----END PGP SIGNATURE-----

--Sig_/xD+bwy2Mh.Es8SEK6xItDRZ--
