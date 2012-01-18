Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2AREsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:48:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34711 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756851Ab2AREsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:48:11 -0500
Message-ID: <1326862077.2819.210.camel@deadeye>
Subject: Re: [PATCH stable 3/4] block: fail SCSI passthrough ioctls on
 partition devices
From: Ben Hutchings <ben@decadent.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>
Date: Wed, 18 Jan 2012 04:47:57 +0000
In-Reply-To: <4F1545A4.3000809@redhat.com>
References: <1326772723.2819.167.camel@deadeye>
	 <1326773222.2819.172.camel@deadeye> <4F1545A4.3000809@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FE94jOlm1DYjN7M5tY4u"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FE94jOlm1DYjN7M5tY4u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-01-17 at 10:55 +0100, Paolo Bonzini wrote:
> On 01/17/2012 05:07 AM, Ben Hutchings wrote:
> > Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>
> > [bwh: Backport to 2.6.32 - ENOIOCTLCMD does not get converted to
> >   ENOTTY, so we must return ENOTTY directly]
> > Signed-off-by: Ben Hutchings<ben@decadent.org.uk>
>=20
> Have you tested 32-on-64?  I already did this change in the version for=
=20
> 3.2 stable, but sd_compat_ioctl has to keep ENOIOCTLCMD:

Not specifically...

> > [ Cherry picked from 3ed4e7ba4be8c72051d87dcb2dec279d97a18d41
> >
> >   Changes with respect to 3.3: return -ENOTTY from scsi_verify_blk_ioct=
l
> >   and -ENOIOCTLCMD from sd_compat_ioctl. ]

But in 2.6.32, compat_sys_ioctl will end up returning EINVAL rather than
ENOTTY for an unhandled ioctl number.  Also, since we're denying ioctls
for security reasons rather than because we don't know how to handle
them, I don't think there's any harm in doing this.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-FE94jOlm1DYjN7M5tY4u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATxZO/ee/yOyVhhEJAQrtBhAAzEpzHAzBalhC016w6FeKev+YtuptQFYo
K5tn+UlE372igznVlB1bN9bU9HJ1wnC3Q4OiLH5uWYzwDer6UekJj2APiD7+UdU4
d78ylkvmGsVnsak2y+LVceVa25QB24Osce1eb9do9QE0SWmWNSDbcIny30i+4NLA
oPOCZU5EA/JU2k49+hi8dt1ps97PgB4Bj50IGDxPZ4NLNKNwSnhrkg9WQP2EKEng
TD8lH7f0Kb6IR7SIAKcqqVJPDCJDnjaXRY7NWqSA2ohqGVOqFkTksynPE72tLmri
icNAbBUHb4v298O5jjT+A804dUQ6ASL3K6cz3uleV0KnyVvJjrSRBfWKc+k3CA1C
ffa/43d+tlUwqFz7oRXH5q4QultGXlff4WmXp3+EkLBVYo7Xa5a7Otg30McZ7m0o
TfCPiyBcLt6PzmgvoNtSMAeSGyZjareLQhowp4igMtkrpv4UUyFD6ed7hG/9cf6o
VHpwoaBbAcTdrGalhbDW9RbNiD+VWbeQLKKh/U0hXhobt5dl49Dmh1Awa3uJbq6F
l1SWZFtYNHv87c7NTV9AgK0ok5okilH6xjXYrsfelb4j6ebcmDyRg+SiX2IgVvkb
DD+5kMsSgfCrfcpmcSunPdNsM9yyXnxmY2ivqUV590mVKoBcshv7sRLzT7dQ7yrE
/9a9xYXAkGQ=
=h62D
-----END PGP SIGNATURE-----

--=-FE94jOlm1DYjN7M5tY4u--
