Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab2K0CSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:18:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38397 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932633Ab2K0CSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:18:49 -0500
Message-ID: <1353982714.4266.36.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 026/270] powerpc/eeh: Lock module while handling EEH
 event
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 27 Nov 2012 02:18:34 +0000
In-Reply-To: <1353949160-26803-27-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-27-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JR2eYwwLijF5nfsgxCt/"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JR2eYwwLijF5nfsgxCt/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Gavin Shan <shangw@linux.vnet.ibm.com>
>=20
> commit feadf7c0a1a7c08c74bebb4a13b755f8c40e3bbc upstream.
>=20
> The EEH core is talking with the PCI device driver to determine the
> action (purely reset, or PCI device removal). During the period, the
> driver might be unloaded and in turn causes kernel crash as follows:
>=20
> EEH: Detected PCI bus error on PHB#4-PE#10000
> EEH: This PCI device has failed 3 times in the last hour
> lpfc 0004:01:00.0: 0:2710 PCI channel disable preparing for reset
> Unable to handle kernel paging request for data at address 0x00000490
> Faulting instruction address: 0xd00000000e682c90
> cpu 0x1: Vector: 300 (Data Access) at [c000000fc75ffa20]
>     pc: d00000000e682c90: .lpfc_io_error_detected+0x30/0x240 [lpfc]
>     lr: d00000000e682c8c: .lpfc_io_error_detected+0x2c/0x240 [lpfc]
>     sp: c000000fc75ffca0
>    msr: 8000000000009032
>    dar: 490
>  dsisr: 40000000
>   current =3D 0xc000000fc79b88b0
>   paca    =3D 0xc00000000edb0380	 softe: 0	 irq_happened: 0x00
>     pid   =3D 3386, comm =3D eehd
> enter ? for help
> [c000000fc75ffca0] c000000fc75ffd30 (unreliable)
> [c000000fc75ffd30] c00000000004fd3c .eeh_report_error+0x7c/0xf0
> [c000000fc75ffdc0] c00000000004ee00 .eeh_pe_dev_traverse+0xa0/0x180
> [c000000fc75ffe70] c00000000004ffd8 .eeh_handle_event+0x68/0x300
> [c000000fc75fff00] c0000000000503a0 .eeh_event_handler+0x130/0x1a0
> [c000000fc75fff90] c000000000020138 .kernel_thread+0x54/0x70
> 1:mon>
>=20
> The patch increases the reference of the corresponding driver modules
> while EEH core does the negotiation with PCI device driver so that the
> corresponding driver modules can't be unloaded during the period and
> we're safe to refer the callbacks.
>=20
> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> [ herton: backported for 3.5, adjusted driver assignments, return 0
>   instead of NULL, assume dev is not NULL ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
[...]

Greg, you probably want this in 3.4 and 3.6.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-JR2eYwwLijF5nfsgxCt/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULQi+ue/yOyVhhEJAQqlTg//R+OMy5r+VFhGNQl4MrQrg9yI1c/xrhar
W5zYHnxzvioLclc5kgRi67umKEyyLRtzRb8+Ge2O8GtMMzy+1wfFZA5M9Rvlq7Og
/q6pm0zJpaxh8MX3IWgPejrEHcHMCjt//9EeDdynfwbXH6Dpl907KHMBBaHtvdeE
L7J1jfLeox+B23ZS6tshUyw9UXTS4R6FujCpA4rZVnT5R9CE8x0DTNOIKvE+zX/P
kcs8RicId68RBpmCT5gFQMIL910xRv3P9Z2h4pfe2TBKGCJVNzd9J6QZdQtHrpZm
q8tXe81NfJACq5lmX69odyI6iiXE6QWpQKmaHBZackePXwuj/mLVw5xU7jJDkCan
gSucMoQ3cwx/pmF2EXXBvqLrOU5ra0R0e8TNBQlyhCy+t2lgPJJNny4ed/ANXPgY
lRAGaujgRB6gkN761ujqx3ojVFqj+pSCheUwWmdoNOcDrt/q7+4AfDDaF0+25lkx
HmMv2m7pie5LTKsr47kQ7a6ovZ3u0hkqxtP4aw3wWRIQVQUzvcshSzwgEW6pW4Yu
lVakot4/B9i3W8J3ZRCJJl1UdHMllCp6UfCF50UVpjfxJ3IVfNCbUDAw9+3jSLfL
W/q4DFthhE3sVyqQ0FaSDgNstEzlnKh4Yuh5DgHmKGayUPy6tUHKDIZGy/PQZ3aU
viIn9SKver8=
=WY1J
-----END PGP SIGNATURE-----

--=-JR2eYwwLijF5nfsgxCt/--
