Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1KKR2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:28:09 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42979 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753684Ab1KKR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:28:06 -0500
Date: Fri, 11 Nov 2011 09:28:11 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Rework ASPM disable code
Message-ID: <20111111092811.54a03027@jbarnes-desktop>
In-Reply-To: <CACna6rwxWUtfa2uz1hXVUthSpJF6SKP3V-ERt0=3oVQ2KKEo=g@mail.gmail.com>
References: <1320961113-5050-1-git-send-email-mjg@redhat.com>
	<CACna6rwxWUtfa2uz1hXVUthSpJF6SKP3V-ERt0=3oVQ2KKEo=g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.MBNHS/g+64/X46UHts1VUw"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.MBNHS/g+64/X46UHts1VUw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Nov 2011 10:49:02 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> 2011/11/10 Matthew Garrett <mjg@redhat.com>:
> > Right now we forcibly clear ASPM state on all devices if the BIOS indic=
ates
> > that the feature isn't supported. Based on the Microsoft presentation
> > "PCI Express In Depth for Windows Vista and Beyond", I'm starting to th=
ink
> > that this may be an error. The implication is that unless the platform
> > grants full control via _OSC, Windows will not touch any PCIe features -
> > including ASPM. In that case clearing ASPM state would be an error unle=
ss
> > the platform has granted us that control.
> >
> > This patch reworks the ASPM disabling code such that the actual clearing
> > of state is triggered by a successful handoff of PCIe control to the OS.
> > The general ASPM code undergoes some changes in order to ensure that the
> > ability to clear the bits isn't overridden by ASPM having already been
> > disabled. Further, this theoretically now allows for situations where
> > only a subset of PCIe roots hand over control, leaving the others in the
> > BIOS state.
> >
> > It's difficult to know for sure that this is the right thing to do -
> > there's zero public documentation on the interaction between all of the=
se
> > components. But enough vendors enable ASPM on platforms and then set th=
is
> > bit that it seems likely that they're expecting the OS to leave them al=
one.
> >
> > Measured to save around 5W on an idle Thinkpad X220.
> >
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
>=20
> Does it make sense to CC stable? To get it into 2.6.38+?

It's a pretty serious change that affects a lot of platforms, so I'd be
nervous about sticking it in stable right away.  Maybe after some soak
time upstream and/or broad testing in distros.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/.MBNHS/g+64/X46UHts1VUw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOvVsrAAoJEIEoDkX4Qk9hABcP/1eENSG0J1UOQx6hdVL6BHOt
aKFD88odJqb12rQ3G0pvvf5pygBFHTgFMYMbrixyxLOCiiFDZ64oyV+przAlkpn9
zW9vcb6q0VonwhdhpapiPcwQfZfTSQVQqQ8sdoqYg6+JiTizgtaBqFhEKyelcIIl
OrybBKUr+5d480OJQ2Z9wLm3ggDuMlfDqGQfiHpvkTHdbYqPCtU2vwfL+wJ/z63L
wcGIGm27x0Ttv7V7MqvP0iF/saa7mmDGldxlaxkPqrU7HtRWQ26t8d8hsWrv2cww
qtuQXloeeioxXYKdfNATB2Gr+6YumMKl3WG7z4xwLlH3p7EdCNiBchHEOuZ1uM7C
uKeCDN3ttd0P2LpMKkd3laDzJlv9NZ4is4iZ/sirbuPrkOQy1o3hC1uhnSUeXjLf
sdWrvw1TG/vV7srm6FyvusdXD8w97CG6o0Nt7Ja1wOMJUYMwo+KGh8vzAK96gUTl
4QyHoCTE5JImbTaE5GwbBMOK9j9eGxFZ107bQshTp5H41oOV2XD2hnIlds2omzRA
b/9ZCOz0xCpxODgbNuNikyWYDYGQsiA0m3rix9g5ikX1mF3gPT4F4skkE2ArBPgp
eSXO6ewyFLmd2MVKDuPOg2X+Z/NXoAjjkQ5l5Grx289vfD2XABe9DjOKg3OwyjKU
6Xh7XjQjzjAprnIEcx4M
=VUiW
-----END PGP SIGNATURE-----

--Sig_/.MBNHS/g+64/X46UHts1VUw--
