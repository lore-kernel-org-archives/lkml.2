Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1LDQD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:03:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59418 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037Ab1LDQDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:03:23 -0500
Message-ID: <1323014582.7454.121.camel@deadeye>
Subject: Re: [PATCH 04/16] PGP: Add definitions (RFC 4880) and packet parser
 [ver #2]
From: Ben Hutchings <ben@decadent.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Date: Sun, 04 Dec 2011 16:03:02 +0000
In-Reply-To: <20111129234348.13625.33435.stgit@warthog.procyon.org.uk>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
	 <20111129234348.13625.33435.stgit@warthog.procyon.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rjWCtqAnkqGrTglbejWa"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rjWCtqAnkqGrTglbejWa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-11-29 at 23:43 +0000, David Howells wrote:
> Add some useful PGP definitions from RFC 4880.  These describe details of
> public key crypto as used by crypto keys for things like signature
> verification.
[...]
> +struct pgp_signature_v3_packet {
> +	enum pgp_signature_version version : 8; /* =3D=3D PGP_SIG_VERSION_3 */
> +	u8	length_of_hashed;	/* =3D=3D 5 */
> +	struct {
> +		enum pgp_signature_type signature_type : 8;
> +		struct pgp_time	creation_time;
> +	} hashed;
> +	struct pgp_key_ID issuer;
> +	enum pgp_pubkey_algo pubkey_algo : 8;
> +	enum pgp_hash_algo hash_algo : 8;
> +};
> +
> +struct pgp_signature_v4_packet {
> +	enum pgp_signature_version version : 8;	/* =3D=3D PGP_SIG_VERSION_4 */
> +	enum pgp_signature_type signature_type : 8;
> +	enum pgp_pubkey_algo pubkey_algo : 8;
> +	enum pgp_hash_algo hash_algo : 8;
> +};
[...]
> +struct pgp_key_v3_packet {
> +	enum pgp_key_version version : 8;
> +	struct pgp_time	creation_time;
> +	u8 expiry[2];				/* 0 or time in days till expiry */
> +	enum pgp_pubkey_algo pubkey_algo : 8;
> +	u8 key_material[0];
> +};
> +
> +struct pgp_key_v4_packet {
> +	enum pgp_key_version version : 8;
> +	struct pgp_time	creation_time;
> +	enum pgp_pubkey_algo pubkey_algo : 8;
> +	u8 key_material[0];
> +};
[...]

I'm a little uneasy about these structure definitions.  There have been
C ABIs that set the structure alignment to at least 4 by default.  It
may be better to play safe by declaring them '__packed'.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-rjWCtqAnkqGrTglbejWa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATtuZtue/yOyVhhEJAQqO6w/+OrCJmoYLVlkK0a753Tk9tqC+FC+9QnPx
81z0qUBhfr/AhaJiEID/FqwqjZ/0MKilsTN2LHjnS2zP4QsWqU4pYsJR+bwv2m8H
n6TA5Y1qy4mmtq7EdgmXfjNobPP27xmGN2Ow6vGbsNiLthqnUYdhFQZYgvnL0TGW
wNjscz1rC8TTQS6dL/xtE5YDrcSbSny+qG5sccKVcOHKr8RzRHwMWn5sCbooZQ8e
2j7mhNzBiqOFUmBUHOV8XWlZN0kEbNQQoX6j4xRhqrSfw1I6aQ6H+qHp5Qapn/Xs
rajOBURXLuTwcU7iXlvaBbbLOD6YLiPQEcJNdyJ2jVyAbiLGcze2R7uYsWTTB6qv
OWyAoiUM+yFkWgG7npTJHTobzhZ9QUPHa+P99RMY64sIVLklHFRbFBiDv66NfwwG
Ku+E6Qs/TSa53+GeZe8pXcY2AKpNia9LGSWkFsQegx3zB4PQb2qoToFNPWkFYJM5
cvp0A3Gj2zZXQm6UySLD0cmsclr/w7u8E3SpJKS9KC3SPjssBcJQzuAhjngw8j5/
9yNSHTv43Qrw3/sgSZDjushwDZpiBeLy3fmD5cuiCa6k/chCPyY2FkB3axfD54Vs
+jt1hZKWiwanaYB+fR5Lop15+uvcPkrE8KmnPKRtwqwEyNGQWkW7Jdypu+1agML4
LsK7Lv/t1u0=
=UM0z
-----END PGP SIGNATURE-----

--=-rjWCtqAnkqGrTglbejWa--
