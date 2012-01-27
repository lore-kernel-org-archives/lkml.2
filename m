Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2A0S0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:26:06 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:55225 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753393Ab2A0S0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:26:03 -0500
Date: Fri, 27 Jan 2012 10:25:59 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/21] PCI: only enable pci realloc when SRIOV bar is
 not assigned
Message-ID: <20120127102559.1c2cb65a@jbarnes-desktop>
In-Reply-To: <1327140517-14811-22-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
	<1327140517-14811-22-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5Y5XoT9whJ4K6NON.Tqyd0W"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5Y5XoT9whJ4K6NON.Tqyd0W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 02:08:37 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> If bios does not assign those BAR or wrong address, then kernel will
> try to do pci realloc.
>=20
> in that case, user still can use pci=3Drealloc=3Doff to override it.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>=20

I worry about this one; distros may enable IOV to keep a unified kernel
binary and end up messing up all sorts of systems that happen to have
IOV devices that the user doesn't actually care about.

I'd prefer to leave it disabled by default, and let drivers spew a
message about IOV resources being unavailable and mentioning the
realloc=3D param...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/5Y5XoT9whJ4K6NON.Tqyd0W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIuw3AAoJEIEoDkX4Qk9h4pQP/iQSyyBcy7pwphXMOVFGHJ5/
CnVvltQHJWPk03OZbfXTxIonOadmUvtM+/JpNzpQAcoFsJwhMwGVq5qOR+Of1jev
FyY3OMlTMr860pZvkdKCSV++YcWQ/atklrM7X4ZrWJPrH4L1E4F3EBjjCvP+5sB1
k+09stfQvCsCzJ0C80cE7Rs5xelTn3xru/kv9nqppx6LqW/2kYEcwSbgOnddriQG
VL001GWY5WTdaCjU3EpS9I0scUHzKks+btVm+2DK7omNd2AnHgK6ilvRMqWg7E2H
EM8hJXxtE0XLx2oSpKgEVkhZHL3pqOvnJDF4vbaFPKqPlNWbmZ++plOHkmunk4bG
8udYOgkoarTQtfp4z80faaYt/rwoFyksBw3T1Ofwm4B6rjlyhECX9JMAlX5/yj25
YYyVry9NQFqH4BGDB0UdrPdDHI4QzqcWm//uiYC6hiKRovP/jNb+okdmevh6WevC
rMS/hNdV3WPTOMu25CS6VFMF/D5HpufyXcmHR6PJt50IkP4Y9ZCtFsnTrhygCvnU
jmo+YcUWZ8wpyn2kQfjenxfDEudTP6AK81mR4MhEZRBKzMKzEzh+7qWBpZEZzuU5
AyGUzmXszkTbNVn8mEuJ6RNM1hTqXEaFUFhsuhiBreZ9+rZybQd4RtsWENHSubGF
gRM96zjx2gbuCZiEKDr2
=6POi
-----END PGP SIGNATURE-----

--Sig_/5Y5XoT9whJ4K6NON.Tqyd0W--
