Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab1KKRcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:32:50 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:38846 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753269Ab1KKRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:32:48 -0500
Date: Fri, 11 Nov 2011 09:33:07 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Rework ASPM disable code
Message-ID: <20111111093307.3072ce80@jbarnes-desktop>
In-Reply-To: <1320961113-5050-1-git-send-email-mjg@redhat.com>
References: <1320961113-5050-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r0St16k.wJdPI9cNAnTP/eh"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/r0St16k.wJdPI9cNAnTP/eh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Nov 2011 16:38:33 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> Right now we forcibly clear ASPM state on all devices if the BIOS indicat=
es
> that the feature isn't supported. Based on the Microsoft presentation
> "PCI Express In Depth for Windows Vista and Beyond", I'm starting to think
> that this may be an error. The implication is that unless the platform
> grants full control via _OSC, Windows will not touch any PCIe features -
> including ASPM. In that case clearing ASPM state would be an error unless
> the platform has granted us that control.
>=20
> This patch reworks the ASPM disabling code such that the actual clearing
> of state is triggered by a successful handoff of PCIe control to the OS.
> The general ASPM code undergoes some changes in order to ensure that the
> ability to clear the bits isn't overridden by ASPM having already been
> disabled. Further, this theoretically now allows for situations where
> only a subset of PCIe roots hand over control, leaving the others in the
> BIOS state.
>=20
> It's difficult to know for sure that this is the right thing to do -
> there's zero public documentation on the interaction between all of these
> components. But enough vendors enable ASPM on platforms and then set this
> bit that it seems likely that they're expecting the OS to leave them alon=
e.
>=20
> Measured to save around 5W on an idle Thinkpad X220.
>=20

Applied to linux-next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/r0St16k.wJdPI9cNAnTP/eh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOvVxTAAoJEIEoDkX4Qk9hiKIQALTMeSwgIeQ2G9z7J+0/f7Rw
dpnIiyR5BMEQpaaoLnXgv8GCuSfF5hhc0m/WGZlgN79eLhrYIHieqNLAkKDuwdGM
K6i3/i7igm11bu+92t5045aTyHQk2VAZc4eSUEj7lZdBgIcLYBlXKgECfgS+2rGO
CuhobcM0iSzvwjz9y4Z5+2dcGg6NPVn0fKRyVW8iLzrCbyZoCviGjwTGYlXSsyad
Eo67JFjylQkGRKRn1uWPqqlFr+DjRLjrvXI2Fq4A4ak4ZRtHimLwYLUOkUetMYEC
aq2SxEkORA3MJLtHgeUMVNoe1VwN3tOAflQ/CbYheXCcFTPi7yEzS4fnhNq/87rx
G2+r12DGAsjxP9PbU5Uk/UPB6Bcd4Avgu4WrEUsKbT/ZrMerXs7/224lyXtKROqs
KcxOedUgocNwljWVHDr1z+MMz6iqK3Dp+YAGmYl4Xjx4jjhWuUrTswIj2AWEU7M5
rpwWiWfyg5v6YCe194sokFpqSmL0MWhSyp8cJVMUqrY1VgX3QPC2G5ZIL/u0R46c
csk2zhvIxCioVNki2QPig24T3ZxDEuivZsXbis1cWKRqPu5cKbIBYWM1gcy+t1Hp
yxU7OYUR1LA0FytHOTY8G8Nx7GVdQffHqGnvMduVb3X4sr5a0QWw+zarqVZBJZB3
foi94HROk/Q0UYada//y
=2nAz
-----END PGP SIGNATURE-----

--Sig_/r0St16k.wJdPI9cNAnTP/eh--
